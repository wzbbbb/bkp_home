package com.example.beentheredonethat;

import java.text.SimpleDateFormat;
import java.util.Date;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationUtils;
import android.view.animation.LayoutAnimationController;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

public class QuitZSplashActivity extends QuitzActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_quitzsplash);
		//Log.i(TAG, "In Splash activity, onCreate() callback method");
		SharedPreferences lastPref = getSharedPreferences(lastLaunch,
				MODE_PRIVATE);
		if (lastPref.contains("lastRunTime") == true) {
			// We have a user name
			String lastTime = lastPref.getString("lastRunTime", "Default");
			Log.i(TAG, "In Splash activity, lastTime " + lastTime);
			final TextView t = (TextView) findViewById(R.id.textView3);
			t.setText(lastTime);

			// TextView t = (TextView)findViewById(R.id.textView3);
			// t.setText(lastTime);
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
		String currentDateandTime = sdf.format(new Date());
		SharedPreferences.Editor prefEditor = lastPref.edit();
		prefEditor.putString("lastRunTime", currentDateandTime);
		prefEditor.commit();
		// Log.i(TAG, "In Splash activity, currentDateandTime " +
		// currentDateandTime);
		String lastTime = lastPref.getString("lastRunTime", "Default");
		// Log.i(TAG, "In Splash activity, lastTime , the current launch" +
		// lastTime);
		// control animation
		TextView logo1 = (TextView) findViewById(R.id.textViewTopTitle);
		Animation fade1 = AnimationUtils.loadAnimation(this, R.anim.fade_in);
		logo1.startAnimation(fade1);
		TextView logo2 = (TextView) findViewById(R.id.textHelpTitle);
		Animation fade2 = AnimationUtils.loadAnimation(this, R.anim.fade_in2);
		//Log.i(TAG, "In Splash, logo2 " + logo2);
		//Log.i(TAG, "In Splash, fade2 " + fade2);
		logo2.startAnimation(fade2);

		Animation spinin = AnimationUtils.loadAnimation(this,R.anim.custom_anim);
		LayoutAnimationController controller = new LayoutAnimationController(spinin);
		TableLayout table = (TableLayout) findViewById(R.id.TableLayout01);
		for (int i = 0; i < table.getChildCount(); i++) {
			TableRow row = (TableRow) table.getChildAt(i);
			row.setLayoutAnimation(controller);
		}

		// Animation fade2 = AnimationUtils.loadAnimation(this,
		// R.anim.fade_in2);
		fade2.setAnimationListener(new AnimationListener() {
			public void onAnimationEnd(Animation animation) {
				startActivity(new Intent(QuitZSplashActivity.this,
						QuitzMenuActivity.class));
				QuitZSplashActivity.this.finish();
			}

			@Override
			public void onAnimationRepeat(Animation arg0) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onAnimationStart(Animation arg0) {
				// TODO Auto-generated method stub

			}
		});
	}

	@Override
	protected void onPause() {
		// Stop the animation
		super.onPause();
		TextView logo1 = (TextView) findViewById(R.id.textViewTopTitle);
		logo1.clearAnimation();
		TextView logo2 = (TextView) findViewById(R.id.textHelpTitle);
		logo2.clearAnimation();
		TableLayout table = (TableLayout) findViewById(R.id.TableLayout01);
		for (int i = 0; i < table.getChildCount(); i++) {
			TableRow row = (TableRow) table.getChildAt(i);
			row.clearAnimation();
		}
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
