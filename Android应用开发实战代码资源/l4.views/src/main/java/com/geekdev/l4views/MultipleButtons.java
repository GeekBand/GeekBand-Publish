package com.geekdev.l4views;

import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

public class MultipleButtons extends ActionBarActivity implements View.OnClickListener {

    private Button button1;
    private Button button2;
    private Button button3;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_multiple_buttons);

        button1 = (Button) findViewById(R.id.button1);
        button2 = (Button) findViewById(R.id.button2);
        button3 = (Button) findViewById(R.id.button3);

        button1.setOnClickListener(this);
        button2.setOnClickListener(this);
        button3.setOnClickListener(this);
    }

    public void button_click(View v) {
        if (v.getId() == button1.getId()) {
            Toast.makeText(MultipleButtons.this, "Button1 pushed!", Toast.LENGTH_SHORT).show();
        } else if (v.getId() == button2.getId()) {
            Toast.makeText(MultipleButtons.this, "Button2 pushed!", Toast.LENGTH_SHORT).show();
        } else if (v.getId() == button3.getId()) {
            Toast.makeText(MultipleButtons.this, "Button3 pushed!", Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == button1.getId()) {
            Toast.makeText(MultipleButtons.this, "Button1 pushed!", Toast.LENGTH_SHORT).show();
        } else if (v.getId() == button2.getId()) {
            Toast.makeText(MultipleButtons.this, "Button2 pushed!", Toast.LENGTH_SHORT).show();
        } else if (v.getId() == button3.getId()) {
            Toast.makeText(MultipleButtons.this, "Button3 pushed!", Toast.LENGTH_SHORT).show();
        }
    }
}
