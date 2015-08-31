package com.geekdev.l4views;

import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.Toast;


public class CheckboxActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_checkbox);

        final CheckBox hoppingCheckbox = (CheckBox) findViewById(R.id.hopping_checkbox);
        final CheckBox sleepingCheckbox = (CheckBox) findViewById(R.id.sleeping_checkbox);
        Button buyButton = (Button) findViewById(R.id.buy_button);

        buyButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String outputString = "Buying: ";
                if (hoppingCheckbox.isChecked()) {
                    outputString += " hopping";
                }
                if (sleepingCheckbox.isChecked()) {
                    outputString += " sleeping";
                }
                Toast.makeText(CheckboxActivity.this, outputString, Toast.LENGTH_SHORT).show();
            }
        });
    }

}
