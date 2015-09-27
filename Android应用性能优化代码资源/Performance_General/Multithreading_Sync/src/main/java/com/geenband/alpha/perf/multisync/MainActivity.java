package com.geenband.alpha.perf.multisync;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigInteger;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.concurrent.TimeUnit;

import org.apache.http.util.ByteArrayBuffer;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.pm.ApplicationInfo;
import android.content.res.Resources;
import android.database.sqlite.SQLiteDatabase;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Debug;
import android.os.Handler;
import android.os.Message;
import android.os.StrictMode;
import android.util.Config;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;



public class MainActivity
		extends Activity {
	private static final String TAG = "MainActivity";
	
	private static final String STATE_COMPUTE = "geenband.compute";
	
	private CheckBox garbageCollectionCheckBox;
	private CheckBox methodTracingCheckBox;
	private CheckBox nativeTracingCheckBox;
	private CheckBox uiThreadCheckBox;
	private CheckBox delayCheckBox;
	private CheckBox recursiveFasterCheckBox;
	private EditText numberText;
	private Button mRunButton;
	private TextView mTextView;
	
	private volatile boolean garbageCollectionEnabled;
	private volatile boolean methodTracingEnabled;
	private volatile boolean nativeTracingEnabled;
	private volatile boolean delayEnabled;
	private volatile boolean recursiveFasterOnly;
	private volatile int delay;
	private volatile int defaultN;
	private volatile int recursionThreshold;
	
	private AsyncTask<Integer, Void, String> mTask;
	
	@Override
	protected void onStop() {
		super.onStop();
		if (mTask != null) {
			mTask.cancel(true);
		}
	}

	@Override
	protected void onSaveInstanceState(Bundle outState) {
		// if called, it will be called before onStop()
		super.onSaveInstanceState(outState);
		if (mTask != null) {
			outState.putInt(STATE_COMPUTE, 100000); // for simplicity, hard-coded value
		}
	}

	/** Called when the activity is first created. */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
    	if (Config.DEBUG) {
    		Log.i(TAG, "Running on a debug DEVICE, not a release one (nothing to do with debug/release application)");
    	}
    	if ((getApplicationInfo().flags & ApplicationInfo.FLAG_DEBUGGABLE) != 0 ){
    		Log.i(TAG, "Running a debuggable build");
    		// StrictMode here
    	}
    	Log.i(TAG, "Processors: " + Runtime.getRuntime().availableProcessors());
    	
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        Log.i(TAG, "Activity instance is now " + toString());
        Log.i(TAG, "onCreate called in thread " + Thread.currentThread().getId());
        
        garbageCollectionCheckBox = (CheckBox) findViewById(R.id.gcCheckBox);
        methodTracingCheckBox = (CheckBox) findViewById(R.id.methodTracingCheckBox);
        nativeTracingCheckBox = (CheckBox) findViewById(R.id.nativeTracingCheckBox);
        uiThreadCheckBox = (CheckBox) findViewById(R.id.uiThreadCheckBox);
        delayCheckBox = (CheckBox) findViewById(R.id.delayCheckBox);
        recursiveFasterCheckBox = (CheckBox) findViewById(R.id.recursiveFasterCheckBox);
        numberText = (EditText) findViewById(R.id.number);
        mRunButton = (Button) findViewById(R.id.runTestsButton);
        mTextView = numberText;
        
        // get integer values from resource file
        Resources r = getResources();
        delay = r.getInteger(R.integer.delayBetweenTests);
        defaultN = r.getInteger(R.integer.defaultN);
        recursionThreshold = r.getInteger(R.integer.recursionThreshold);
        
        // default values
        garbageCollectionCheckBox.setChecked(true);
        methodTracingCheckBox.setChecked(false);
        nativeTracingCheckBox.setChecked(false);
        uiThreadCheckBox.setChecked(false);
        delayCheckBox.setChecked(true);
        recursiveFasterCheckBox.setChecked(false);
        numberText.setText(String.valueOf(defaultN));
        
        delayCheckBox.append(" (" + delay + " ms)");
        
        try {
			Log.i(TAG, ""+Class.forName("android.os.Build$VERSION").getField("SDK_INT"));
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (NoSuchFieldException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
        
        Log.i(TAG, "Allocations (10): "+Fibonacci.recursiveFasterAllocations(50000, 10));
        Log.i(TAG, "Allocations (92): "+Fibonacci.recursiveFasterAllocations(50000, 92));
        System.gc();
        Log.i(TAG, "actual call (50000): "+Fibonacci.recursiveFasterPrimitiveAndBigInteger(50000).bitLength());
        
        SQLiteDatabase db = SQLiteDatabase.create(null); // memory-backed database
        db.execSQL("CREATE TABLE cheese (name TEXT, origin TEXT)");
        db.execSQL("INSERT INTO cheese VALUES ('Roquefort', 'Roquefort-sur-Soulzon')");
        db.close();
        
        File file = getDatabasePath("fromage.db");
        File parent = new File(file.getParent());
        parent.mkdirs();
        
        // many transactions
        //testDatabase(null, false);
        //testDatabase(file.getAbsolutePath(), false);
        
        // one transaction
        //testDatabase(null, true);
        //testDatabase(file.getAbsolutePath(), true);
        /*
        mTask = (AsyncTask<Integer, Void, String>) getLastNonConfigurationInstance();
        if (mTask != null) {
        	mRunButton.setEnabled(false);
        }
        */
        if (savedInstanceState != null && savedInstanceState.containsKey(STATE_COMPUTE)) {
        	int value = savedInstanceState.getInt(STATE_COMPUTE);
        	mTask = createTask().execute(value);
        }
    }
    
    @Override
	public void onLowMemory() {
		super.onLowMemory();
		Log.w(TAG, "Low on memory");
	}

    public void onClick (View v) {
    	
    	new Thread(new Runnable() {
    	    public void run() {
    	      final BigInteger f = Fibonacci.recursiveFasterPrimitiveAndBigInteger(100000);
    	      //mTextView.setText(f.toString());
    	      mTextView.post(new Runnable() {
    	        public void run() {
    	        	//mTextView.setText(f.toString());
    	        	Log.i(TAG, f.toString());
    	        }
    	      });
    	    }
    	  }, "fibonacci").start();
    	
    	new AsyncTask<Integer, Void, BigInteger>() {

			@Override
			protected void onPreExecute() {
				mRunButton.setEnabled(false);
			}

			@Override
			protected void onCancelled() {
				mRunButton.setEnabled(true);
			}

			@Override
			protected BigInteger doInBackground(Integer... params) {
				return Fibonacci.recursiveFasterPrimitiveAndBigInteger(params[0]);
			}

			@Override
			protected void onPostExecute(BigInteger result) {
				mTextView.setText(result.toString());
				mRunButton.setEnabled(true);
			}

    	}.execute(100000);
    	
    	AsyncTask<String, Object, Void> task = new AsyncTask<String, Object, Void>() {

    		private ByteArrayBuffer downloadFile(String urlString, byte[] buffer) {
    			try {
					URL url = new URL(urlString);
					URLConnection connection = url.openConnection();
					InputStream is = connection.getInputStream();
					Log.i(TAG, "InputStream: " + is.getClass().getName());
					//is = new BufferedInputStream(is); // optional line, try with and without
					ByteArrayBuffer baf = new ByteArrayBuffer(64 * 1024);
					int len;
					while ((len = is.read(buffer)) != -1) {
						baf.append(buffer, 0, len);
					}
					return baf;
				} catch (MalformedURLException e) {
					return null;
				} catch (IOException e) {
					return null;
				}
    		}
    		
			@Override
			protected Void doInBackground(String... params) {
				if (params != null && params.length > 0) {
					byte[] buffer = new byte[1 + 0*4 * 1024]; // try different sizes
					for (String url : params) {
						long time = System.currentTimeMillis();
						ByteArrayBuffer baf = downloadFile(url, buffer);
						time = System.currentTimeMillis() - time;
						publishProgress(url, baf, time);
					}
				} else {
					publishProgress(null, null);
				}
				return null;
			}

			@Override
			protected void onProgressUpdate(Object... values) {
				// values[0] is the URL (String), values[1] is the buffer (ByteArrayBuffer)
				String url = (String) values[0];
				ByteArrayBuffer buffer = (ByteArrayBuffer) values[1];
				long time = (Long) values[2];
				if (buffer != null) {
					Log.i(TAG, "Downloaded " + url + " (" + buffer.length() + " bytes) in " + time + " milliseconds");
				} else {
					Log.w(TAG, "Could not download " + url);
				}
				// update UI accordingly
			}

    	};
    	
    	String url1 = "http://www.google.com/index.html";
    	String url2 = "http://d.android.com/reference/android/os/AsyncTask.html";
    	task.execute(url1, url2);
    	/*
    	try {
			Thread.sleep(4000);
	    	task.execute("http://d.android.com/resources/articles/painless-threading.html");
		} catch (InterruptedException e) {
		}
		*/
    }
    
    private AsyncTask<Integer, Void, String> createTask() {
    	return new AsyncTask<Integer, Void, String>() {

    		@Override
    		protected void onCancelled() {
    			Log.i(TAG, "Task cancelled");
    			mRunButton.setEnabled(true);
    			mRunButton.setText(R.string.runAll);
    			mTask = null;
    		}

    		@Override
    		protected void onPostExecute(String message) {
    			super.onPostExecute(message);
    			mRunButton.setEnabled(true);
    			mRunButton.setText(R.string.runAll);
    			alertResults(message);
    			Log.i(TAG, "Computation completed in " + MainActivity.this.toString());
    			Log.i(TAG, "onPostExecute called in thread " + Thread.currentThread().getId());
    			mTask = null;
    		}

    		@Override
    		protected void onPreExecute() {
    			super.onPreExecute();
    			mRunButton.setEnabled(false);
    			mRunButton.setText(R.string.running);
    		}

    		@Override
    		protected String doInBackground(Integer... params) {
    			Log.i(TAG, "Task started!!!");
    			String message = runFibonacciTests(params[0]);
    			return message;
    		}
    	};
    }
    
    private void measureNanoTime() {
    	final int ITERATIONS = 100000;
    	long total = 0;
    	long min = Long.MAX_VALUE;
    	long max = Long.MIN_VALUE;
    	
    	for (int i = 0; i < ITERATIONS; i++) {
    		long time = System.nanoTime();
    		time = System.nanoTime() - time;
    		total += time;
    		if (time < min) {
    			min = time;
    		}
    		if (time > max) {
    			max = time;
    		}
    	}
    	
    	Log.i(TAG, "System.nanoTime() takes about " + ((float)total / ITERATIONS) + " nanoseconds to complete");
    	Log.i(TAG, " Minimum: " + min);
    	Log.i(TAG, " Maximum: " + max);
    }
    
    private void measureThreadCpuTimeNanos() {
    	final int ITERATIONS = 100000;
    	long total = 0;
    	long min = Long.MAX_VALUE;
    	long max = Long.MIN_VALUE;
    	
    	for (int i = 0; i < ITERATIONS; i++) {
    		long time = Debug.threadCpuTimeNanos();
    		time = Debug.threadCpuTimeNanos() - time;
    		total += time;
    		if (time < min) {
    			min = time;
    		}
    		if (time > max) {
    			max = time;
    		}
    	}
    	
    	Log.i(TAG, "Debug.threadCpuTimeNanos() takes about " + ((float)total / ITERATIONS) + " nanoseconds to complete");
    	Log.i(TAG, " Minimum: " + min);
    	Log.i(TAG, " Maximum: " + max);
    }
    
    private void testThreadCpuTimeNanos() {
    	long duration2 = System.nanoTime();
    	long duration = Debug.threadCpuTimeNanos();
    	try {
			Thread.sleep(TimeUnit.MILLISECONDS.convert(1L, TimeUnit.SECONDS));
			TimeUnit.SECONDS.sleep(1);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		duration = Debug.threadCpuTimeNanos() - duration;
		duration2 = System.nanoTime() - duration2;
    	Log.i(TAG, "Duration: " + duration + " nanoseconds");
    	Log.i(TAG, "Duration2: " + duration2 + " nanoseconds");
    }
    
    private int getTrace() {
    	Debug.startMethodTracing("/sdcard/awesometrace.trace");
    	BigInteger fN = Fibonacci.recursiveFasterWithCache(100000);
    	Debug.stopMethodTracing();
    	return fN.bitLength();
    }
    
    private int getNativeTrace() {
    	Debug.startNativeTracing();
    	BigInteger fN = Fibonacci.recursiveFasterWithCache(100000);
    	Debug.stopNativeTracing();
    	return fN.bitLength();
    }
    
	public void onClickButton (View v) {
    	garbageCollectionEnabled = garbageCollectionCheckBox.isChecked();
    	methodTracingEnabled = methodTracingCheckBox.isChecked();
    	nativeTracingEnabled = nativeTracingCheckBox.isChecked();
    	delayEnabled = delayCheckBox.isChecked();
    	recursiveFasterOnly = recursiveFasterCheckBox.isChecked();
    	
    	//onClick(v);
    	
    	//measureNanoTime();
    	//measureThreadCpuTimeNanos();
    	//testThreadCpuTimeNanos();
    	
    	//getTrace();
    	getNativeTrace();
    	
    	int n;
    	try {
    		n = Integer.valueOf(numberText.getText().toString());
    	} catch (NumberFormatException e) {
    		n = defaultN;
    		numberText.setText(String.valueOf(n));
    	}
    	
    	if (uiThreadCheckBox.isChecked()) {
    		String message = runFibonacciTests(n);
    		alertResults(message);
    	} else {
    		mTask = createTask().execute(n);
    		/*    		
    		Thread thread1 = new Thread("cheese1") {
    			@Override
    			public void run() {
    				Log.i(TAG, "I like Munster");
    			}
    		};
    		Thread thread2 = new Thread(new Runnable() {
    			public void run() {
    				Log.i(TAG, "I like Roquefort");
    			}
    		}, "cheese2");
    		Thread thread3 = new Thread(new Runnable() {
    			public void run() {
    				Log.i(TAG, "I like Brie");
    			}
    		}, "cheese3") {
    			@Override
    			public void run() {
    				super.run();
    				Log.i(TAG, "I like Epoisses");
    			}
    		};
    		thread1.setPriority(Thread.MIN_PRIORITY);
    		thread2.setPriority(Thread.MAX_PRIORITY);
    		Log.i(TAG, "UI thread priority: " + Thread.currentThread().getPriority());
    		Thread thread4 = new Thread();
    		Thread thread5 = new Thread() {
    			@Override
    			public void run() {
    				long x = 1;
    				while (true) {
    					x += Fibonacci.recursive((int)x);
    				}
    			}
    		};
    		thread1.start();
    		thread2.start();
    		thread3.start();
    		thread4.start();
    		thread5.setPriority(Thread.MAX_PRIORITY);
    		thread5.start();
    		try {
				Thread.sleep(7*1000);
				thread5.setPriority(Thread.NORM_PRIORITY);
			} catch (InterruptedException e) {
			}
			*/
    	}
    }
    
    public void onClickNumberOfProcessors (View v) {
    	// will return 2 on a Galaxy Tab 10.1 or BeBox Dual603, but only 1 on a Nexus S or Logitech Revue
        final int proc = Runtime.getRuntime().availableProcessors();
        Log.i(TAG, "Number of available processors: " + proc);
    }
    
	private void testDatabase (String name, boolean oneTransaction) {
		String suffix = name == null ? " (memory, " : " (storage, ";
		suffix += oneTransaction ? "one transaction)" : "many transactions)";
		
		Cheeses c;
		long time;
		
		c = new Cheeses(name);
    	time = System.currentTimeMillis();
        c.populateWithStringBuilder(oneTransaction);
        time = System.currentTimeMillis() - time;
        c.dump();
        c.close();
        reportResultAndTime("populateWithStringBuilder"+suffix, 0, time);
        
        gcAndWait();
        c = new Cheeses(name);
    	time = System.currentTimeMillis();
        c.populateWithStringPlus(oneTransaction);
        time = System.currentTimeMillis() - time;
        c.dump();
        c.close();
        reportResultAndTime("populateWithStringPlus"+suffix, 0, time);
        
        gcAndWait();
        c = new Cheeses(name);
    	time = System.currentTimeMillis();
        c.populateWithStringFormat(oneTransaction);
        time = System.currentTimeMillis() - time;
        c.dump();
        c.close();
        reportResultAndTime("populateWithStringFormat"+suffix, 0, time);
        
        gcAndWait();
        c = new Cheeses(name);
    	time = System.currentTimeMillis();
        c.populateWithCompileStatement(oneTransaction);
        time = System.currentTimeMillis() - time;
        reportResultAndTime("populateWithCompilation"+suffix, 0, time);
    	time = System.currentTimeMillis();
    	c.iterateThroughAll(true);
    	time = System.currentTimeMillis() - time;
        reportResultAndTime("populateWithCompilation iterateAll"+suffix, 0, time);
    	time = System.currentTimeMillis();
    	c.iterateThroughAll(false);
    	time = System.currentTimeMillis() - time;
        reportResultAndTime("populateWithCompilation iterateSome"+suffix, 0, time);
        c.dump();
        c.close();

        gcAndWait();
        c = new Cheeses(name);
    	time = System.currentTimeMillis();
        c.populateWithContentValues(oneTransaction);
        time = System.currentTimeMillis() - time;
        c.dump();
        c.close();
        reportResultAndTime("populateWithContentValues"+suffix, 0, time);
        
        gcAndWait();
	}
	
	private long testStrictModeTooSlow (int n) {
		StrictMode.noteSlowCall("testStrictModeTooSlow " + n);
		return Fibonacci.recursive(n);
	}
	
	private void testStrictModeTooSlow() {
		int n = 0;
		while (true) {
			Log.i(TAG, "Testing tooSlow:"+ n);
			testStrictModeTooSlow(n);
			n++;
		}
	}
	
	//native private static void callNative();
	
    private String runFibonacciTests(int n) {
    	String message = "";
    	BigInteger rBig;
    	Long rLong;
    	long rPrimitiveLong;
    	long time;
    	
    	//testStrictModeTooSlow();
    	//callNative();
    	
    	if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
    		StrictMode.noteSlowCall("runFibonacciTests");
    	}
    	
    	if (nativeTracingEnabled) {
    		Debug.startNativeTracing();
    	}
    	
    	Log.i(TAG, "Number of bits = " + Fibonacci.recursiveFasterPrimitiveAndBigIntegerAndSparseArray(n).bitLength());
    	
    	// Calls
    	Log.i(TAG, "Number of calls for n=" + n);
    	if (n < recursionThreshold) { 
    		reportResult("recursive", Fibonacci.recursiveCalls(n));
    		reportResult("recursiveLoop", Fibonacci.recursiveLoopCalls(n));
    	}
    	reportResult("recursiveFaster", Fibonacci.recursiveFasterCalls(n, 2));
    	reportResult("recursiveFaster16", Fibonacci.recursiveFasterCalls(n, 16));
    	reportResult("recursiveFasterN", Fibonacci.recursiveFasterCalls(n, Fibonacci.PRECOMPUTED_SIZE));
    	
    	if (n >= 1000000) {
            gcAndWait();
            
        	startMethodTracing("recursiveFasterPrimitiveAndBigInteger");
        	time = System.currentTimeMillis();
            rBig = Fibonacci.recursiveFasterPrimitiveAndBigInteger(n);
            time = System.currentTimeMillis() - time;
        	stopMethodTracing();
        	message += "recursiveFasterPrimitiveAndBigInteger: " + time + " ms\n";
            reportResultAndTime("recursiveFasterPrimitiveAndBigInteger", rBig, time);
            
            gcAndWait();
            
        	startMethodTracing("recursiveFasterPrimitiveAndBigIntegerAndSparseArray");
        	time = System.currentTimeMillis();
            rBig = Fibonacci.recursiveFasterPrimitiveAndBigIntegerAndSparseArray(n);
            time = System.currentTimeMillis() - time;
        	stopMethodTracing();
        	message += "recursiveFasterPrimitiveAndBigIntegerAndSparseArray: " + time + " ms\n";
            reportResultAndTime("recursiveFasterPrimitiveAndBigIntegerAndSparseArray", rBig, time);
            
            return message;
    	}
    	
    	Log.d(TAG, "Primitive");

    	if (! recursiveFasterOnly) {
    		if (n < recursionThreshold) {
    			startMethodTracing("recursive");
    			time = System.currentTimeMillis();
    			rPrimitiveLong = Fibonacci.recursive(n);
    			time = System.currentTimeMillis() - time;
    			stopMethodTracing();
    			message += "recursive: " + time + " ms\n";
    			reportResultAndTime("recursive", rPrimitiveLong, time);

    			gcAndWait();

    			startMethodTracing("recursivePrimitiveInt");
    			time = System.currentTimeMillis();
    			rPrimitiveLong = Fibonacci.recursivePrimitiveInt(n);
    			time = System.currentTimeMillis() - time;
    			stopMethodTracing();
    			message += "recursivePrimitiveInt: " + time + " ms\n";
    			reportResultAndTime("recursivePrimitiveInt", rPrimitiveLong, time);

    			gcAndWait();

    			startMethodTracing("recursiveLoop");
    			time = System.currentTimeMillis();
    			rPrimitiveLong = Fibonacci.recursiveLoop(n);
    			time = System.currentTimeMillis() - time;
    			stopMethodTracing();
    			message += "recursiveLoop: " + time + " ms\n";
    			reportResultAndTime("recursiveLoop", rPrimitiveLong, time);

    			gcAndWait();

    			Fibonacci fib = new Fibonacci();
    			startMethodTracing("recursiveVirtual");
    			time = System.currentTimeMillis();
    			fib.recursiveVirtual(n);
    			time = System.currentTimeMillis() - time;
    			stopMethodTracing();
    			message += "recursiveVirtual: " + time + " ms\n";
    			reportResultAndTime("recursiveVirtual", fib.getResult(), time);

    			gcAndWait();
    		}

    		startMethodTracing("iterative");
    		time = System.currentTimeMillis();
    		rPrimitiveLong = Fibonacci.iterative(n);
    		time = System.currentTimeMillis() - time;
    		stopMethodTracing();
    		message += "iterative: " + time + " ms\n";
    		reportResultAndTime("iterative", rPrimitiveLong, time);

    		gcAndWait();

    		startMethodTracing("iterativeFaster");
    		time = System.currentTimeMillis();
    		rPrimitiveLong = Fibonacci.iterativeFaster(n);
    		time = System.currentTimeMillis() - time;
    		stopMethodTracing();
    		message += "iterativeFaster: " + time + " ms\n";
    		reportResultAndTime("iterativeFaster", rPrimitiveLong, time);

    		gcAndWait();

    		startMethodTracing("iterativeFasterPrimitiveInt");
    		time = System.currentTimeMillis();
    		rPrimitiveLong = Fibonacci.iterativeFasterPrimitiveInt(n);
    		time = System.currentTimeMillis() - time;
    		stopMethodTracing();
    		message += "iterativeFasterPrimitiveInt: " + time + " ms\n";
    		reportResultAndTime("iterativeFasterPrimitiveInt", rPrimitiveLong, time);

    		gcAndWait();
    	}

    	startMethodTracing("recursiveFaster");
    	time = System.currentTimeMillis();
        rPrimitiveLong = Fibonacci.recursiveFaster(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFaster: " + time + " ms\n";
        reportResultAndTime("recursiveFaster", rPrimitiveLong, time);
        
        gcAndWait();

        Log.d(TAG, "\nLong");
        
        if (! recursiveFasterOnly) {
        	if (n < recursionThreshold) {
        		startMethodTracing("recursiveLong");
        		time = System.currentTimeMillis();
        		rLong = Fibonacci.recursiveLong(n);
        		time = System.currentTimeMillis() - time;
        		stopMethodTracing();
        		message += "recursiveLong: " + time + " ms\n";
        		reportResultAndTime("recursiveLong", rLong, time);

        		gcAndWait();

        		startMethodTracing("recursiveLoopLong");
        		time = System.currentTimeMillis();
        		rLong = Fibonacci.recursiveLoopLong(n);
        		time = System.currentTimeMillis() - time;
        		stopMethodTracing();
        		message += "recursiveLoopLong: " + time + " ms\n";
        		reportResultAndTime("recursiveLoopLong", rLong, time);

        		gcAndWait();
        	}

        	startMethodTracing("iterativeLong");
        	time = System.currentTimeMillis();
        	rLong = Fibonacci.iterativeLong(n);
        	time = System.currentTimeMillis() - time;
        	stopMethodTracing();
        	message += "iterativeLong: " + time + " ms\n";
        	reportResultAndTime("iterativeLong", rLong, time);

        	gcAndWait();

        	startMethodTracing("iterativeFasterLong");
        	time = System.currentTimeMillis();
        	rLong = Fibonacci.iterativeFasterLong(n);
        	time = System.currentTimeMillis() - time;
        	stopMethodTracing();
        	message += "iterativeFasterLong: " + time + " ms\n";
        	reportResultAndTime("iterativeFasterLong", rLong, time);

        	gcAndWait();
        }

        startMethodTracing("recursiveFasterLong");
        time = System.currentTimeMillis();
        rLong = Fibonacci.recursiveFasterLong(n);
        time = System.currentTimeMillis() - time;
        stopMethodTracing();
        message += "recursiveFasterLong: " + time + " ms\n";
        reportResultAndTime("recursiveFasterLong", rLong, time);

        gcAndWait();

        Log.d(TAG, "\nBigInteger");

        if (! recursiveFasterOnly) {
        	if (n < recursionThreshold) {
        		startMethodTracing("recursiveBigInteger");
        		time = System.currentTimeMillis();
        		rBig = Fibonacci.recursiveBigInteger(n);
        		time = System.currentTimeMillis() - time;
        		stopMethodTracing();
        		message += "recursiveBigInteger: " + time + " ms\n";
        		reportResultAndTime("recursiveBigInteger", rBig, time);

        		gcAndWait();

        		startMethodTracing("recursiveLoopBigInteger");
        		time = System.currentTimeMillis();
        		rBig = Fibonacci.recursiveLoopBigInteger(n);
        		time = System.currentTimeMillis() - time;
        		stopMethodTracing();
        		message += "recursiveLoopBigInteger: " + time + " ms\n";
        		reportResultAndTime("recursiveLoopBigInteger", rBig, time);

        		gcAndWait();
        	}

        	startMethodTracing("iterativeBigInteger");
        	time = System.currentTimeMillis();
        	rBig = Fibonacci.iterativeBigInteger(n);
        	time = System.currentTimeMillis() - time;
        	stopMethodTracing();
        	message += "iterativeBigInteger: " + time + " ms\n";
        	reportResultAndTime("iterativeBigInteger", rBig, time);

        	gcAndWait();

        	startMethodTracing("iterativeFasterBigInteger");
        	time = System.currentTimeMillis();
        	rBig = Fibonacci.iterativeFasterBigInteger(n);
        	time = System.currentTimeMillis() - time;
        	stopMethodTracing();
        	message += "iterativeFasterBigInteger: " + time + " ms\n";
        	reportResultAndTime("iterativeFasterBigInteger", rBig, time);

        	gcAndWait();

        	startMethodTracing("iterativeFasterBigIntegerReturnZero");
        	time = System.currentTimeMillis();
        	rBig = Fibonacci.iterativeFasterBigIntegerReturnZero(n);
        	time = System.currentTimeMillis() - time;
        	stopMethodTracing();
        	message += "iterativeFasterBigIntegerReturnZero: " + time + " ms\n";
        	reportResultAndTime("iterativeFasterBigIntegerReturnZero", rBig, time);

        	gcAndWait();
        }

    	startMethodTracing("recursiveFasterBigInteger");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFasterBigInteger(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFasterBigInteger: " + time + " ms\n";
        reportResultAndTime("recursiveFasterBigInteger", rBig, time);
        reportResult("calls to recursiveFasterBigInteger", Fibonacci.recursiveFasterCalls(n, 2));
        
        gcAndWait();

    	startMethodTracing("recursiveFasterBigIntegerReturnZero");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFasterBigIntegerReturnZero(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFasterBigIntegerReturnZero: " + time + " ms\n";
        reportResultAndTime("recursiveFasterBigIntegerReturnZero", rBig, time);
        
        gcAndWait();

    	startMethodTracing("recursiveFaster16BigInteger");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFaster16BigInteger(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFaster16BigInteger: " + time + " ms\n";
        reportResultAndTime("recursiveFaster16BigInteger", rBig, time);
        reportResult("calls to recursiveFaster16BigInteger", Fibonacci.recursiveFasterCalls(n, 16));

        gcAndWait();

    	startMethodTracing("recursiveFaster64BigInteger");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFaster64BigInteger(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFaster64BigInteger: " + time + " ms\n";
        reportResultAndTime("recursiveFaster64BigInteger", rBig, time);

        gcAndWait();

    	startMethodTracing("recursiveFaster128BigInteger");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFaster128BigInteger(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFaster128BigInteger: " + time + " ms\n";
        reportResultAndTime("recursiveFaster128BigInteger", rBig, time);

        gcAndWait();

    	startMethodTracing("recursiveFasterNBigInteger");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFasterNBigInteger(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFasterNBigInteger: " + time + " ms\n";
        reportResultAndTime("recursiveFasterNBigInteger", rBig, time);
        reportResult("calls to recursiveFasterNBigInteger", Fibonacci.recursiveFasterCalls(n, Fibonacci.PRECOMPUTED_SIZE));
        
        gcAndWait();

    	startMethodTracing("recursiveFasterN2BigInteger");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFasterN2BigInteger(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFasterN2BigInteger: " + time + " ms\n";
        reportResultAndTime("recursiveFasterN2BigInteger", rBig, time);
        
        gcAndWait();
        
    	startMethodTracing("recursiveFasterPrimitiveAndBigInteger");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFasterPrimitiveAndBigInteger(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFasterPrimitiveAndBigInteger: " + time + " ms\n";
        reportResultAndTime("recursiveFasterPrimitiveAndBigInteger", rBig, time);
        
        gcAndWait();
        
    	startMethodTracing("recursiveFasterPrimitiveAndBigIntegerAndSparseArray");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFasterPrimitiveAndBigIntegerAndSparseArray(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFasterPrimitiveAndBigIntegerAndSparseArray: " + time + " ms\n";
        reportResultAndTime("recursiveFasterPrimitiveAndBigIntegerAndSparseArray", rBig, time);
        
        gcAndWait();
        
    	startMethodTracing("recursiveFasterPrimitiveAndBigIntegerAndHashMap");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFasterPrimitiveAndBigIntegerAndHashMap(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFasterPrimitiveAndBigIntegerAndHashMap: " + time + " ms\n";
        reportResultAndTime("recursiveFasterPrimitiveAndBigIntegerAndHashMap", rBig, time);
        
        gcAndWait();
        
    	startMethodTracing("recursiveFasterPrimitiveAndBigIntegerAndHashMapAndThreadingBad");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFasterPrimitiveAndBigIntegerAndHashMapAndThreadingBad(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFasterPrimitiveAndBigIntegerAndHashMapAndThreadingBad: " + time + " ms\n";
        reportResultAndTime("recursiveFasterPrimitiveAndBigIntegerAndHashMapAndThreadingBad", rBig, time);
        
        gcAndWait();
        
    	startMethodTracing("recursiveFasterPrimitiveAndBigIntegerAndHashMapAndThreading");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFasterPrimitiveAndBigIntegerAndHashMapAndThreading(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFasterPrimitiveAndBigIntegerAndHashMapAndThreading: " + time + " ms\n";
        reportResultAndTime("recursiveFasterPrimitiveAndBigIntegerAndHashMapAndThreading", rBig, time);
        
        gcAndWait();
        
    	startMethodTracing("recursiveFasterBigIntegerAndThreadingNoDependencies");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFasterBigIntegerAndThreadingNoDependencies(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFasterBigIntegerAndThreadingNoDependencies: " + time + " ms\n";
        reportResultAndTime("recursiveFasterBigIntegerAndThreadingNoDependencies", rBig, time);
        
        gcAndWait();
        
    	startMethodTracing("recursiveFasterBigIntegerAndThreadingNoDependencies2");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFasterBigIntegerAndThreadingNoDependencies2(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFasterBigIntegerAndThreadingNoDependencies2: " + time + " ms\n";
        reportResultAndTime("recursiveFasterBigIntegerAndThreadingNoDependencies2", rBig, time);
        
        gcAndWait();
        
    	startMethodTracing("recursiveFasterBigIntegerAndThreadingUsingPrimitiveLong");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFasterBigIntegerAndThreadingUsingPrimitiveLong(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFasterBigIntegerAndThreadingUsingPrimitiveLong: " + time + " ms\n";
        reportResultAndTime("recursiveFasterBigIntegerAndThreadingUsingPrimitiveLong", rBig, time);
        
        gcAndWait();
        
    	startMethodTracing("recursiveFasterBigIntegerAndThreadingUsingPrimitiveLongOneThread");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFasterBigIntegerAndThreadingUsingPrimitiveLongOneThread(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFasterBigIntegerAndThreadingUsingPrimitiveLongOneThread: " + time + " ms\n";
        reportResultAndTime("recursiveFasterBigIntegerAndThreadingUsingPrimitiveLongOneThread", rBig, time);
        
        gcAndWait();
        
    	startMethodTracing("recursiveFasterBigIntegerAndThreadingUsingPrimitiveLong2");
    	time = System.currentTimeMillis();
        rBig = Fibonacci.recursiveFasterBigIntegerAndThreadingUsingPrimitiveLong2(n);
        time = System.currentTimeMillis() - time;
    	stopMethodTracing();
    	message += "recursiveFasterBigIntegerAndThreadingUsingPrimitiveLong2: " + time + " ms\n";
        reportResultAndTime("recursiveFasterBigIntegerAndThreadingUsingPrimitiveLong2", rBig, time);
        
        if (nativeTracingEnabled) {
    		Debug.stopNativeTracing();
    	}
        
        return message;
    }
    
    private void gcAndWait() {
    	if (garbageCollectionEnabled) {
    		System.gc();
    	}
    	if (delayEnabled) {
    		try {
    			Thread.sleep(delay);
    		} catch (InterruptedException e) {
    			System.out.println(e.getStackTrace());
    		}
    	}
    }
    
    private void reportResult(String s, Object result) {
    	Log.i(TAG, s + ": " + result);
    }

    private void reportResultAndTime(String s, Object result, long time) {
    	Log.i(TAG, s + " (" + time + " ms): " + result);
    }
    
    private void startMethodTracing(String traceName) {
    	if (methodTracingEnabled) {
    		Debug.startMethodTracing(traceName);
    	}
    }
    
    private void stopMethodTracing() {
    	if (methodTracingEnabled) {
    		Debug.stopMethodTracing();
    	}
    }
    
    private void alertResults(String message) {
    	AlertDialog.Builder builder = new AlertDialog.Builder(this);
        AlertDialog ad = builder.create();
        //ad.setTitle(R.string.resultDialogTitle);
        ad.setMessage(message.trim());
        ad.show();
    }
    
    public synchronized void doSomething (Object o) {
    	// do something with object
    }
    
    public void doSomething2 (Object o) {
    	synchronized (o) {
        	// do something with object
    	}
    	
    	// do something else here, no locking needed
    }
    
    private static final int ITERATIONS = 1000000;
    
    private static void testFibonacci (int n) {
    	long time = System.currentTimeMillis();
    	for (int i = 0; i < ITERATIONS; i++) {
    		// call iterativeFaster(n) or iterativeFasterNative(n) here
    	}
    	time = System.currentTimeMillis() - time;
    	Log.i("Fibonacci", String.valueOf(n)+"> Total time: " + time + " milliseconds");
    }
    
    private static void testFibonacci () {
    	for (int i = 0; i <= 92; i++) {
    		testFibonacci(i);
    	}
    }
    
    private void foo() {
    	MyThread thread = new MyThread("");
    	thread.start();
    	
    	// later...
    	Handler handler = thread.getHandler();
    	
    	// to post a runnable
    	handler.post(new Runnable() {
			public void run() {
				Log.i(TAG, "Where am I? " + Thread.currentThread().getName());
			}
    	});
    	
    	// to send a message
    	int what = 0; // define your own values
    	int arg1 = 1;
    	int arg2 = 2;
    	Message msg = Message.obtain(handler, what, arg1, arg2);
    	handler.sendMessage(msg);
    	
    	// another message...
    	what = 1;
    	msg = Message.obtain(handler, what, new Long(Thread.currentThread().getId()));
    	handler.sendMessageAtFrontOfQueue(msg);
    }
    
    private void createTwoThreads() {
    	// the run() method can simply be overridden...
        Thread thread1 = new Thread("cheese1") {
            @Override
            public void run() {
                Log.i(TAG, "I like Munster");
            }
        };
        
        // ...or a Runnable object can be passed to the Thread constructor
        Thread thread2 = new Thread(new Runnable() {
            public void run() {
                Log.i(TAG, "I like Roquefort");
            }
        }, "cheese2");

        // remember to call start() else the threads won�t be spawned and nothing will happen
        thread1.start();
        thread2.start();
    }
  
    private void createThreadWithPriority() {
    	Thread thread = new Thread("thread name") {
            @Override
            public void run() {
                // do something here
            }
        };
        thread.setPriority(Thread.MAX_PRIORITY); // highest priority (higher than UI thread)
        thread.start();
    }
    
    public void onClickGood (View v) {
        new Thread(new Runnable() {
            public void run() {
                // note the 'final' keyword here (try removing it and see what happens)
                final BigInteger f = Fibonacci.recursiveFasterPrimitiveAndBigInteger(100000);
                mTextView.post(new Runnable() {
                    public void run() {
                        mTextView.setText(f.toString());
                    }
                });
            }
        }, "fibonacci").start();
    }

    public void onClickBad (View v) {
        new Thread(new Runnable() {
            public void run() {
                BigInteger f = Fibonacci.recursiveFasterPrimitiveAndBigInteger(100000);
                mTextView.setText(f.toString()); // will throw an exception
            }
        }, "fibonacci").start();
    }

    public void onClickCreateTwoThreads (View v) {
    	createTwoThreads();
    }
    
    public void onClickCreateThreadWithPriority (View v) {
    	createThreadWithPriority();
    }
    
    public void onClickAsyncTask (View v) {
        // AsyncTask<Params, Progress, Result> anonymous class 
        new AsyncTask<Integer, Void, BigInteger>() {
            @Override
            protected BigInteger doInBackground(Integer... params) {
                return Fibonacci.recursiveFasterPrimitiveAndBigInteger(params[0]);
            }

            @Override
            protected void onPostExecute(BigInteger result) {
                mTextView.setText(result.toString());
            }
        }.execute(100000);
    }

    public void onClickCreateMyThread (View v) {
    	MyThread thread = new MyThread("looper thread");
        thread.start();
        
        try {
			Thread.sleep(50);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
        
        // later...
        Handler handler = thread.getHandler(); // careful: this could return null if the handler is not initialized yet
        
        // to post a runnable
        handler.post(new Runnable() {
            public void run() {
                Log.i(TAG, "Where am I? " + Thread.currentThread().getName());
            }
        });
        
        // to send a message
        int what = 0; // define your own values
        int arg1 = 1;
        int arg2 = 2;
        Message msg = Message.obtain(handler, what, arg1, arg2);
        handler.sendMessage(msg);
        
        // another message...
        what = 1;
        msg = Message.obtain(handler, what, new Long(Thread.currentThread().getId()));
        handler.sendMessageAtFrontOfQueue(msg);
        
        // to exit...
        what = 2;
        msg = Message.obtain(handler, what, new Long(Thread.currentThread().getId()));
        handler.sendMessage(msg);
    }
    
    public void onClickCreateMyHandlerThread (View v) {
    	MyHandlerThread thread = new MyHandlerThread("handler thread");
        thread.start();
        
        // later...
        Handler handler = thread.getHandler(); // careful: this could return null if the handler is not initialized yet
        
        // to post a runnable
        handler.post(new Runnable() {
            public void run() {
                Log.i(TAG, "Where am I? " + Thread.currentThread().getName());
            }
        });
        
        // to send a message
        int what = 0; // define your own values
        int arg1 = 1;
        int arg2 = 2;
        Message msg = Message.obtain(handler, what, arg1, arg2);
        handler.sendMessage(msg);
        
        // another message...
        what = 1;
        msg = Message.obtain(handler, what, new Long(Thread.currentThread().getId()));
        handler.sendMessageAtFrontOfQueue(msg);
        
        // to exit...
        what = 2;
        msg = Message.obtain(handler, what, new Long(Thread.currentThread().getId()));
        handler.sendMessage(msg);
    }
    
    public void onClickDownloadFiles (View v) {
    	AsyncTask<String, Object, Void> task = new AsyncTask<String, Object, Void>() {

    	    private ByteArrayBuffer downloadFile(String urlString, byte[] buffer) {
    	        try {
    	            URL url = new URL(urlString);
    	            URLConnection connection = url.openConnection();
    	            InputStream is = connection.getInputStream();
    	            //Log.i(TAG, "InputStream: " + is.getClass().getName()); // if you are curious
    	            //is = new BufferedInputStream(is); // optional line, try with and without
    	            ByteArrayBuffer baf = new ByteArrayBuffer(640 * 1024); // ought to be enough for everybody?
    	            int len;
    	            while ((len = is.read(buffer)) != -1) {
    	                baf.append(buffer, 0, len);
    	            }
    	            return baf;
    	        } catch (MalformedURLException e) {
    	            return null;
    	        } catch (IOException e) {
    	            return null;
    	        }
    	    }

    	    @Override
    	    protected Void doInBackground(String... params) {
    	        if (params != null && params.length > 0) {
    	            byte[] buffer = new byte[4 * 1024]; // try different sizes (1 for example will give lower performance)
    	            for (String url : params) {
    	                long time = System.currentTimeMillis();
    	                ByteArrayBuffer baf = downloadFile(url, buffer);
    	                time = System.currentTimeMillis() - time;
    	                publishProgress(url, baf, time);
    	            }
    	        } else {
    	            publishProgress(null, null);
    	        }
    	        return null; // we don�t care about any result but we still have to return something
    	    }

    	    @Override
    	    protected void onProgressUpdate(Object... values) {
    	        // values[0] is the URL (String), values[1] is the buffer (ByteArrayBuffer), values[2] is the duration
    	        String url = (String) values[0];
    	        ByteArrayBuffer buffer = (ByteArrayBuffer) values[1];
    	        if (buffer != null) {
    	            long time = (Long) values[2];
    	            Log.i(TAG, "Downloaded " + url + " (" + buffer.length() + " bytes) in " + time + " milliseconds");
    	        } else {
    	            Log.w(TAG, "Could not download " + url);
    	        }

    	        // update UI accordingly, etc
    	    }
    	};

    	String url1 = "http://www.google.com/index.html";
    	String url2 = "http://d.android.com/reference/android/os/AsyncTask.html";
    	task.execute(url1, url2);	
    	//task.execute("http://d.android.com/resources/articles/painless-threading.html"); // try that to get exception
    }
}