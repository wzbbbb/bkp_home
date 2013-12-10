package com.example.beentheredonethat;

import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

public class QuitzMenuActivity extends QuitzActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_quitzmenu);
		//getStringArray(R.array.stringarray);
		RelativeLayout re_layout = (RelativeLayout) findViewById(R.id.relativeLayoutOut);
		Animation fade2 = AnimationUtils.loadAnimation(this, R.anim.fade_in2);
		re_layout.startAnimation(fade2);

		ListView menuList = (ListView) findViewById(R.id.listView1);
		String[] items = { getResources().getString(R.string.but_play),
				getResources().getString(R.string.scores),
				getResources().getString(R.string.settings),
				getResources().getString(R.string.help) };
		ArrayAdapter<String> adapt = new ArrayAdapter<String>(this,
				R.layout.menu_item, items);
		menuList.setAdapter(adapt);
		menuList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View itemClicked,
					int position, long id) {
				TextView textView = (TextView) itemClicked;
				String strText = textView.getText().toString();
				if (strText.equalsIgnoreCase(getResources().getString(
						R.string.but_play))) {
					// Launch the Game Activity
					startActivity(new Intent(QuitzMenuActivity.this,
							QuitzPlayActivity.class));
				} else if (strText.equalsIgnoreCase(getResources().getString(
						R.string.help))) {
					// Launch the Help Activity
					startActivity(new Intent(QuitzMenuActivity.this,
							QuitzHelpActivity.class));
				} else if (strText.equalsIgnoreCase(getResources().getString(
						R.string.settings))) {
					// Launch the Settings Activity
					startActivity(new Intent(QuitzMenuActivity.this,
							QuitzSettingsActivity.class));
				} else if (strText.equalsIgnoreCase(getResources().getString(
						R.string.scores))) {
					// Launch the Scores Activity
					startActivity(new Intent(QuitzMenuActivity.this,
							QuitzScoresActivity.class));
				}
			}
		});

		// @Override
		// public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,long
		// arg3) {
		// TODO Auto-generated method stub

		// });
	}
	
	protected void onPause() {
		// Stop the animation
		super.onPause();
		RelativeLayout re_layout = (RelativeLayout) findViewById(R.id.relativeLayoutOut);

		re_layout.clearAnimation();
		
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
