package com.geekdev.l6listbasedview;

import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;


public class CustomListViewActivity extends ActionBarActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_custom_list_view);

        final List<Animal> animals = new ArrayList<>();
        animals.add(new Animal("Manatee", "manatee.jpeg"));
        animals.add(new Animal("Narwhal", "narwhal.jpeg"));
        animals.add(new Animal("Orca Whale", "orcawhale.jpeg"));

        ListView listView = (ListView) findViewById(R.id.listView);
        listView.setAdapter(new CustomAdapter(this, R.layout.custom_row, animals));
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                // Pass the Animal details to the DetailActivity. Alternatively, you can serialize
                // the Animal class and pass it to the new Intent
                Animal animal = animals.get(position);
                Bundle bundle = new Bundle();
                bundle.putString("name", animal.getName());
                bundle.putString("filepath", animal.getFilename());
                Intent intent = new Intent(CustomListViewActivity.this, DetailActivity.class);
                startActivity(intent);
            }
        });
    }
}
