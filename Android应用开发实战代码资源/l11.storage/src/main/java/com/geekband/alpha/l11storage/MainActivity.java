package com.geekband.alpha.l11storage;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;

import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;


public class MainActivity extends ActionBarActivity {

    private int count = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        final SharedPreferences sharedPref = getPreferences(Context.MODE_PRIVATE);
        count = sharedPref.getInt("counter", 0);


        String FILENAME = "diary.txt";
        String string = "hello world!";

        try {
            FileOutputStream fos = openFileOutput(FILENAME,
                    Context.MODE_PRIVATE);
            fos.write(string.getBytes());
            fos.close();

            BufferedReader reader = new BufferedReader(new
                    InputStreamReader(openFileInput(FILENAME)));
            Log.d("TAG", "From file: " + reader.readLine());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    @Override
    protected void onPause(){
      super.onPause();
      count++;
        SharedPreferences sharedPref = getPreferences(Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putInt("counter", count);
        //editor.commit();
      editor.apply();
    }
}
