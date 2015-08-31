package com.geekband.alpha.l11storage;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;


public class SqlActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sql);
        insert();
      update();
    }

    private void update() {
        SQLiteDatabase db = new ZooDbHelper(this).getWritableDatabase();
        String whereClause = ZooDbHelper.ID_COLUMN + "= ?";
        String[] whereArgs = {"1"};

        ContentValues newValues = new ContentValues();
        newValues.put(ZooDbHelper.NAME_COLUMN, "alpaca");
        newValues.put(ZooDbHelper.DESCRIPTION_COLUMN, "An alpaca is ugly.");
        newValues.put(ZooDbHelper.FILE_PATH_COLUMN, "/storage/alpaca.png");

        db.update(ZooDbHelper.DATABASE_TABLE, newValues, whereClause, whereArgs);
    }

    private void delete() {
        SQLiteDatabase db = new ZooDbHelper(this).getWritableDatabase();
        String whereClause = ZooDbHelper.ID_COLUMN + "=?";
        String[] whereArgs = {"2"};
        db.delete(ZooDbHelper.DATABASE_TABLE, whereClause, whereArgs);
    }

    private void query() {
        SQLiteDatabase db = new ZooDbHelper(this).getWritableDatabase();
        String where = null;
        String whereArgs[] = null;
        String groupBy = null;
        String having = null;
        String order = null;
        String[] resultColumns = {ZooDbHelper.ID_COLUMN, ZooDbHelper.NAME_COLUMN, ZooDbHelper.DESCRIPTION_COLUMN, ZooDbHelper.FILE_PATH_COLUMN};
        Cursor cursor = db.query(ZooDbHelper.DATABASE_TABLE, resultColumns, where, whereArgs, groupBy, having, order);
        while (cursor.moveToNext()) {
            int id = cursor.getInt(0);
            String name = cursor.getString(1);
            String description = cursor.getString(2);
            String filepath = cursor.getString(3);
            Log.d("ZOO", String.format("%s,%s,%s,%s", id, name, description, filepath));
        }
    }

    private void insert() {
        SQLiteDatabase db = new ZooDbHelper(this).getWritableDatabase();
        ContentValues newValues = new ContentValues();
        newValues.put(ZooDbHelper.NAME_COLUMN, "narwhal");
        newValues.put(ZooDbHelper.DESCRIPTION_COLUMN, "cool pet.");
        newValues.put(ZooDbHelper.FILE_PATH_COLUMN, "/storage/narwhal.png");
        db.insert(ZooDbHelper.DATABASE_TABLE, null, newValues);
    }
}
