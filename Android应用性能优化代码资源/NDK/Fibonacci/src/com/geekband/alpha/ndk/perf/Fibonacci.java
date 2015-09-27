package com.geekband.alpha.ndk.perf;



import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

public class Fibonacci extends Activity implements OnClickListener {
  TextView textResult;
  Button buttonGo;
  EditText editInput;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.main);

    // Find UI views
    editInput = (EditText) findViewById(R.id.editInput);
    textResult = (TextView) findViewById(R.id.textResult);
    buttonGo = (Button) findViewById(R.id.buttonGo);
    buttonGo.setOnClickListener(this);
  }

  public void onClick(View view) {
    int input = Integer.parseInt(editInput.getText().toString());
    long start, stop;
    int result;
    String out = "";

    // Java - Recursive
    start = System.currentTimeMillis();
    result = FibLib.fibJ(input);
    stop = System.currentTimeMillis();
    out += String.format("Java recursive: %d (%d msec)", result, stop - start);

    // Java - Iterative
    start = System.currentTimeMillis();
    result = FibLib.fibJI(input);
    stop = System.currentTimeMillis();
    out += String.format("\nJava iterative: %d (%d msec)", result, stop - start);

    // Native - Recursive
    start = System.currentTimeMillis();
    result = FibLib.fibN(input);
    stop = System.currentTimeMillis();
    out += String.format("\nNative recursive: %d (%d msec)", result, stop - start);

    // Native - Iterative
    start = System.currentTimeMillis();
    result = FibLib.fibNI(input);
    stop = System.currentTimeMillis();
    out += String.format("\nNative iterative: %d (%d msec)", result, stop - start);

    textResult.setText(out);
  }
}