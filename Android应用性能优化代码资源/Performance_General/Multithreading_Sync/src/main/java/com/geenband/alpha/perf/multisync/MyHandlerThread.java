package com.geenband.alpha.perf.multisync;

import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;

public class MyHandlerThread extends HandlerThread {
	private static final String TAG = "MyHandlerThread";
	private Handler mHandler;

	public MyHandlerThread(String name) {
		super(name);
	}
	
	public Handler getHandler() {
		return mHandler;
	}

	@Override
	public void start() {
		super.start();
		Looper looper = getLooper(); // will block until Looper is initialized
		mHandler = new Handler(looper) {
			@Override
			public void handleMessage(Message msg) {
				switch (msg.what) {
				// process messages here
				}
			}
		};
	}
}
