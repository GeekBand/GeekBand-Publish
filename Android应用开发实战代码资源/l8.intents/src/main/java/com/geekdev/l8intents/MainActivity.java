package com.geekdev.l8intents;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.v7.app.ActionBarActivity;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;


public class MainActivity extends ActionBarActivity {

    static final int REQUEST_IMAGE_CAPTURE = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button callButton = (Button) findViewById(R.id.button);
        callButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                String myPhoneNumberUri = "tel:32531234";
//                Intent intent = new Intent(Intent.ACTION_DIAL, Uri.parse(myPhoneNumberUri));
//                Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse(myPhoneNumberUri));
//                startActivity(intent);

                Intent intent = new Intent(MainActivity.this, PhoneActivity.class);
                Bundle bundle = new Bundle();
                bundle.putString("phoneNumber", "88888888");
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

        Button takePhotoButton = (Button) findViewById(R.id.takePhotoButton);
        takePhotoButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
                    startActivityForResult(takePictureIntent, REQUEST_IMAGE_CAPTURE);
                }
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_IMAGE_CAPTURE && resultCode == RESULT_OK) {
            Bundle extras = data.getExtras();
            Bitmap imageBitmap = (Bitmap) extras.get("data");
            ImageView imageView = (ImageView) findViewById(R.id.imageView);
            imageView.setImageBitmap(imageBitmap);
        }
    }
}
