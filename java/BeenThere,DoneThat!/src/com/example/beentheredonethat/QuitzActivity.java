package com.example.beentheredonethat;

import android.app.Activity;
import android.os.Bundle;
public class QuitzActivity extends Activity {

	public static final String GAME_PREFERENCES = "GamePrefs";
	public static final String lastLaunch = "lastLaunch";
	public static final String GAME_PREFERENCES_NICKNAME= "Nickname"; // String
	public static final String GAME_PREFERENCES_EMAIL= "Email"; // String
	public static final String GAME_PREFERENCES_PASSWORD= "Password"; // String
	public static final String GAME_PREFERENCES_DOB= "DOB"; // Long
	public static final String GAME_PREFERENCES_GENDER= "Gender"; // Int
	public static final String TAG= "BTDT";

	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_quitz);
	}

}
