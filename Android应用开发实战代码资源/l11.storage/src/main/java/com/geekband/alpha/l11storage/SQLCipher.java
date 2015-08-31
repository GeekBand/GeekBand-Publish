package com.geekband.alpha.l11storage;

import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;

import net.sqlcipher.database.SQLiteDatabase;

import java.io.File;

public class SQLCipher extends ActionBarActivity {

  @Override protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_sqlcipher);
    InitializeSQLCipher();
  }

  private void InitializeSQLCipher() {
    SQLiteDatabase.loadLibs(this);
    File databaseFile = getDatabasePath("demo.db");
    databaseFile.mkdirs();
    databaseFile.delete();
    SQLiteDatabase database = SQLiteDatabase.openOrCreateDatabase(databaseFile, "test123", null);
    database.execSQL("create table t1(a, b)");
    database.execSQL("insert into t1(a, b) values(?, ?)", new Object[] {
        "one for the money", "two for the show"
    });
  }

  @Override public boolean onCreateOptionsMenu(Menu menu) {
    // Inflate the menu; this adds items to the action bar if it is present.
    getMenuInflater().inflate(R.menu.menu_sqlcipher, menu);
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
