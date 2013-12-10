package com.example.beentheredonethat;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.text.format.DateFormat;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

public class QuitzSettingsActivity extends QuitzActivity {
	SharedPreferences mGameSettings;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_quitzsettings);
		Log.i(TAG, "In Settings activity, onCreate() callback method");

		SharedPreferences settings = getSharedPreferences(GAME_PREFERENCES,	MODE_PRIVATE);
		if (settings.contains("UserName") == true) {
			// We have a user name
			String user = settings.getString("UserName", "Default");
		}
		
		mGameSettings =	getSharedPreferences(GAME_PREFERENCES, Context.MODE_PRIVATE);
		Editor editor = mGameSettings.edit();

		final EditText nicknameText = (EditText) findViewById(R.id.editTextNickname);
		//String strNickname = nicknameText.getText().toString();
		if (mGameSettings.contains(GAME_PREFERENCES_NICKNAME)) {
			nicknameText.setText(mGameSettings.getString(GAME_PREFERENCES_NICKNAME, ""));
		}
		final EditText emailText = (EditText) findViewById(R.id.editTextEmail);
		//String strEmail = emailText.getText().toString();
		if (mGameSettings.contains(GAME_PREFERENCES_EMAIL)) {
			emailText.setText(mGameSettings.getString(GAME_PREFERENCES_EMAIL,""));
		}
		
		
		TextView passwordInfo = (TextView) findViewById(R.id.textViewPWD);
		if (mGameSettings.contains(GAME_PREFERENCES_PASSWORD)) {
			passwordInfo.setText(R.string.settings_pwd_set);
		} else {
			passwordInfo.setText(R.string.settings_pwd_not_set);
		}
		
		
		TextView dobInfo = (TextView) findViewById(R.id.BdayView);
		if (mGameSettings.contains(GAME_PREFERENCES_DOB)) {
			dobInfo.setText(DateFormat.format("MMMM dd, yyyy",
					mGameSettings.getLong(GAME_PREFERENCES_DOB, 0)));
		} else {
			dobInfo.setText(R.string.settings_dob_not_set);
		}
		//editor.putString(GAME_PREFERENCES_NICKNAME, strNickname);
		//editor.putString(GAME_PREFERENCES_EMAIL, strEmail);

		//editor.commit();
		initGenderSpinner();
		
		
	}
	protected void onPause() {
		super.onPause();
		
		EditText nicknameText = (EditText) findViewById(R.id.editTextNickname);
		EditText emailText = (EditText) findViewById(R.id.editTextEmail);

		String strNickname = nicknameText.getText().toString();
		String strEmail = emailText.getText().toString();
		
		Editor editor = mGameSettings.edit();
		editor.putString(GAME_PREFERENCES_NICKNAME, strNickname);
		editor.putString(GAME_PREFERENCES_EMAIL, strEmail);

		editor.commit();
	}
	@Override
	protected void onDestroy() {
		Log.d(TAG, "SHARED PREFERENCES");
		Log.d(TAG,
				"Nickname is: "
						+ mGameSettings.getString(GAME_PREFERENCES_NICKNAME,
								"Not set"));
		Log.d(TAG,
				"Email is: "
						+ mGameSettings.getString(GAME_PREFERENCES_EMAIL,
								"Not set"));
		Log.d(TAG,
				"Gender (M=1, F=2, U=0) is: "
						+ mGameSettings.getInt(GAME_PREFERENCES_GENDER, 0));
		// We are not saving the password yet
		Log.d(TAG,
				"Password is: "
						+ mGameSettings.getString(GAME_PREFERENCES_PASSWORD,
								"Not set"));
		// We are not saving the date of birth yet
		Log.d(TAG,
				"DOB is: "
						+ DateFormat.format("MMMM dd, yyyy",
								mGameSettings.getLong(GAME_PREFERENCES_DOB, 0)));
		super.onDestroy();
	}

	private void initGenderSpinner() {
		// Populate Spinner control with genders
		final Spinner spinner = (Spinner) findViewById(R.id.spinnerGenders);
		ArrayAdapter<?> adapter = ArrayAdapter.createFromResource(this,
				R.array.genders, android.R.layout.simple_spinner_item);
		adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		spinner.setAdapter(adapter);
		if (mGameSettings.contains(GAME_PREFERENCES_GENDER)) {
			spinner.setSelection(mGameSettings.getInt(GAME_PREFERENCES_GENDER,
					0));
		}
		// Handle spinner selections
		spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
			public void onItemSelected(AdapterView<?> parent,
					View itemSelected, int selectedItemPosition, long selectedId) {
				Editor editor = mGameSettings.edit();
				editor.putInt(GAME_PREFERENCES_GENDER, selectedItemPosition);
				editor.commit();
				Log.i(TAG, "In Settings onItemSelected()");
				Toast.makeText(QuitzSettingsActivity.this,
						"The selection has been saved!", Toast.LENGTH_LONG).show();
			}

			public void onNothingSelected(AdapterView<?> parent) {
			}
		});
	}
	public void onPickDateButtonClick(View view){
		Toast.makeText(QuitzSettingsActivity.this,
				"DO: Launch Password Dialog", Toast.LENGTH_LONG).show();
	}
	
	public void onSetPasswordButtonClick(View view){
		Toast.makeText(QuitzSettingsActivity.this,
				"TODO: Launch DatePickerDialog", Toast.LENGTH_LONG).show();
	}

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		/***
		 * onClick(R.id.editText1);
		 * 
		 * String u_name =get @+id/editText1 submit_Button =
		 * (Button)findViewById(R.id.button1); u_name =
		 * (EditText)findViewById(R.id.editText1);
		 * 
		 * mButton.setOnClickListener( new View.OnClickListener() { public void
		 * onClick(View view) { Log.v("EditText", mEdit.getText().toString()); }
		 * });
		 ***/
		
	}

}
