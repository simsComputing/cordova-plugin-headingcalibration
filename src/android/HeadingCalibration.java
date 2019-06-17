package com.simscomputing.cordova.headingcalibration;

import org.json.JSONArray;
import org.json.JSONException;
import org.apache.cordova.*;

import android.content.Context;
import android.hardware.*;

public class HeadingCalibration extends CordovaPlugin implements SensorEventListener
{
    protected CallbackContext callbackContext = null;
    protected SensorManager sensorManager;
    protected Sensor magnetometer;
    protected int accuracy;
    protected boolean runs;

    public HeadingCalibration()
    {
        this.accuracy = -1;
        this.callbackContext = null;
    }

    public void initialize(CordovaInterface cordova, CordovaWebView webView)
    {
        super.initialize(cordova, webView);
        this.sensorManager = (SensorManager)cordova.getActivity().getSystemService(Context.SENSOR_SERVICE);
        this.magnetometer = this.sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);

    }

    public boolean execute(
        String action,
        JSONArray args,
        CallbackContext callbackContext
    ) throws JSONException {
        if (action.equals("watchCalibration")) {
            if (this.callbackContext != null) {
                this.stop();
            }
            this.callbackContext = callbackContext;
            this.sensorManager.registerListener(this, this.magnetometer, SensorManager.SENSOR_DELAY_NORMAL);
        } else if (action.equals("stopWatchCalibration")) {
            if (this.callbackContext != null) {
                this.stop();
                this.callbackContext = null;
                callbackContext.success();
            } else {
                callbackContext.error("Heading calibration was not being watched");
            }
        }

        return true;
    }

    public void stop()
    {
        this.sensorManager.unregisterListener(this);
    }

    public void onDestroy()
    {
        this.stop();
    }

    public void onAccuracyChanged(Sensor sensor, int accuracy)
    {
        if (this.callbackContext != null) {
            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, accuracy);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        }
    }

    public void onSensorChanged(SensorEvent sensorEvent)
    {
        // DO NOTHING
    }
}
