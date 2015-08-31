package com.geekdev.l6listbasedview;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Spinner;

import java.util.ArrayList;
import java.util.List;


public class CustomSpinnerActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_custom_spinner);

        final List<Animal> animals = new ArrayList<>();
        animals.add(new Animal("Manatee", "manatee.jpeg"));
        animals.add(new Animal("Narwhal", "narwhal.jpeg"));
        animals.add(new Animal("Orca Whale", "orcawhale.jpeg"));

        Spinner spinner = (Spinner) findViewById(R.id.spinner);
        spinner.setAdapter(new CustomAdapter(this, R.layout.custom_row, animals));
    }
}
