package com.example.android.mobileperf.compute;

import android.app.Application;

import com.squareup.leakcanary.LeakCanary;

/**
 * Created by Alpha.
 */
public class MyApplication extends Application {

    @Override public void onCreate() {
        super.onCreate();
        LeakCanary.install(this);

    }

}
