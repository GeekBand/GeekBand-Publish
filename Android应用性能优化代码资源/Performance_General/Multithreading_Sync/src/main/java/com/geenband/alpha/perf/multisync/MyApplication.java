package com.geenband.alpha.perf.multisync;

import android.app.Application;

public class MyApplication extends Application {

	@Override
	public void onCreate() {
		super.onCreate();
/*
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder()
			.detectCustomSlowCalls() // use StrictMode.noteSlowCode
			//.detectDiskReads()
			//.detectDiskWrites()
			.detectNetwork()
			.penaltyLog()
			.penaltyDeath()
			.build());

			StrictMode.setVmPolicy(new StrictMode.VmPolicy.Builder()
			.detectLeakedSqlLiteObjects()
			.penaltyLog()
			.penaltyDeath()
			.build());
		}
		*/
	}
	

}
