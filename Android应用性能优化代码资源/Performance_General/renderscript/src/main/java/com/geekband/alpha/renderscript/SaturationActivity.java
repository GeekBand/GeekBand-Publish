package com.geekband.alpha.renderscript;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.support.v8.renderscript.Allocation;
import android.support.v8.renderscript.RenderScript;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ImageView;
import android.widget.SeekBar;

public class SaturationActivity extends ActionBarActivity {

    private final int NUM_BITMAPS = 3;
    private int mCurrentBitmap = 0;
    private Bitmap mBitmapIn;
    private Bitmap[] mBitmapsOut;
    private ImageView mImageView;

    private RenderScript mRS;
    private Allocation mInAllocation;
    private Allocation[] mOutAllocations;
    private ScriptC_saturation mScript;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_saturation);

        /*
         * Initialize UI
         */
        mBitmapIn = loadBitmap(R.drawable.data);
        mBitmapsOut = new Bitmap[NUM_BITMAPS];
        for (int i = 0; i < NUM_BITMAPS; ++i) {
            mBitmapsOut[i] = Bitmap.createBitmap(mBitmapIn.getWidth(),
                    mBitmapIn.getHeight(), mBitmapIn.getConfig());
        }

        mImageView = (ImageView) findViewById(R.id.imageView);
        mImageView.setImageBitmap(mBitmapsOut[mCurrentBitmap]);
        mCurrentBitmap += (mCurrentBitmap + 1) % NUM_BITMAPS;

        SeekBar seekbar = (SeekBar) findViewById(R.id.seekBar1);
        seekbar.setProgress(50);
        seekbar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            public void onProgressChanged(SeekBar seekBar, int progress,
                                          boolean fromUser) {
                float max = 2.0f;
                float min = 0.0f;
                float f = (float) ((max - min) * (progress / 100.0) + min);
                updateImage(f);
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
            }
        });

        /*
         * Create renderScript
         */
        createScript();

        /*
         * Invoke renderScript kernel and update imageView
         */
        updateImage(1.0f);
    }

    /*
     * Initialize RenderScript
     * In the sample, it creates RenderScript kernel that performs saturation manipulation.
     */
    private void createScript() {
        //Initialize RS
        mRS = RenderScript.create(this);

        //Allocate buffers
        mInAllocation = Allocation.createFromBitmap(mRS, mBitmapIn);
        mOutAllocations = new Allocation[NUM_BITMAPS];
        for (int i = 0; i < NUM_BITMAPS; ++i) {
            mOutAllocations[i] = Allocation.createFromBitmap(mRS, mBitmapsOut[i]);
        }

        //Load script
        mScript = new ScriptC_saturation(mRS);
    }

    /*
     * In the AsyncTask, it invokes RenderScript intrinsics to do a filtering.
     * After the filtering is done, an operation blocks at Allication.copyTo() in AsyncTask thread.
     * Once all operation is finished at onPostExecute() in UI thread, it can invalidate and update ImageView UI.
     */
    private class RenderScriptTask extends AsyncTask<Float, Integer, Integer> {
        Boolean issued = false;

        protected Integer doInBackground(Float... values) {
            int index = -1;
            if (isCancelled() == false) {
                issued = true;
                index = mCurrentBitmap;

                /*
                 * Set global variable in RS
                 */
                mScript.set_saturationValue(values[0]);

                /*
                 * Invoke saturation filter kernel
                 */
                mScript.forEach_saturation(mInAllocation, mOutAllocations[index]);

                /*
                 * Copy to bitmap and invalidate image view
                 */
                mOutAllocations[index].copyTo(mBitmapsOut[index]);
                mCurrentBitmap = (mCurrentBitmap + 1) % NUM_BITMAPS;
            }
            return index;
        }

        void updateView(Integer result) {
            if (result != -1) {
                // Request UI update
                mImageView.setImageBitmap(mBitmapsOut[result]);
                mImageView.invalidate();
            }
        }

        protected void onPostExecute(Integer result) {
            updateView(result);
        }

        protected void onCancelled(Integer result) {
            if (issued) {
                updateView(result);
            }
        }
    }

    RenderScriptTask currentTask = null;

    /*
    Invoke AsynchTask and cancel previous task.
    When AsyncTasks are piled up (typically in slow device with heavy kernel),
    Only the latest (and already started) task invokes RenderScript operation.
     */
    private void updateImage(final float f) {
        if (currentTask != null)
            currentTask.cancel(false);
        currentTask = new RenderScriptTask();
        currentTask.execute(f);
    }

    /*
    Helper to load Bitmap from resource
     */
    private Bitmap loadBitmap(int resource) {
        final BitmapFactory.Options options = new BitmapFactory.Options();
        options.inPreferredConfig = Bitmap.Config.ARGB_8888;
        return BitmapFactory.decodeResource(getResources(), resource, options);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_saturation, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
