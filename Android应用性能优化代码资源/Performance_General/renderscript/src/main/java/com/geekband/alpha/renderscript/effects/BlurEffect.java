package com.geekband.alpha.renderscript.effects;

import android.graphics.Bitmap;
import android.support.v8.renderscript.Allocation;
import android.support.v8.renderscript.Element;
import android.support.v8.renderscript.RenderScript;
import android.support.v8.renderscript.ScriptIntrinsicBlur;


public class BlurEffect implements BitmapEffect {

    private final RenderScript renderScript;
    private final float blurRadius;

    public BlurEffect(RenderScript renderScript, float blurRadius) {
        this.renderScript = renderScript;
        this.blurRadius = blurRadius;
    }

    @Override
    public Bitmap apply(Bitmap originalBitmap) {
        Allocation inputAllocation = Allocation.createFromBitmap(renderScript, originalBitmap, Allocation.MipmapControl.MIPMAP_NONE, Allocation.USAGE_SHARED | Allocation.USAGE_GRAPHICS_TEXTURE | Allocation.USAGE_SCRIPT);

        Bitmap blurryBitmap = Bitmap.createBitmap(originalBitmap.getWidth(), originalBitmap.getHeight(), originalBitmap.getConfig());
        Allocation outputAllocation = Allocation.createFromBitmap(renderScript, blurryBitmap, Allocation.MipmapControl.MIPMAP_NONE, Allocation.USAGE_SHARED | Allocation.USAGE_SCRIPT);

        ScriptIntrinsicBlur intrinsicBlur = ScriptIntrinsicBlur.create(renderScript, Element.U8_4(renderScript));
        intrinsicBlur.setRadius(blurRadius);
        intrinsicBlur.setInput(inputAllocation);

        intrinsicBlur.forEach(outputAllocation);
        outputAllocation.copyTo(blurryBitmap);

        return blurryBitmap;
    }
}
