package com.geenband.alpha.perf.multisync;

import android.util.Log;

public class MyClass {
	private static final String TAG = "MyClass";
	private static int mValue;
	
	public MyClass(int n) {
		mValue = n;
	}
	
	public void add (int a) {
		synchronized (this) {
			mValue += a;
		}
		Log.i(TAG, "+" + a); // no need to lock
	}
	
	public void multiplyAndAdd (int m, int a) {
		synchronized (this) {
			mValue = mValue * m + a;
		}
		Log.i(TAG, "*" + m + ", +" + a); // no need to lock
	}
	
	public static synchronized void setValue(int n) {
		mValue = n;
	}
	
	public static void loop () {
		while (mValue != 100) {
			try {
				Log.i(TAG, "Value is " + mValue);
				Thread.sleep(1000);
			} catch (Exception e) {
				// ignored
			}
		}
	}
}
