/*
 * Copyright (C) 2011-2014 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * This file is auto-generated. DO NOT MODIFY!
 * The source Renderscript file: /Users/Alpha/tmp/android_lib/renderscript_basic_android/app/src/main/rs/process.rs
 */

package com.geekband.alpha.renderscript.androidbasicrs;

import android.renderscript.*;
import android.content.res.Resources;

/**
 * @hide
 */
public class ScriptC_process extends ScriptC {
    private static final String __rs_resource_name = "process";
    // Constructor
    public  ScriptC_process(RenderScript rs) {
        this(rs,
             rs.getApplicationContext().getResources(),
             rs.getApplicationContext().getResources().getIdentifier(
                 __rs_resource_name, "raw",
                 rs.getApplicationContext().getPackageName()));
    }

    public  ScriptC_process(RenderScript rs, Resources resources, int id) {
        super(rs, resources, id);
        __I32 = Element.I32(rs);
        mExportVar_gWhite = new Float4();
        mExportVar_gWhite.x = 1.f;
        mExportVar_gWhite.y = 1.f;
        mExportVar_gWhite.z = 1.f;
        mExportVar_gWhite.w = 1.f;
        __F32_4 = Element.F32_4(rs);
        mExportVar_channelWeights = new Float3();
        mExportVar_channelWeights.x = 0.298999995f;
        mExportVar_channelWeights.y = 0.587000012f;
        mExportVar_channelWeights.z = 0.114f;
        __F32_3 = Element.F32_3(rs);
        __U8_4 = Element.U8_4(rs);
    }

    private Element __F32_3;
    private Element __F32_4;
    private Element __I32;
    private Element __U8_4;
    private FieldPacker __rs_fp_F32_3;
    private FieldPacker __rs_fp_F32_4;
    private FieldPacker __rs_fp_I32;
    private final static int mExportVarIdx_radiusHi = 0;
    private int mExportVar_radiusHi;
    public synchronized void set_radiusHi(int v) {
        setVar(mExportVarIdx_radiusHi, v);
        mExportVar_radiusHi = v;
    }

    public int get_radiusHi() {
        return mExportVar_radiusHi;
    }

    public Script.FieldID getFieldID_radiusHi() {
        return createFieldID(mExportVarIdx_radiusHi, null);
    }

    private final static int mExportVarIdx_radiusLo = 1;
    private int mExportVar_radiusLo;
    public synchronized void set_radiusLo(int v) {
        setVar(mExportVarIdx_radiusLo, v);
        mExportVar_radiusLo = v;
    }

    public int get_radiusLo() {
        return mExportVar_radiusLo;
    }

    public Script.FieldID getFieldID_radiusLo() {
        return createFieldID(mExportVarIdx_radiusLo, null);
    }

    private final static int mExportVarIdx_xTouchApply = 2;
    private int mExportVar_xTouchApply;
    public synchronized void set_xTouchApply(int v) {
        setVar(mExportVarIdx_xTouchApply, v);
        mExportVar_xTouchApply = v;
    }

    public int get_xTouchApply() {
        return mExportVar_xTouchApply;
    }

    public Script.FieldID getFieldID_xTouchApply() {
        return createFieldID(mExportVarIdx_xTouchApply, null);
    }

    private final static int mExportVarIdx_yTouchApply = 3;
    private int mExportVar_yTouchApply;
    public synchronized void set_yTouchApply(int v) {
        setVar(mExportVarIdx_yTouchApply, v);
        mExportVar_yTouchApply = v;
    }

    public int get_yTouchApply() {
        return mExportVar_yTouchApply;
    }

    public Script.FieldID getFieldID_yTouchApply() {
        return createFieldID(mExportVarIdx_yTouchApply, null);
    }

    private final static int mExportVarIdx_gWhite = 4;
    private Float4 mExportVar_gWhite;
    public Float4 get_gWhite() {
        return mExportVar_gWhite;
    }

    public Script.FieldID getFieldID_gWhite() {
        return createFieldID(mExportVarIdx_gWhite, null);
    }

    private final static int mExportVarIdx_channelWeights = 5;
    private Float3 mExportVar_channelWeights;
    public Float3 get_channelWeights() {
        return mExportVar_channelWeights;
    }

    public Script.FieldID getFieldID_channelWeights() {
        return createFieldID(mExportVarIdx_channelWeights, null);
    }

    private final static int mExportForEachIdx_root = 0;
    public Script.KernelID getKernelID_root() {
        return createKernelID(mExportForEachIdx_root, 59, null, null);
    }

    public void forEach_root(Allocation ain, Allocation aout) {
        // check ain
        if (!ain.getType().getElement().isCompatible(__U8_4)) {
            throw new RSRuntimeException("Type mismatch with U8_4!");
        }
        // check aout
        if (!aout.getType().getElement().isCompatible(__U8_4)) {
            throw new RSRuntimeException("Type mismatch with U8_4!");
        }
        Type t0, t1;        // Verify dimensions
        t0 = ain.getType();
        t1 = aout.getType();
        if ((t0.getCount() != t1.getCount()) ||
            (t0.getX() != t1.getX()) ||
            (t0.getY() != t1.getY()) ||
            (t0.getZ() != t1.getZ()) ||
            (t0.hasFaces()   != t1.hasFaces()) ||
            (t0.hasMipmaps() != t1.hasMipmaps())) {
            throw new RSRuntimeException("Dimension mismatch between parameters ain and aout!");
        }

        forEach(mExportForEachIdx_root, ain, aout, null);
    }

}

