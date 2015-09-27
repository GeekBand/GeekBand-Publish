package com.geekband.alpha.renderscript;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.ImageFormat;
import android.hardware.Camera;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v8.renderscript.Allocation;
import android.support.v8.renderscript.Element;
import android.support.v8.renderscript.RenderScript;
import android.support.v8.renderscript.ScriptIntrinsicBlur;
import android.support.v8.renderscript.ScriptIntrinsicYuvToRGB;
import android.support.v8.renderscript.Type;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.Switch;
import android.widget.TextView;

import java.io.IOException;
import java.util.List;

public class MainActivity extends Activity implements Camera.PreviewCallback, SurfaceHolder.Callback
{
    // Output bitmap, serves as a destination for the image-processing RenderScript kernel
    private Bitmap outputBitmap;

    // Single ImageView that is used to output the resulting bitmap
    private ImageView outputImageView;

    // RenderScript specific things:
    // the RS context
    private RenderScript rs;
    // "Glue" class that wraps access to our script
    // (the IDE generates the class automatically, based on the rs file, the class is located in the 'gen' folder)
    private ScriptC_process script;

    // built-in RenderScript kernel for converting YUV to RGB filter
    private ScriptIntrinsicYuvToRGB intrinsicYuvToRGB;

    // built-in RenderScript kernel for blur
    private ScriptIntrinsicBlur intrinsicBlur;

    // Allocations: memory abstractions that Renderscript kernels operate on
    private Allocation allocationIn;
    private Allocation allocationBlur;
    private Allocation allocationYUV;
    private Allocation allocationOut;

    //size of processed image
    private int imageWidth;
    private int imageHeight;
    //choosen camera parameters
    private Camera.Parameters params;
    // camera in use
    private Camera                camera;

    // couple of variables that controls the pipeline:
    // a flag to skip outstanding frames from the camera, when there some frame is already in process
    private volatile boolean    RenderScriptIsWorking;
    // an on/off flag for the video effect
    private volatile boolean    ApplyEffect;

    //last wall-clock frame time
    private long   prevFrameTimestampProcessed;
    private long   prevFrameTimestampCaptured;
    // Frame times, accumulated over the number of iterations using exp moving average.
    private double frameDurationAverProcessed;    // time between processed frames
    private double frameDurationAverCaptured;     //time between captured frames
    private double frameDurationAverRenderScript; // time that renderscript takes to process frame
    // blend factor used to calc exp moving average
    final double   blendFactor = 0.05;
    // time from the last FPS update on the screen.
    private double FPSDuration;
    // a simple text view to output performance statistics
    private TextView FPSLabel;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        RenderScriptIsWorking = false;
        ApplyEffect = true;
        FPSDuration = 0;
        prevFrameTimestampProcessed = System.nanoTime();
        prevFrameTimestampCaptured = System.nanoTime();
        frameDurationAverProcessed = 0;
        frameDurationAverCaptured = 0;
        frameDurationAverRenderScript = 0;

        setContentView(R.layout.activity_main);
        //get ImageView, used to display the resulting image
        outputImageView = (ImageView)findViewById(R.id.outputImageView);
        FPSLabel = (TextView)findViewById(R.id.FPS);

        ((Switch)findViewById(R.id.Effect)).setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener(){
                                                                           public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                                                                               ApplyEffect = isChecked;
                                                                           }
                                                                       }
        );

        // open camera (default is back-facing) to set preview format
        // as we require a camera in the manifest declaration we don't need to check if a camera is available at runtime
        // to check in runtime instead use hasSystemFeature(PackageManager.FEATURE_CAMERA)
        camera = Camera.open(0);
        params = camera.getParameters();
        // the old movie effect does not require high resolution source
        // 640x480 resolution is enough for the effect
        // we try to choose preview resolution that is close to that
        int pixels = 640*480;
        int dMin = Math.abs(params.getPreviewSize().width*params.getPreviewSize().height-pixels);
        List<Camera.Size> sizes = params.getSupportedPreviewSizes();
        for(int i = 0; i < sizes.size(); ++i)
        {
            Camera.Size size = sizes.get(i);
            int d = Math.abs(size.width*size.height - pixels);
            if( d < dMin )
            {
                params.setPreviewSize(size.width,size.height);
                dMin = d;
            }
        }
        // we want preview in NV21 format (which is supported by all cameras, unlike RGB)
        params.setPreviewFormat(ImageFormat.NV21);
        camera.setParameters(params);

        // get real preview parameters
        params = camera.getParameters();
        if(params.getPreviewFormat()!=ImageFormat.NV21)
        {
            Log.i("CameraRenderscript", "params.getPreviewFormat()!=ImageFormat.NV21 params.getPreviewFormat()="+params.getPreviewFormat());
        }
        //get preview image sizes
        imageWidth  = params.getPreviewSize().width;
        imageHeight = params.getPreviewSize().height;
        FPSLabel.setText(String.format("%dx%d:XXX FPS", imageWidth, imageHeight));
        Log.i("CameraRenderscript", "getPreviewSize() " + imageWidth+"x"+imageHeight);
        camera.release();
        camera = null;

        //create bitmap for output.
        outputBitmap = Bitmap.createBitmap(imageWidth, imageHeight, Bitmap.Config.ARGB_8888);

        // Initialize the RenderScript context
        rs = RenderScript.create(this);
        // Create the specific script, actually the bitcode of the script itself is located in the resources ('raw' folder)
        script = new ScriptC_process(rs);
        // Create an allocation (which is memory abstraction in the Renderscript) that corresponds to the outputBitmap
        allocationOut = Allocation.createFromBitmap(rs,outputBitmap);
        // allocationIn and allocationBlur matches the allocationOut
        allocationIn =  Allocation.createTyped(rs, allocationOut.getType(), Allocation.USAGE_SCRIPT);
        allocationBlur =  Allocation.createTyped(rs, allocationOut.getType(),Allocation.USAGE_SCRIPT);

        Type.Builder typeYUV = new Type.Builder(rs, Element.createPixel(rs, Element.DataType.UNSIGNED_8, Element.DataKind.PIXEL_A));
        typeYUV.setYuvFormat(ImageFormat.NV21);
        // allocation for the YUV input from the camera
        allocationYUV = Allocation.createTyped(rs, typeYUV.setX(imageWidth).setY(imageHeight).create(), Allocation.USAGE_SCRIPT);

        //create the instance of the YUV2RGB (built-in) RS intrinsic
        intrinsicYuvToRGB = ScriptIntrinsicYuvToRGB.create(rs, Element.U8_4(rs));

        //create the instance of the YUV2RGB (built-in) RS intrinsic
        intrinsicBlur = ScriptIntrinsicBlur.create(rs, Element.U8_4(rs));
        // set blur radius (blurring is important component of the Old Movie video effect)
        intrinsicBlur.setRadius(imageWidth/200.0f);

        // set input/output frame parameters for Old Movie video filter
        script.set_imageWidth(imageWidth);
        script.set_imageHeight(imageHeight);
        // input buffer for video effect (already in RGB)
        script.set_RGBABuffer(allocationBlur);

        //get preview surface for camera preview and set callback for surface
        //the layout is specified the way the inputSurfaceView is completely overlayed by outputSurfaceView
        // outputSurfaceView is the view that displays the resulting image
        // so inputSurfaceView is rather fake view for unprocessed preview frames
        // the inputSurfaceView is required just to setup the callback
        SurfaceView surView = (SurfaceView) findViewById(R.id.inputSurfaceView);
        SurfaceHolder surHolder = surView.getHolder();
        surHolder.addCallback(this);
    }

    private class ProcessData extends AsyncTask<byte[], Void, Boolean>
    {
        long    RenderScriptTime;
        @Override
        protected Boolean doInBackground(byte[]... args)
        {
            long rsStart = System.nanoTime();
            if(ApplyEffect)
            {
                long stepStart = System.nanoTime();
                // Run the scripts
                //conversion to RGB
                intrinsicYuvToRGB.setInput(allocationYUV);
                intrinsicYuvToRGB.forEach(allocationIn);

                //apply Blur
                intrinsicBlur.setInput(allocationIn);
                intrinsicBlur.forEach(allocationBlur);

                //update filter state
                script.invoke_update_state();
                //set filter args and run the OldMovie filter
                script.forEach_filter(allocationBlur, allocationOut);

                rs.finish();
                long stepEnd = System.nanoTime();
                Log.i("RenderScript Camera", "RS time: "+(stepEnd-stepStart)/1000000.0f+" ms");
            }
            else
            {
                //just convert the input stream to RGB to display
                intrinsicYuvToRGB.setInput(allocationYUV);
                intrinsicYuvToRGB.forEach(allocationOut);
            }
            long stepStart = System.nanoTime();
            allocationOut.syncAll(Allocation.USAGE_SHARED);
            long stepEnd = System.nanoTime();
            Log.i("RenderScript Camera", "Copy time: "+(stepEnd-stepStart)/1000000.0f+" ms");
            RenderScriptTime = stepEnd - rsStart;

            return true;
        }
        protected void onPostExecute(Boolean result) {
            //update average render script time processing
            frameDurationAverRenderScript += (RenderScriptTime-frameDurationAverRenderScript)*blendFactor;
            outputImageView.setImageBitmap(outputBitmap);
            outputImageView.invalidate();
            RenderScriptIsWorking = false;
        }
    }
    @Override
    public void onPreviewFrame(byte[] arg0, Camera arg1)
    {
        // calc time since previous call of this function
        long    curFrameTimestamp = System.nanoTime();
        // required FPS for the effect (assuming old cameras run at 12 fps)
        final double  EffectFPS = 12.0;
        // current average FPS
        double  AverFPS = (1e9f/frameDurationAverProcessed);
        // duration between last 2 processed frames (i.e. post-processed with RS effect and displayed)
        long    frameDurationProcessed =   curFrameTimestamp - prevFrameTimestampProcessed;
        // duration between last captured (i.e. for which a preview data arrived) frame and current being processed
        long     frameDurationCaptured  =   curFrameTimestamp - prevFrameTimestampCaptured;
        // calc average time between captured frames
        // we need this time to calculate time threshold to achieve exact EffectFPS that we need for effect
        frameDurationAverCaptured += (frameDurationCaptured-frameDurationAverCaptured)*blendFactor;
        prevFrameTimestampCaptured = curFrameTimestamp;

        // calc time interval since last processing
        FPSDuration += (double)frameDurationCaptured;
        if(FPSDuration>0.5e9f)
        {//update FPS on the screen every 0.5 sec
            double RenderScriptFPS = 1e9/frameDurationAverRenderScript;
            FPSLabel.setText(
                    String.format("%dx%d: %4.1f FPS (RenderScript: %4.1f FPS)", imageWidth, imageHeight, AverFPS, RenderScriptFPS)
            );
            FPSDuration = 0;
        }

        double  frameDurationT = (1e9f/EffectFPS);
        if(AverFPS<EffectFPS) // correct duration threshold in case of averageFPS is not enough
            frameDurationT -= frameDurationAverCaptured;
        //skip frame if processing of the previous is not finished yet
        // or FPS is higher than 12, since being slow/jerky is important for OldMovie perception
        if (RenderScriptIsWorking || (ApplyEffect && (frameDurationProcessed<frameDurationT)))
            return;

        // submit frame to process in background
        RenderScriptIsWorking = true;
        // copy input image data to the allocation for further processing in async fashion
        allocationYUV.copyFrom(arg0);
        // issue an async task to process the frame, it will cause ImageView update upon completion
        // since the task is async, camera continues to produce frames
        new ProcessData().execute();

        // update last processed time stamp and processing time average
        prevFrameTimestampProcessed = curFrameTimestamp;
        frameDurationAverProcessed += (frameDurationProcessed-frameDurationAverProcessed)*blendFactor;
    }
    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int width,
                               int height) {
    }

    @Override
    public void surfaceCreated(SurfaceHolder holder) {
        try {
            prevFrameTimestampProcessed = System.nanoTime();
            prevFrameTimestampCaptured = prevFrameTimestampProcessed;
            camera = Camera.open(0);
            camera.setParameters(params);
            camera.setPreviewCallback(this);
            camera.setPreviewDisplay(holder);
            camera.startPreview();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    @Override
    public void surfaceDestroyed(SurfaceHolder holder) {
        camera.stopPreview();
        camera.setPreviewCallback(null);
        camera.release();
        camera = null;
    }
}