package com.research.shaderfilter;

import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.view.Menu;
import android.view.MenuItem;
import android.view.Window;

public class MainActivity extends Activity {

	GLSurfaceView mView;
	private MenuItem			mItemCapture0;
	private MenuItem			mItemCapture1;
	private MenuItem			mItemCapture2;
	private MenuItem			mItemCapture3;
	private MenuItem			mItemCapture4;
	private MenuItem			mItemCapture5;
	private MenuItem			mItemCapture6;
	private MenuItem			mItemCapture7;
	private MenuItem			mItemCapture8;
	private MenuItem			mItemCapture9;
	private MenuItem			mItemCapture10;
	private MenuItem			mItemCapture11;
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);   
        requestWindowFeature(Window.FEATURE_NO_TITLE);
       
        mView = new GLSurfaceView(this);
        mView.setEGLContextClientVersion(2);
        mView.setRenderer(new GLLayer(this));
        
        setContentView(mView);
    }

    /** Called when the activity is first created. */
    @Override
    public void onResume() {
        super.onResume();
        mView.onResume();
       
    }
    protected void onPause() {
    	super.onPause(); 
    	mView.onPause();
    }
    
    /**menu button setup*/
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
    	mItemCapture0 = menu.add("Original");
    	mItemCapture1 = menu.add("Warm");
    	mItemCapture2= menu.add("Van Gogh");
    	mItemCapture3 = menu.add("Monet");
    	mItemCapture4 = menu.add("Pop");
    	mItemCapture5 = menu.add("Manga");
    	mItemCapture6 = menu.add("Blur");
        return true;
       
    }
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
    	if (item == mItemCapture0){		
    		GLLayer.shader_selection = 0;
    		return true;
    	}
    	if (item == mItemCapture1){		
    		GLLayer.shader_selection = GLLayer.WARM;
    		return true;
    	}
    	if	(item == mItemCapture2){
    		GLLayer.shader_selection = GLLayer.VAN_GOGH;
    		return true;
    	}
    	if	(item == mItemCapture3){
    		GLLayer.shader_selection = GLLayer.MONET;
    		return true;
    	}
    	if  (item == mItemCapture4){
    		GLLayer.shader_selection = GLLayer.POP;
    		return true;
    	}
    	if (item == mItemCapture5){		
    		GLLayer.shader_selection = GLLayer.MANGA;
    		return true;
    	}
    	if	(item == mItemCapture6){
    		GLLayer.shader_selection = GLLayer.BLUR;  		
    		return true;
    	}
    	
    	return false;
    }

}
