package com.geekband.alpha.l11storage;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class ZooDbHelper extends SQLiteOpenHelper {

    public static final String ID_COLUMN = "_id";
    public static final String NAME_COLUMN = "name";
    public static final String DESCRIPTION_COLUMN = "description";
    public static final String FILE_PATH_COLUMN = "filepath";

    public static final String DATABASE_TABLE = "Zoo";
    public static final int DATABASE_VERSION = 1;
    private static final String DATABASE_CREATE = String.format(
            "CREATE TABLE %s (" +
                    "  %s integer primary key autoincrement, " +
                    "  %s text," +
                    "  %s text," +
                    "  %s text)",
            DATABASE_TABLE, ID_COLUMN, NAME_COLUMN, DESCRIPTION_COLUMN, FILE_PATH_COLUMN);

    public ZooDbHelper(Context context) {
        super(context, DATABASE_TABLE, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(DATABASE_CREATE);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL("DROP TABLE IF EXISTS " + DATABASE_TABLE);
        onCreate(db);
    }
}

