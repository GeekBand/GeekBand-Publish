package com.geekdev.l4views;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Toast;


public class RadioButtonActivity extends ActionBarActivity {

    private RadioGroup radioGroup;
    private RadioButton katyRadioButton;
    private RadioButton rabbitButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_radio_button);

        radioGroup = (RadioGroup) findViewById(R.id.radio_group);
        katyRadioButton = (RadioButton) findViewById(R.id.katy_perry_button);
        rabbitButton = (RadioButton) findViewById(R.id.rabbit_button);

        Button voteButton = (Button) findViewById(R.id.vote_button);
        voteButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (katyRadioButton.getId() == radioGroup.getCheckedRadioButtonId()) {
                    Toast.makeText(RadioButtonActivity.this, "Katy chosen", Toast.LENGTH_SHORT).show();
                } else if (rabbitButton.getId() == radioGroup.getCheckedRadioButtonId()) {
                    Toast.makeText(RadioButtonActivity.this, "Rabbit chosen", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(RadioButtonActivity.this, "Nothing chosen", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

}
