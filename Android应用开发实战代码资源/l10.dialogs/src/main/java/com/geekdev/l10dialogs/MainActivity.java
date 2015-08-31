package com.geekdev.l10dialogs;

import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.ActionBarActivity;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;


public class MainActivity extends ActionBarActivity implements com.geekdev.l10dialogs.MyQuestionDialogFragment.MyQuestionListener {

    private TextView actionTakenTextView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button button = (Button) findViewById(R.id.button);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                com.geekdev.l10dialogs.MyQuestionDialogFragment fragment = new com.geekdev.l10dialogs.MyQuestionDialogFragment();
                fragment.show(getSupportFragmentManager(), "question");
            }
        });
        actionTakenTextView = (TextView) findViewById(R.id.actionTaken);
    }

    @Override
    public void onDialogPositiveClick(DialogFragment dialog) {
        actionTakenTextView.setText("Celebrating!");
    }

    @Override
    public void onDialogNegativeClick(DialogFragment dialog) {
        actionTakenTextView.setText("Crying!");
    }

    /*
    public static class MyQuestionDialogFragment extends DialogFragment {
        @Override
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
            builder.setMessage("Are you smart?")
                    .setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // Celebrate
                        }
                    })
                    .setNegativeButton("No", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // Cry alone in a cold dark room
                        }
                    });
            return builder.create();
        }
    }
    */
}
