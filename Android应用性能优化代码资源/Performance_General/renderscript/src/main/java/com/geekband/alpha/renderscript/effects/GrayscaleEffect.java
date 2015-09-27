package com.geekband.alpha.renderscript.effects;

import android.graphics.Bitmap;
import android.support.v8.renderscript.Allocation;
import android.support.v8.renderscript.RenderScript;

import com.geekband.alpha.renderscript.ScriptC_grayscale;


public class GrayscaleEffect implements BitmapEffect {

    private final RenderScript renderScript;
    private final ScriptC_grayscale grayscale;

    public GrayscaleEffect(RenderScript renderScript) {
        this.renderScript = renderScript;
        this.grayscale = new ScriptC_grayscale(renderScript);
    }

    @Override
    public Bitmap apply(Bitmap input) {
        Bitmap output = Bitmap.createBitmap(input.getWidth(), input.getHeight(), input.getConfig());

        Allocation inputAllocation = Allocation.createFromBitmap(renderScript, input, Allocation.MipmapControl.MIPMAP_NONE, Allocation.USAGE_SHARED | Allocation.USAGE_GRAPHICS_TEXTURE | Allocation.USAGE_SCRIPT);
        Allocation outputAllocation = Allocation.createFromBitmap(renderScript, output, Allocation.MipmapControl.MIPMAP_NONE, Allocation.USAGE_SHARED | Allocation.USAGE_SCRIPT);
        grayscale.forEach_grayscale(inputAllocation, outputAllocation);
        outputAllocation.copyTo(output);

        return output;
    }
}
