package com.geekdev.l6listbasedview;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public class CustomAdapter extends ArrayAdapter<Animal> {

    private final List<Animal> animals;

    public CustomAdapter(Context context, int resource, List<Animal> animals) {
        super(context, resource, animals);
        this.animals = animals;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        return getAnimalView(position, convertView, parent);
    }

    @Override
    public View getDropDownView(int position, View convertView, ViewGroup parent) {
        return getAnimalView(position, convertView, parent);
    }

    public View getAnimalView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) getContext().getSystemService
                (Context.LAYOUT_INFLATER_SERVICE);
        View row = inflater.inflate(R.layout.custom_row, null);

        TextView textView = (TextView) row.findViewById(R.id.rowText);
        textView.setText(animals.get(position).getName());

        try {
            ImageView imageView = (ImageView) row.findViewById(R.id.rowImage);
            String filename = animals.get(position).getFilename();
            InputStream inputStream = getContext().getAssets().open(filename);
            Drawable drawable = Drawable.createFromStream(inputStream, null);
            imageView.setImageDrawable(drawable);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return row;    }
}
