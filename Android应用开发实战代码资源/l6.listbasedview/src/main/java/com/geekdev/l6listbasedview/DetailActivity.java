package com.geekdev.l6listbasedview;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;


public class DetailActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);

        String name = getIntent().getExtras().getString("name");
        String filepath = getIntent().getExtras().getString("filepath");
        // TODO(ago): Set name and image into the activity_detail layout file.
    }
}
