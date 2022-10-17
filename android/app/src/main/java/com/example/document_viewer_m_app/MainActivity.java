package com.example.document_viewer_m_app;

import camp.visual.gazetracker.callback.GazeTrackerCallback;
import camp.visual.gazetracker.constant.UserStatusOption;
import camp.visual.gazetracker.gaze.GazeInfo;
import camp.visual.gazetracker.state.ScreenState;
import camp.visual.libgaze.calibration.CalibrationHelper;
import camp.visual.libgaze.camera.DeviceMeta;
import io.flutter.embedding.android.FlutterActivity;

import android.app.Activity;
import android.graphics.Point;
import android.hardware.camera2.params.MeteringRectangle;
import android.os.Bundle;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import java.util.Map;
import java.util.Objects;

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
import android.view.Display;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.content.ContextCompat;

public class MainActivity extends FlutterActivity {
    // Method Channel===========================================================
    private static final String mChannel = "com.example.document_viewer_m_app/gazeTracker";
    private MethodChannel channel;
    protected float[] mEyeCoordinary = {0, 0};

    public float[] getEyeCoordinary() { return mEyeCoordinary; }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        super.configureFlutterEngine(flutterEngine);

        channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), mChannel);
        channel.setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("initGaze")) {
                        initGaze();
                    }
                    else if (call.method.equals("releaseGaze")) {
                        releaseGaze();
                    }
                    else if (call.method.equals("getEyeCoordinary")) {
                        result.success(getEyeCoordinary());
                    }
                    else {
                        result.notImplemented();
                    }
                }
        );
    }
    // Method Channel^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
        this.gazeTracker = gazeTracker;
        this.gazeTracker.setGazeCallback(gazeCallback);
        this.gazeTracker.startTracking();
    }

    private final OneEuroFilterManager oneEuroFilterManager = new OneEuroFilterManager(2);

    private final GazeCallback gazeCallback = new GazeCallback() {

        @Override
        public void onGaze(GazeInfo gazeInfo) {
            System.out.println(gazeInfo.getClass().getName());
            System.out.println(gazeInfo == null);
            System.out.println(gazeInfo.screenState);
            if (gazeInfo.screenState == ScreenState.INSIDE_OF_SCREEN){
                Log.i("Eye coordinary", "x[" + gazeInfo.x + " ] y[" + gazeInfo.y+ "]");
                mEyeCoordinary[0] = gazeInfo.x;
                mEyeCoordinary[1] = gazeInfo.y;
                Log.d("GazeCallback", "Success mEyeCoordinary");
            }
        }
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
