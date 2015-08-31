package com.geekband.alpha.contentprovider;

import android.content.ContentUris;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.CalendarContract;
import android.provider.ContactsContract;
import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.alpha.contentprovider.R;

import java.util.Calendar;

public class MainActivity extends AppCompatActivity {
private TextView resultTextView;
  @Override protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    resultTextView = (TextView)findViewById(R.id.resultTextView);

    Button mediaStorebutton = (Button)findViewById(R.id.button1);
    mediaStorebutton.setOnClickListener(new View.OnClickListener() {
      @Override public void onClick(View v) {
        displayAllAudio();
      }
    });

    Button contactsButton = (Button)findViewById(R.id.button2);
    contactsButton.setOnClickListener(new View.OnClickListener() {
      @Override public void onClick(View v) {
        displayAllContactsName();
      }
    });

    Button contactButton2 = (Button)findViewById(R.id.button3);
    contactButton2.setOnClickListener(new View.OnClickListener() {
      @Override public void onClick(View v) {
        contactLookup2();
      }
    });

    Button reverseLookupButton = (Button)findViewById(R.id.button4);
    reverseLookupButton.setOnClickListener(new View.OnClickListener() {
      @Override public void onClick(View v) {
        reverseLookupContact();

      }
    });

    Button pickContactButton = (Button)findViewById(R.id.button5);
    pickContactButton.setOnClickListener(new View.OnClickListener() {
      @Override public void onClick(View v) {
        pickContact();
      }
    });

    Button insertContatButton = (Button)findViewById(R.id.button6);
    insertContatButton.setOnClickListener(new View.OnClickListener() {
      @Override public void onClick(View v) {
        insertContactWithIntent();
      }
    });
    Button queryCalendarButton = (Button)findViewById(R.id.button7);

    queryCalendarButton.setOnClickListener(new View.OnClickListener() {
      @Override public void onClick(View v) {
        queryCalendar();

      }
    });

    Button insertCalendarButton = (Button)findViewById(R.id.button8);
    insertCalendarButton.setOnClickListener(new View.OnClickListener() {
      @Override public void onClick(View v) {
        insertEventToCalendar();
      }
    });

    Button editCalendarButton = (Button)findViewById(R.id.button9);
    editCalendarButton.setOnClickListener(new View.OnClickListener() {
      @Override public void onClick(View v) {
        long rowID = 830;
        Uri uri = ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI,rowID);
        Intent intent = new Intent(Intent.ACTION_EDIT,uri);

        intent.putExtra(CalendarContract.EXTRA_EVENT_ALL_DAY,true);

        startActivity(intent);
      }
    });

    Button viewEventButton = (Button)findViewById(R.id.button10);
    viewEventButton.setOnClickListener(new View.OnClickListener() {
      @Override public void onClick(View v) {
        Calendar startTime = Calendar.getInstance();
        startTime.set(2015, 8, 18, 19, 30);

        Uri uri = Uri.parse("content://com.android.calendar/time/" + String.
        valueOf(startTime.getTimeInMillis()));

        Intent intent = new Intent(Intent.ACTION_VIEW,uri);
        startActivity(intent);
      }
    });

  }

  private void insertEventToCalendar() {
    Intent intent = new Intent(Intent.ACTION_INSERT,CalendarContract.Events.CONTENT_URI);
    intent.putExtra(CalendarContract.Events.TITLE,"Outing!");
    intent.putExtra(CalendarContract.Events.DESCRIPTION, "" + "Enjoy sporting");
    intent.putExtra(CalendarContract.Events.EVENT_LOCATION, "pudong");

    Calendar startTime = Calendar.getInstance();
    startTime.set(2015, 8, 18, 19, 30);
    intent.putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime.getTimeInMillis());
    startTime.set(2015, 8, 18, 20, 30);
    intent.putExtra(CalendarContract.EXTRA_EVENT_END_TIME, startTime.getTimeInMillis());
startActivity(intent);
  }

  private void queryCalendar() {
    String[] project = new String[]{
        CalendarContract.Events._ID,
        CalendarContract.Events.TITLE
    };

    Cursor cursor = getContentResolver().query(
        CalendarContract.Events.CONTENT_URI,project,null,null,null
    );

    int idIdx = cursor.getColumnIndexOrThrow(CalendarContract.Events._ID);
    int titleIdx = cursor.getColumnIndexOrThrow(CalendarContract.Events.TITLE);

    StringBuilder result = new StringBuilder();
    while(cursor.moveToNext()){
      String title = cursor.getString(titleIdx);
      String id = cursor.getString(idIdx);
      result.append(title + " (" + id + ")");
    }

    cursor.close();
    resultTextView.setText(result.toString());
  }

  private void insertContactWithIntent() {
    Intent intent = new Intent(ContactsContract.Intents.SHOW_OR_CREATE_CONTACT,
        ContactsContract.Contacts.CONTENT_URI);
    intent.setData(Uri.parse("tel:13999999999"));
    intent.putExtra(ContactsContract.Intents.Insert.COMPANY, "geekband");
    intent.putExtra(ContactsContract.Intents.Insert.POSTAL,"shanghai pudong");

    startActivity(intent);
  }

  private static int PICK_CONTACT_REQUET_CODE = 0;
  private void pickContact() {
    Intent intent = new Intent(Intent.ACTION_PICK,ContactsContract.Contacts.CONTENT_URI);
    startActivityForResult(intent, PICK_CONTACT_REQUET_CODE);

  }

  @Override protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);

    if((requestCode == PICK_CONTACT_REQUET_CODE)&&(resultCode == RESULT_OK)){
      resultTextView.setText(data.getData().toString());
    }
  }

  private void contactLookup2() {
    String searchName = "Tt";
    Uri lookupUri = Uri.withAppendedPath(ContactsContract.Contacts.CONTENT_FILTER_URI,searchName);
    String[] projection = new String[]{
        ContactsContract.Contacts._ID
    };
    Cursor idCursor = getContentResolver().query(lookupUri,projection,null,null,null);
    String id =null;
    if(idCursor.moveToNext()){
      int idIdx = idCursor.getColumnIndexOrThrow(ContactsContract.Contacts._ID);
      id = idCursor.getString(idIdx);
    }
    idCursor.close();

    if(id !=null)
    {
      String where = ContactsContract.Contacts.Data.RAW_CONTACT_ID +
          " = " + id + " AND " + ContactsContract.Contacts.Data.MIMETYPE +
          " = '" + ContactsContract.CommonDataKinds.Phone.NUMBER + "'";

      projection = new String[]{
          ContactsContract.Contacts.DISPLAY_NAME,
          ContactsContract.CommonDataKinds.Phone.NUMBER
      };

      Cursor dataCursor = getContentResolver().query(ContactsContract.Contacts.CONTENT_URI,
          projection,where,null,null);

      int nameIdx = dataCursor.getColumnIndexOrThrow(ContactsContract.Contacts.DISPLAY_NAME);
      int phoneIdx = dataCursor.getColumnIndexOrThrow(ContactsContract.CommonDataKinds.Phone.NUMBER);

      StringBuilder result = new StringBuilder();
      while(dataCursor.moveToNext()){
        String name = dataCursor.getString(nameIdx);
        String number = dataCursor.getString(phoneIdx);
        result.append(name + " (" + number + ")");
      }

      dataCursor.close();

      resultTextView.setText(result.toString());
    }
  }

  private void reverseLookupContact() {
    String outgoingNumber = "13588888888";
    String result = "Not found";

    Uri lookupUri = Uri.withAppendedPath(ContactsContract.PhoneLookup.CONTENT_FILTER_URI,outgoingNumber);

    String[] projection = new String[]{
      ContactsContract.Contacts.DISPLAY_NAME
    };

    Cursor cursor = getContentResolver().query(lookupUri,projection,null,null,null);

    if(cursor.moveToNext()){
      int nameIdx = cursor.getColumnIndexOrThrow(ContactsContract.Contacts.DISPLAY_NAME);

      resultTextView.setText(cursor.getString(nameIdx));
    }
  }

  private void displayAllContactsName() {
    String[] projection = {
        ContactsContract.Contacts._ID,
        ContactsContract.Contacts.DISPLAY_NAME
    };

    Cursor cursor = getContentResolver().query(ContactsContract.Contacts.CONTENT_URI,
        projection,null,null,null);

    int nameIdx = cursor.getColumnIndexOrThrow(ContactsContract.Contacts.DISPLAY_NAME);
    int idIdx = cursor.getColumnIndexOrThrow(ContactsContract.Contacts._ID);

    StringBuilder result = new StringBuilder();
    while (cursor.moveToNext()){
      String name = cursor.getString(nameIdx);
      String id = cursor.getString(idIdx);
      result.append(name + " ("+ id + ")");
    }

    //Close the cursor
    cursor.close();

    resultTextView.setText(result.toString());
  }

  private void displayAllAudio() {
    String[] projection = new String[]{
        MediaStore.Audio.AudioColumns.ALBUM,
        MediaStore.Audio.AudioColumns.TITLE
    };

    Uri contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;

    Cursor cursor = getContentResolver().query(contentUri,projection,null,null,null);

    int albumIdx = cursor.getColumnIndexOrThrow(MediaStore.Audio.AudioColumns.ALBUM);
    int titleIdx = cursor.getColumnIndexOrThrow(MediaStore.Audio.AudioColumns.TITLE);

    StringBuilder result = new StringBuilder();
    while (cursor.moveToNext()){
      String title = cursor.getString(titleIdx);
      String album = cursor.getString(albumIdx);

      result.append(title + " ("+ album + ")");
    }

    //Close the cursor
    cursor.close();

    resultTextView.setText(result.toString());
  }

  @Override public boolean onCreateOptionsMenu(Menu menu) {
    // Inflate the menu; this adds items to the action bar if it is present.
    getMenuInflater().inflate(R.menu.menu_main, menu);
    return true;
  }

  @Override public boolean onOptionsItemSelected(MenuItem item) {
    // Handle action bar item clicks here. The action bar will
    // automatically handle clicks on the Home/Up button, so long
    // as you specify a parent activity in AndroidManifest.xml.
    int id = item.getItemId();

    //noinspection SimplifiableIfStatement
    if (id == R.id.action_settings) {
      return true;
    }

    return super.onOptionsItemSelected(item);
  }
}
