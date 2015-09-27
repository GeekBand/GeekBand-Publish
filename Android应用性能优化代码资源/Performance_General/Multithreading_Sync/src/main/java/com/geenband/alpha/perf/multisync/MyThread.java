package com.geenband.alpha.perf.multisync;

import android.os.Handler;
import android.os.Looper;
import android.os.Message;

public class MyThread extends Thread {
	private static final String TAG = "MyThread";
	private Handler mHandler;

	public MyThread(String name) {
		super(name);
	}
	
	public Handler getHandler() {
		return mHandler;
	}

	@Override
	public void run() {
		Looper.prepare(); // binds a looper to this thread

		mHandler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				switch (msg.what) {
				// process messages here
				}
			}
		};

		Looper.loop(); // don�t forget to call loop() to start the message loop

		// loop() won�t return until the loop is stopped (e.g. when Looper.myLooper().quit() is called)
	}
}
