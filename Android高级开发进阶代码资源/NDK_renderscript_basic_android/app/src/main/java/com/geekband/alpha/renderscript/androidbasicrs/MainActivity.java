// Copyright (c) 2014 Intel Corporation. All rights reserved.
//
// WARRANTY DISCLAIMER
//
// THESE MATERIALS ARE PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL INTEL OR ITS
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
// OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THESE
// MATERIALS, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Intel Corporation is the author of the Materials, and requests that all
// problem reports or change requests be submitted to it directly


package com.geekband.alpha.renderscript.androidbasicrs;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.hardware.Camera;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.ConditionVariable;
import android.os.Environment;
import android.provider.MediaStore;
import android.renderscript.Allocation;
import android.renderscript.RenderScript;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;


public class MainActivity extends Activity
{
    // Input bitmap object, serves as a single source for the image-processing kernel.
    private Bitmap inputBitmap;
    // Output bitmap object, serves as a destination for the image-processing kernel.
    private Bitmap outputBitmap;
    // Second bitmap object is required for the simple double-buffering scheme.
    // For example, the kernel outputs first frame to the outputBitmap, second to the outputBitmapStage,
    // then to outputBitmap again, and so on.
    private Bitmap outputBitmapStage;

    // Single ImageView that is used to output the resulting bitmap object.
    private ImageView outputImageView;
    // This is a dedicated (worker) thread for computing needs, required as
    // potentially long operations should be avoided in the GUI thread.
    private Thread backgroundThread;
    // A conditional that signals the worker thread that the application is active, which means it is
    // not minimized.
    private ConditionVariable isGoing;
    // A flag that signals the worker thread that the application is exiting, so it should wrap up all
    // the activities as well.
    private volatile boolean isShuttingDown = false;

    // A conditional that guards the compute and rendering stages of the pipeline so that the bitmap object
    // being processed by the image-processing kernel is not displayed until done.
    private ConditionVariable isRendering;
    // A counter that is responsible for expansion of the "circle of effect" that appears when you
    // touch the screen.
    private int stepCount;

    // These are the "snapshot" values for the touch event used in the GUI thread.
    private int xTouchUI;
    private int yTouchUI;
    private int stepTouchUI;

    // These are the touch coordinates to be applied in the image-processing filter.
    private int xTouchApply;
    private int yTouchApply;
    private int stepTouchApply;

    // RenderScript-specific properties:
    // RS context
    private RenderScript rs;
    // "Glue" class that wraps access to the script.
    // The IDE generates the class automatically based on the rs file, the class is located in the 'gen'
    // folder.
    private ScriptC_process script;
    // Allocations - memory abstractions that RenderScript kernels operate on.
    private Allocation allocationIn;
    private Allocation allocationOut;

    // Image file (when you take a shot with the camera) and it's path.
    private File image;
    private String  newBitmapPath;

    // Pre-defined value to distinguish the camera-shot event, used in the Intents handler.
    private static final int CAMERA_SHOT = 1;

    // Time values in tickmarks, used for performance statistics.
    private long stepStart;
    private long stepEnd;
    private long prevFrameTimestamp;

    // Number of iterations over which the specific metrics are collected.
    private int itersAccum;
    // Frame time, accumulated over the number of iterations. Used for averaging the value.
    private long frameDurationAccum;
    // Image-processing kernel execution time, accumulated over the number of iterations. Used for
    // averaging the value.
    private long effectDurationAccum;
    // Threshold for the accumulated frames time after which the averaged FPS values are calculated
    // and reported.
         // Consider this approach rather than relying on the threshold for the number of the elapsed
         // frames (for example, 100 frames). The problem with relying on the number of frames
         // rather than time is that on a slow device getting 100 frames might take significant time.
         // Yet collecting statistics over smaller number (for example, 10 frames) might produce
         // volatile FPS values on fast devices. From this perspective, accumulating performance
         // statistics with the time threshold is more reliable.
        private static final long maxFrameDurationAccum = 500000000;

    // A few simple text views to output performance statistics.
    private TextView FPSLabel;
    private TextView frameDurationLabel;
    private TextView effectDurationLabel;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        outputImageView = (ImageView)findViewById(R.id.outputImageView);
        FPSLabel = (TextView)findViewById(R.id.FPS);
        frameDurationLabel = (TextView)findViewById(R.id.FrameDuration);
        effectDurationLabel = (TextView)findViewById(R.id.EffectDuration);
        isGoing  = new ConditionVariable(false);
        isRendering = new ConditionVariable(true);
        image = null;
        newBitmapPath = null;

        initRS();

        Button buttonPhoto=(Button)findViewById(R.id.PhotoButton);
        int anyCamera = Camera.getNumberOfCameras();
        if(anyCamera==0)
            buttonPhoto.setVisibility(View.INVISIBLE);

        // Reset the touch state as if you have not touched the screen yet.
        ResetTouch();
    }

    @Override
    protected void onDestroy()
    {
        Log.i("AndroidBasic", "onDestroy");

        // Tell the background thread that the application is closing.
        // You communicate with the thread via the isShuttingDown variable.
        isShuttingDown = true;
        isGoing.open();
        super.onDestroy();
    }

    protected void initRS()
    {
        // Initialize the RenderScript context.
        rs = RenderScript.create(this);
        // Create the specific script, actually the bitcode of the script itself is located in the
        // resources (raw folder).
        script = new ScriptC_process(rs);
    }

    public void PhotoOnClick(View v)
    {
        Intent cameraShotIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        File mediaFolder = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
        mediaFolder.mkdir();
        // Notice that for the sake of simplicity the activity orientation is set to landscape.
        // Operate the camera accordingly - capture photos also in the plain landscape mode only.

        image = new File(mediaFolder, timeStamp + ".jpg");
        Log.i("AndroidBasic", "file name for the intent: " + Uri.fromFile(mediaFolder) + "/" + timeStamp+ ".jpg");
        try
        {
            if(image.createNewFile())
            {
                cameraShotIntent.putExtra(android.provider.MediaStore.EXTRA_OUTPUT, Uri.fromFile(image));
                if (cameraShotIntent.resolveActivity(getPackageManager()) != null)
                {
                     startActivityForResult(cameraShotIntent, CAMERA_SHOT);
                }
            }
        }
        catch (IOException ex)
        {
            ex.printStackTrace();
        }
    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        if (requestCode == CAMERA_SHOT)
        {
            if(resultCode != RESULT_OK)
            {
                image.delete();
                return;
            }
            // Reset the previous touches.
            ResetTouch();

            newBitmapPath =  image.getAbsolutePath();
            Log.i("AndroidBasic", "newBitmapPath: " + newBitmapPath);

            Intent mediaScanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
            Uri contentUri = Uri.fromFile(image);
            mediaScanIntent.setData(contentUri);
            this.sendBroadcast(mediaScanIntent);
        }
    }

    private void startBackgroundThread ()
    {
        // Create a thread that periodically calls the filter method of this activity.
        backgroundThread = new Thread(new Runnable() {
            public void run() {
                while(!isShuttingDown)
                {
                    // Check that the application is not in the minimized state.
                    isGoing.block();
                    // Guard for flip-flopping the buffers so that the GUI thread does not try displaying a
                    // not updated bitmap object.
                    isRendering.block();
                    {
                        // If you need to update the image, it is a good place (in a dedicated thread) -
                        // in a synchronized way.
                        if(newBitmapPath!=null)
                        {
                            loadInputImage(newBitmapPath);
                            newBitmapPath = null;

                        }

                        Log.i("AndroidBasic", "beforeStep");
                        {
                            // Swap target and staging bitmap objects.
                            Bitmap t = outputBitmap;
                            outputBitmap = outputBitmapStage;
                            outputBitmapStage = t;
                        }

                        stepStart = System.nanoTime();
                        step();
                        stepEnd = System.nanoTime();

                        Log.i("AndroidBasic", "afterStep");
                        // Prevent the background thread from computing next frame to the same bitmap object.
                        isRendering.close();
                        outputImageView.post
                        (
                            new Runnable()
                            {
                                public void run ()
                                {
                                    {
                                        // Snapshot of the touch-event parameters that should be applied
                                        // until a new touch event happens.
                                        // In the GUI thread copy parameters into a separated variables
                                        // to guarantee the parameters are changed "atomically"
                                        // (simultaneously) for the worker thread.
                                        xTouchApply = xTouchUI;
                                        yTouchApply = yTouchUI;
                                        stepTouchApply = stepTouchUI;

                                        // Update the performance statistics.
                                        updatePerformanceStats();


                                        Log.i("AndroidBasic", "setImageBitmap and invalidate");
                                        outputImageView.setImageBitmap(outputBitmap);
                                        outputImageView.invalidate();
                                    }
                                    // Enable the background thread to compute the next frame.
                                    isRendering.open();
                                }
                            }
                        );
                    }
                }
                Log.i("AndroidBasic", "Exiting backgroundThread");
            }
        });

        backgroundThread.start();
    }

    private void updatePerformanceStats()
    {
        long curFrameTimestamp = System.nanoTime();

        if(prevFrameTimestamp != -1)
        {
            // Calculate the current frame duration value.
            long frameDuration = curFrameTimestamp - prevFrameTimestamp;
            long effectDuration = stepEnd - stepStart;
            frameDurationAccum += frameDuration;
            effectDurationAccum += effectDuration;
            itersAccum++;

            if(frameDurationAccum > maxFrameDurationAccum)
            {
                frameDuration  = frameDurationAccum / itersAccum;
                effectDuration = effectDurationAccum / itersAccum;
                frameDurationAccum = 0;
                effectDurationAccum = 0;
                itersAccum = 0;

                FPSLabel.setText((float)(int)((1e9f / frameDuration)*10)/10 + " FPS");
                frameDurationLabel.setText("Frame: " + frameDuration / 1000000 + " ms");
                effectDurationLabel.setText("Effect:  " + effectDuration / 1000000 + " ms");
            }
        }

        prevFrameTimestamp = curFrameTimestamp;
    }

    // This method runs in a separate working thread.
    private void step ()
    {
        Log.i("AndroidBasic", "step");

        stepRenderScript();

        stepCount++;
    }

    @Override
    protected void onStart()
    {
        super.onStart();

        // Unleash the "worker" thread.
        isGoing.open();
        Log.i("AndroidBasic", "onStart");
    }

    @Override
    protected void onStop()
    {
        super.onStop();

        // Stop the background filtering thread.
        isGoing.close();
        Log.i("AndroidBasic", "onStop");
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus)
    {
        super.onWindowFocusChanged(hasFocus);

        Log.i("AndroidBasic", "onWindowFocusChanged");
        // When the application is restarted, which means the inputBitmap doesn't exist,
        // load inputBitmap first and (re)start the worker thread.
        // If the inputBitmap already exists, the application is likely to resume from the minimized state.
        if(inputBitmap == null)
        {
            String fromResources = null;
            loadInputImage(fromResources);
            startBackgroundThread();
        }
    }

    private void loadInputImage (String path)
    {
        // To avoid potential issues with loading big images, scale the input image to fit the output view.
        // Obtain the actual dimensions from the outputImageView.
        int displayWidth = outputImageView.getWidth();
        int displayHeight = outputImageView.getHeight();
        if(Build.FINGERPRINT.startsWith("generic")) //emulator, we are very memory limited
        {
            displayWidth  /=2;
            displayHeight /=2;
        }

        Log.i("AndroidBasic", "display dimensions: " + displayWidth + ", " + displayHeight);

        // Obtain the original dimensions of the input picture from resources.
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;    // This avoids the decoding itself and reads the image statistics.

        if(path==null)
        {
            BitmapFactory.decodeResource(getResources(), R.drawable.picture, options);
        }
        else
        {
            BitmapFactory.decodeFile(path, options);
        }

        int origWidth  = options.outWidth;
        int origHeight = options.outHeight;

        // According to the display and the original dimensions, calculate the scale factor that reduces
        // the amount of memory needed to store an image, and, at the same time, is not too high to avoid
        // significant image quality loss.
        options.inSampleSize = Math.min(origWidth/displayWidth, origHeight/displayHeight);

        // Now decode the real picture content with scaling.
        options.inJustDecodeBounds = false;
        if(path==null)
        {
            inputBitmap = BitmapFactory.decodeResource(getResources(), R.drawable.picture, options);
        }
        else
        {
            inputBitmap = BitmapFactory.decodeFile(path, options);
        }

        inputBitmap = Bitmap.createScaledBitmap(inputBitmap, displayWidth, displayHeight, false);

        // Create an allocation (which is memory abstraction in the RenderScript)
        // that corresponds to the imputBitmap.
        allocationIn = Allocation.createFromBitmap(
            rs,
            inputBitmap,
            Allocation.MipmapControl.MIPMAP_NONE,
            Allocation.USAGE_SCRIPT
        );
        // Create another allocation (with the same type and dimensions as allocationIn) to be used
        // as a source to update the outputBitmap.
        allocationOut =  Allocation.createTyped(rs, allocationIn.getType());
        // Starting Android API level 18 and higher, you can create the allocationOut directly from the
        // Bitmap via CreateFromBitmap()
            // Use the dedicated USAGE_SHARED flag, as with this flag copying to or from the bitmap
            // causes a synchronization rather than a full copy.
            // Also use syncAll(USAGE_SHARED) to synchronize the Allocation and the source Bitmap
            // rather than the current copyTo, refer to the stepRenderScript method
            // Notice that you would need to use a second allocation (and swap them similarly to bitmaps)

        int imageWidth  = inputBitmap.getWidth();
        int imageHeight = inputBitmap.getHeight();
        // Two bitmap objects for the simple double-buffering scheme, where first bitmap object is rendered,
        // while the second one is being updated, then vice versa.
        outputBitmap = Bitmap.createBitmap(imageWidth, imageHeight, Bitmap.Config.ARGB_8888);
        outputBitmapStage = Bitmap.createBitmap(imageWidth, imageHeight, Bitmap.Config.ARGB_8888);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event)
    {
        xTouchUI = (int)(event.getX());
        yTouchUI = (int)(event.getY());

        stepTouchUI = stepCount;

        Log.i("AndroidBasic", "x = " + event.getX() + ", y = " + event.getY());
        return super.onTouchEvent(event);
    }


    private void stepRenderScript ()
    {
        // Compute the parameters (for example, the "circle of effect") depending on the number of the
        // elapsed steps.
        int radius = (stepTouchApply == -1 ? -1 : 10*(stepCount - stepTouchApply));
        int radiusHi = (radius + 2)*(radius + 2);
        int radiusLo = (radius - 2)*(radius - 2);
        // Setting parameters for the script.
        script.set_radiusHi(radiusHi);
        script.set_radiusLo(radiusLo);
        script.set_xTouchApply(xTouchApply);
        script.set_yTouchApply(yTouchApply);

        // Run the script.
        script.forEach_root(allocationIn, allocationOut);
        // For the API level 17 and earlier: explicit copy of results to the output bitmap for displaying
        allocationOut.copyTo(outputBitmap);
        // For the API level 18 and higher notice that you would
        // need another allocation to match outBitmapStage and swap the allocations similarly to bitmaps
        // (search for the "beforeStep" string in the code)
        //Wait for completion
        //rs.finish();
        // Let the bitmap know the results
        //allocationOut.syncAll(Allocation.USAGE_SHARED);

    }

    private void ResetTouch()
    {
        stepTouchUI = stepTouchApply = -1;
    }

}
