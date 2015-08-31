package com.geekdev.l8intents;

import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.widget.TextView;


public class PhoneActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_phone);

        String phoneNumber = getIntent().getExtras().getString("phoneNumber");
        TextView textView = (TextView) findViewById(R.id.phoneNumber);
        textView.setText(phoneNumber);
    }

}
