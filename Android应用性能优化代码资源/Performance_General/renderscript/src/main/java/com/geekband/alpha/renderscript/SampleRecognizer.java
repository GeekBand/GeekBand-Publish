package com.geekband.alpha.renderscript;

import android.app.Activity;
import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.support.v8.renderscript.Allocation;
import android.support.v8.renderscript.Element;
import android.support.v8.renderscript.RenderScript;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.SeekBar;
import android.widget.TextView;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class SampleRecognizer extends Activity implements SeekBar.OnSeekBarChangeListener {

    enum RecordingState {
        IDLE,
        RECORD_REF,
        RECORD
    }
    static final int SAMPLERATE = 44100;
    static final int POWER_WINDOW_LEN = 40;
    static final String LOG_TAG = "SampleRecognizer";
    static final boolean EXTERNAL_FILE = true;
    static final boolean DEBUG_FILE = true;
    static final String FILE_REFNAME = "ref.raw";
    static final String FILE_SAMPLESNAME = "samples.raw";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        recordingState = RecordingState.IDLE;
        recorder = null;
        uiHandler = new Handler();
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sample_recognizer);
        btnRecordRef = (Button) findViewById(R.id.btn_recordref);
        btnRecordRef.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                recordRef();
            }
        });
        btnRecord = (Button) findViewById(R.id.btn_record);
        btnRecord.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                record();
            }
        });
        tvStatus = (TextView) findViewById(R.id.tv_status);
        btnStop = (Button) findViewById(R.id.btn_stop);
        btnStop.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                stopRecord();
            }
        });
        tvDistance = (TextView) findViewById(R.id.tv_distance);
        sbDistance = (SeekBar) findViewById(R.id.sb_distance);
        sbDistance.setOnSeekBarChangeListener( this );
        updateLimitDistanceFromSeekBar();
    }



    @Override
    public void onProgressChanged(SeekBar seekBar, int progress,
                                  boolean fromUser) {
        updateLimitDistanceFromSeekBar();
    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {
    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {
    }

    private void updateLimitDistanceFromSeekBar() {
        int pos = sbDistance.getProgress();
        pos += 300;
        tvDistance.setText( Integer.toString( pos ));
        limitDistance = pos;
    }

    private void recordRef() {
        btnRecordRef.setClickable(false);
        btnRecord.setClickable(false);
        btnStop.setVisibility(View.VISIBLE);
        tvStatus.setText(R.string.text_recordingref);
        recordingState = RecordingState.RECORD_REF;
        initializeRecording( FILE_REFNAME,false);
    }

    private void record() {
        btnRecordRef.setClickable(false);
        btnRecord.setClickable(false);
        btnStop.setVisibility(View.VISIBLE);
        tvStatus.setText(R.string.text_recording);
        recordingState = RecordingState.RECORD;
        initializeRecording( FILE_SAMPLESNAME,true);
    }

    private void stopRecord() {
        if( audioReaderThread != null ) {
            audioReaderThread.interrupt();
            audioReaderThread = null;
        }
    }

    private void stopRecordUI(String msg) {
        btnRecordRef.setClickable(true);
        btnRecord.setClickable(true);
        btnStop.setVisibility(View.INVISIBLE);
        if( msg != null )
            tvStatus.setText(msg);
        else
            tvStatus.setText( R.string.text_idle);
        recordingState = RecordingState.IDLE;
    }

    private void initializeRecording( String fname, boolean needsAnalysis) {
        bufferSize = AudioRecord.getMinBufferSize(
                SAMPLERATE,
                AudioFormat.CHANNEL_IN_MONO,
                AudioFormat.ENCODING_PCM_16BIT)*4;
        Log.d(LOG_TAG, "bufferSize: " + bufferSize);
        recorder = new AudioRecord(
                MediaRecorder.AudioSource.MIC,
                SAMPLERATE,
                AudioFormat.CHANNEL_IN_MONO,
                AudioFormat.ENCODING_PCM_16BIT,
                bufferSize
        );
        audioBuffer = new byte[ bufferSize ];
        fos = null;
        if( EXTERNAL_FILE ) {
            File f = new File( Environment.getExternalStorageDirectory(),fname );
            try {
                fos = new FileOutputStream( f );
            } catch (FileNotFoundException e) {
                String errMsg = "Cannot open file: "+f.getAbsolutePath();
                Log.e( LOG_TAG, errMsg ,e );
                stopRecordUI( errMsg );
            }
        }
        else {
            try {
                fos = openFileOutput( fname, MODE_PRIVATE);
            } catch (FileNotFoundException e) {
                String errMsg = "Cannot open file: "+fname;
                Log.e( LOG_TAG, errMsg ,e );
                stopRecordUI( errMsg );
            }
        }
        audioReaderThread = new AudioReaderThread(needsAnalysis);
        audioReaderThread.start();
    }

    private int findReferenceSignalJava() throws IOException {
        short refSignal[] = readSignal( FILE_REFNAME );
        double refPower = calculateMaxPower( refSignal, POWER_WINDOW_LEN );
        short recSignal[] = readSignal( FILE_SAMPLESNAME);
        scaleSignalByPower( recSignal,refPower, POWER_WINDOW_LEN );
        long t1 = System.currentTimeMillis();
        int d = distanceLM( refSignal,recSignal);
        long t2 = System.currentTimeMillis();
        dt = t2 - t1;
        Log.d( LOG_TAG,"distanceLM: timestamp: "+dt);
        Log.d( LOG_TAG, "distance (Java): "+d);
        return d;
    }

    private int findReferenceSignalJavaF() throws IOException {
        short refSignal[] = readSignal( FILE_REFNAME );
        double refPower = calculateMaxPower( refSignal, POWER_WINDOW_LEN );
        short recSignal[] = readSignal( FILE_SAMPLESNAME);
        scaleSignalByPower( recSignal,refPower, POWER_WINDOW_LEN );
        long t1 = System.currentTimeMillis();
        int s1len = refSignal.length;
        int s2len = recSignal.length;
        int d0[] = new int[s1len];
        int d1[] = new int[s1len];
        int d = distanceLMF( refSignal,recSignal,d0,d1,s1len,s2len);
        long t2 = System.currentTimeMillis();
        dt = t2 - t1;
        Log.d( LOG_TAG,"distanceLM: timestamp: "+dt);
        Log.d( LOG_TAG, "distance (JavaF): "+d);
        return d;
    }


    private int findReferenceSignalC99() throws IOException {
        short refSignal[] = readSignal( FILE_REFNAME );
        double refPower = calculateMaxPower( refSignal, POWER_WINDOW_LEN );
        short recSignal[] = readSignal( FILE_SAMPLESNAME);
        scaleSignalByPower( recSignal,refPower, POWER_WINDOW_LEN );
        long t1 = System.currentTimeMillis();
        RenderScript rsC = RenderScript.create( this);
        ScriptC_dtw script = new ScriptC_dtw(
                rsC,
                getResources(),
                R.raw.dtw);
        script.set_s1len( refSignal.length);
        Allocation signal1Allocation = Allocation.createSized(
                rsC,
                Element.I16(rsC),
                refSignal.length);
        signal1Allocation.copyFrom(refSignal);
        script.bind_signal1(signal1Allocation);
        script.set_s2len( recSignal.length);
        Allocation signal2Allocation = Allocation.createSized(
                rsC,
                Element.I16(rsC),
                recSignal.length);
        signal2Allocation.copyFrom(recSignal);
        script.bind_signal2(signal2Allocation);
        Allocation d0Allocation = Allocation.createSized(
                rsC,
                Element.I32(rsC),
                refSignal.length);
        script.bind_d0(d0Allocation);
        Allocation d1Allocation = Allocation.createSized(
                rsC,
                Element.I32(rsC),
                refSignal.length);
        script.bind_d1(d1Allocation);
        Allocation rAllocation = Allocation.createSized(
                rsC,
                Element.I32(rsC),
                1);
        script.bind_r(rAllocation);
        script.invoke_dtw();
        rsC.finish();
        Log.d( LOG_TAG,"invoke_dtw: timestamp: "+dt);
        int result[] = new int[1];
        rAllocation.copyTo(result);
        long t2 = System.currentTimeMillis();
        dt = t2 - t1;
        int maxc = result[0];
        Log.d(LOG_TAG, "maxc: "+maxc);
        int l = Math.max(recSignal.length, refSignal.length);
        maxc /= l;
        Log.d( LOG_TAG, "distance (C99): "+maxc);
        rsC.destroy();
        return maxc;
    }


    private short[] trimSignal(
            short signal[],
            int scalingFactor ) {
// Search first for power maximum
        int max_power = 0;
        for( int i = 0 ; i < signal.length ; ++i ) {
            int v = (int)signal[i];
            int pw = v*v;
            if( pw > max_power )
                max_power = pw;
        }
        int start_index = 0;
        int end_index = 0;
        int limit_pw = max_power / 10;
        for( int i = 0 ; i < signal.length ; ++i ) {
            int v = (int)signal[i];
            int pw = v*v;
            if( pw > limit_pw ) {
                start_index = i;
                break;
            }
        }
        for( int i = signal.length - 1 ; i >= 0 ; --i ) {
            int v = (int)signal[i];
            int pw = v*v;
            if( pw > limit_pw ) {
                end_index = i;
                break;
            }
        }
        int dlen = end_index-start_index + 1;
        dlen /= scalingFactor;
        short result[] = new short[dlen];
        int target = 0;
        for( int i = start_index ; i<= end_index ; i += scalingFactor ) {
            if( target < dlen )
                result[target] = signal[i];
            ++target;
        }
        return result;
    }

    private double calculateMaxPower( short samples[],
                                      int wlen) {
        // Search first for maximum power
        PowerWindow pw = new PowerWindow( wlen );
        double maxPower = 0.0;
        for( int i = 0 ; i < samples.length ; ++i ) {
            double v = pw.putValue((double)samples[i]);
            if( v > maxPower )
                maxPower = v;
        }
        return maxPower;
    }

    private void scaleSignalByPower( short samples[],
                                     double maxPower1,
                                     int wlen ) {
        double maxPower2 = calculateMaxPower( samples, wlen);
// Calculate scaling factor
        double scaling_factor = Math.sqrt( maxPower1/maxPower2);
        for( int i = 0 ; i < samples.length ; ++i ) {
            double v = scaling_factor * (double)samples[i];
            samples[i] = (short)v;
        }
    }

    private short[] readSignal(String fname) throws IOException {
        File fisf = null;
        if( EXTERNAL_FILE )
            fisf = new File( Environment.getExternalStorageDirectory(),fname );
        else
            fisf = getFileStreamPath( fname );
        FileInputStream fis = new FileInputStream( fisf );
        int flenInShorts = ((int)fisf.length()) / 2;
        short result[] = new short[flenInShorts];
        for( int i = 0 ; i < flenInShorts ; ++i ) {
            int b1 = fis.read();
            if( b1 < 0 )
                break;
            int b2 = fis.read();
            if( b2 < 0 )
                break;
            int v = b1 + ( b2 << 8 );
            if( v > 32767 )
                v = - ( 65536 - v );
            result[i] = (short)v;
        }
        fis.close();
        result = trimSignal( result,5 );
        return result;
    }

    int distance( short signal1[], short signal2[]) {
        int s1len = signal1.length;
        int s2len = signal2.length;
        int d[][] = new int[s1len][s2len];
        int s = 0;
        for( int i = 0 ; i < s1len ; ++i ) {
            s += signalCost((int)signal1[i],(int)signal2[0]);
            d[i][0] = s;
        }
        s = 0;
        for( int i = 0 ; i < s2len ; ++i ) {
            s += signalCost((int)signal1[0],(int)signal2[i]);
            d[0][i] = s;
        }
        for( int x = 1 ; x < s1len ; ++x )
            for( int y = 1 ; y < s2len ; ++y ) {
                s = signalCost( (int)signal1[x],(int)signal2[y]);
                int m = Math.min(d[x-1][y-1],d[x-1][y] );
                m = Math.min( m, d[x][y-1]);
                d[x][y] = s+m;
            }
        int maxc = d[s1len-1][s2len-1];
        int l = Math.max(s1len, s2len);
        maxc /= l;
        return maxc;
    }

    int distanceLM( short signal1[], short signal2[]) {
        int s1len = signal1.length;
        int s2len = signal2.length;
        int d0[] = new int[s1len];
        int d1[] = new int[s1len];
        int s = 0;
        for( int x = 0 ; x < s1len ; ++x ) {
            s += signalCost((int)signal1[x],(int)signal2[0]);
            d0[x] = s;
        }
        s = 0;
        for( int y = 1 ; y < s2len ; ++y ) {
            s += signalCost((int)signal1[0],(int)signal2[y]);
            d1[0] = s;
            for( int x = 1 ; x < s1len ; ++x ) {
                int cs = signalCost( (int)signal1[x],(int)signal2[y]);
                int m = Math.min(d0[x-1],d1[x-1] );
                m = Math.min( m, d0[x]);
                d1[x] = cs+m;
            }
            for( int x = 0 ; x < s1len ; ++x )
                d0[x] = d1[x];
//			System.arraycopy(d1, 0, d0, 0, s1len);
        }
        int maxc = d1[s1len-1];
        int l = Math.max(s1len, s2len);
        maxc /= l;
        return maxc;
    }


    int signalCost( int x1, int x2 ) {
        return Math.abs( x1-x2 );
    }

    int distanceLMF(final short signal1[], final short signal2[], final int d0[], final int d1[], final int s1len, final int s2len)
    {
        int s = 0;
        int signal2Y = signal2[0];

        for (int x = 0; x < s1len; x++)
        {
            d0[x] = (s += Math.abs(signal1[x] - signal2Y));
        }

        for (int y = 1; y < s2len; y++)
        {
            signal2Y = signal2[y];

            d1[0] += Math.abs(signal1[0] - signal2Y);

            for (int x = 1; x < s1len; x++)
            {
                //      cs
                d1[x] = Math.abs(signal1[x] - signal2Y) + Math.min( Math.min(d0[x - 1], d1[x - 1]), d0[x] );
            }

            System.arraycopy(d1, 0, d0, 0, s1len);
        }

        // max c        length
        return d1[s1len - 1] / Math.max(s1len, s2len);
    }

    TextView tvStatus;
    TextView tvDistance;
    SeekBar sbDistance;
    Button btnStop;
    Button btnRecordRef;
    Button btnRecord;
    RecordingState recordingState;
    AudioRecord recorder;
    int bufferSize;
    byte audioBuffer[];
    FileOutputStream fos;
    AudioReaderThread audioReaderThread;
    Handler uiHandler;
    int limitDistance;
    private long dt = 0L;

    class AudioReaderThread extends Thread {
        public AudioReaderThread( boolean needsAnalysis) {
            this.needsAnalysis = needsAnalysis;
        }

        public void run() {
            String errMsg = null;
            recorder.startRecording();
            while(!isInterrupted()) {
                int len = recorder.read(audioBuffer,0,bufferSize);
                if( len > 0 ) {
                    try {
                        fos.write(audioBuffer,0,len);
                    } catch (IOException e) {
                        Log.e(LOG_TAG, "buffer write error",e);
                        errMsg = "Write error";
                    }
                } else {
                    errMsg = "Stopped";
                    break;
                }
            }
            recorder.stop();
            recorder.release();
            try {
                fos.close();
            } catch (IOException e) {
                Log.e( LOG_TAG, e.getMessage(),e);
                errMsg = "File close error";
            }
            recorder = null;
            if( errMsg != null ) {
                StopRecordingUI statusTask = new StopRecordingUI( errMsg );
                uiHandler.post( statusTask );
            } else {
                if( needsAnalysis ) {
                    UpdateStatus statusTask = new UpdateStatus( getString( R.string.find_reference),true);
                    uiHandler.post( statusTask );
                    String result = null;
                    try {
                        int distanceJava = findReferenceSignalJava();
                        long dtJava = dt;
                        Log.d( LOG_TAG, "Java implementation, execution time: "+dtJava+" msec");
                        int distanceJavaF = findReferenceSignalJavaF();
                        long dtJavaF = dt;
                        Log.d( LOG_TAG, "Java implementation, fast, execution time: "+dtJavaF+" msec");
                        int distanceC99 = findReferenceSignalC99();
                        long dtC99 = dt;
                        Log.d( LOG_TAG, "C99 implementation, execution time: "+dtC99+" msec");

                        boolean found = distanceJava < limitDistance;
                        result = found ?
                                getString( R.string.ref_signal_found)
                                :
                                getString( R.string.ref_signal_not_found);
                        result += "; distance=" + Integer.toString( distanceJava );
                        result += "; dtJava="+Long.toString(dtJava);
                        result += "; distanceF="+Integer.toString(distanceJavaF);
                        result += "; dtJavaF="+Long.toString(dtJavaF);
                        result += "; distanceC99="+Integer.toString( distanceC99);
                        result += "; dtC99="+Long.toString(dtC99);
                    } catch( IOException ex ) {
                        result = ex.getMessage();
                        Log.e( LOG_TAG, ex.getMessage(),ex);
                    }
                    StopRecordingUI stopRecordingTask = new StopRecordingUI( result );
                    uiHandler.post( stopRecordingTask );
                } else {
                    StopRecordingUI statusTask = new StopRecordingUI( null );
                    uiHandler.post( statusTask );
                }
            }
        }

        boolean needsAnalysis;
    }

    class UpdateStatus implements Runnable {
        public UpdateStatus( String statusMsg, boolean removeStopButton ) {
            this.statusMsg = statusMsg;
            this.removeStopButton = removeStopButton;
        }

        @Override
        public void run() {
            if( removeStopButton )
                btnStop.setVisibility(View.INVISIBLE);
            tvStatus.setText( statusMsg);
        }

        String statusMsg;
        boolean removeStopButton;
    }

    class StopRecordingUI implements Runnable {
        public StopRecordingUI( String statusMsg ) {
            this.statusMsg = statusMsg;
        }

        public void run() {
            stopRecordUI(statusMsg);
        }
        String statusMsg;
    }

    class PowerWindow {
        public PowerWindow( int wlen ) {
            this.wlen = wlen;
            window = new double[wlen];
            wptr = 0;
        }

        public double putValue( double v ) {
            window[wptr] = v*v;
            int p = wptr;
            double pw = 0.0;
            for( int i = 0 ; i < wlen ; ++i ) {
                pw += window[p];
                --p;
                if( p < 0 )
                    p = wlen - 1;
            }
            pw = pw / (double)wlen;
            ++wptr;
            wptr = wptr % wlen;
            return pw;
        }

        int wlen;
        double window[];
        int wptr;
    }

}