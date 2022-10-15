package com.example.document_viewer_m_app;

import camp.visual.gazetracker.callback.GazeTrackerCallback;
import camp.visual.gazetracker.constant.UserStatusOption;
import camp.visual.gazetracker.gaze.GazeInfo;
import camp.visual.gazetracker.state.ScreenState;
import io.flutter.embedding.android.FlutterActivity;
import android.os.Bundle;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

// SeeSo Imports
import camp.visual.gazetracker.GazeTracker;
import camp.visual.gazetracker.callback.GazeCallback;
import camp.visual.gazetracker.callback.InitializationCallback;
import camp.visual.gazetracker.constant.InitializationErrorType;
import camp.visual.gazetracker.filter.OneEuroFilterManager;
import camp.visual.gazetracker.device.CameraPosition;
import io.flutter.plugins.GeneratedPluginRegistrant;

// Android Imports
import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.content.ContextCompat;

public class MainActivity extends FlutterActivity {
    private static final String mChannel = "gazeTracker";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FlutterEngine flutterEngine = new FlutterEngine(this);
        GeneratedPluginRegistrant.registerWith(flutterEngine);;
    }
    private String leftPageEvent = "com.example.document_viewer_m_app/leftPageEvent";
    private String rightPageEvent = "com.example.document_viewer_m_app/rightPageEvent";

    GazeTracker gazeTracker = null;

    private void initGaze(){
        String licenseKey = BuildConfig.GAZETRACKER_KEY;

        UserStatusOption userStatusOption = new UserStatusOption();
        if (!userStatusOption.isUseAttention()) {
            userStatusOption.useAttention();
        }
        GazeTracker.initGazeTracker(getApplicationContext(), licenseKey, initializationCallback, userStatusOption);
    }

    private final InitializationCallback initializationCallback = new InitializationCallback() {
        @Override
        public void onInitialized(GazeTracker gazeTracker, InitializationErrorType error) {
            if (gazeTracker != null) {
                initSuccess(gazeTracker);
            } else {
                initFail(error);
            }
        }
    };

    private void initSuccess(GazeTracker gazeTracker) {
        Log.i("Debug", "Succese init gazeTracker!");
        this.gazeTracker = gazeTracker;
        this.gazeTracker.setGazeCallback(gazeCallback);
        this.gazeTracker.startTracking();
    }

    private final OneEuroFilterManager oneEuroFilterManager = new OneEuroFilterManager(2);

    private final GazeCallback gazeCallback = new GazeCallback() {
        @Override
        public void onGaze(GazeInfo gazeInfo) {
            if (gazeInfo.screenState == ScreenState.INSIDE_OF_SCREEN)
                Log.i("Eye coordinary", "x[" + gazeInfo.x + " ] y[" + gazeInfo.y+ "]");
        }
//        @Override
//        public void onGaze(GazeInfo gazeInfo) {
//            Log.i("SeeSo", "gaze coord " + gazeInfo.x + "x" + gazeInfo.y);
//            if (oneEuroFilterManager.filterValues(gazeInfo.timestamp, gazeInfo.x, gazeInfo.y)) {
//                float[] filteredValues = oneEuroFilterManager.getFilteredValues();
//                float filteredX = filteredValues[0];
//                float filteredY = filteredValues[1];
//                Log.i("SeeSo", "gaze filterd coord " + filteredX + "x" + filteredY);
//            }
//        }
    };

    private void initFail(InitializationErrorType error) {
        String err = "";
        if (error == InitializationErrorType.ERROR_INIT) {
            // When initialization is failed
            err = "Initialization failed";
        } else if (error == InitializationErrorType.ERROR_CAMERA_PERMISSION) {
            // When camera permission doesn not exists
            err = "Required permission not granted";
        }
    else  {
            // Gaze library initialization failure
            // It can ba caused by several reasons(i.e. Out of memory).
            err = "init gaze library fail";
        }
        Log.w("SeeSo", "error description: " + err);
    }

    private void stopTracking() {
        gazeTracker.stopTracking();
    }

    private void releaseGaze() {
        GazeTracker.deinitGazeTracker(this.gazeTracker);
        this.gazeTracker = null;
    }
    private static final String[] PERMISSIONS = new String[]
                {Manifest.permission.CAMERA};
    private static final int REQ_PERMISSION = 1000;

    private void checkPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            // Check permission status
            if (!hasPermissions(PERMISSIONS)) {

                requestPermissions(PERMISSIONS, REQ_PERMISSION);
            } else {
                checkPermission(true);
            }
        }else{
            checkPermission(true);
        }
    }

        @RequiresApi(Build.VERSION_CODES.M)
        private boolean hasPermissions(String[] permissions) {
            int result;
            // Check permission status in string array
            for (String perms : permissions) {
                if (perms.equals(Manifest.permission.SYSTEM_ALERT_WINDOW)) {
                    if (!Settings.canDrawOverlays(this)) {
                        return false;
                    }
                }
                result = ContextCompat.checkSelfPermission(this, perms);
                if (result == PackageManager.PERMISSION_DENIED) {
                    // When if unauthorized permission found
                    return false;
                }
            }

            // When if all permission allowed
            return true;
        }

        private void checkPermission(boolean isGranted) {
            if (isGranted) {
                permissionGranted();
            } else {
                finish();
            }
        }

        @Override
        public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults);
            switch (requestCode) {
                case REQ_PERMISSION:
                    if (grantResults.length > 0) {
                        boolean cameraPermissionAccepted = grantResults[0] == PackageManager.PERMISSION_GRANTED;
                        if (cameraPermissionAccepted) {
                            checkPermission(true);
                        } else {
                            checkPermission(false);
                        }
                    }
                    break;
            }
        }

        private void permissionGranted() {
            initGaze();
        }
}
