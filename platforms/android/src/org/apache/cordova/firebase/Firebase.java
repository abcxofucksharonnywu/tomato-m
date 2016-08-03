/*
       Licensed to the Apache Software Foundation (ASF) under one
       or more contributor license agreements.  See the NOTICE file
       distributed with this work for additional information
       regarding copyright ownership.  The ASF licenses this file
       to you under the Apache License, Version 2.0 (the
       "License"); you may not use this file except in compliance
       with the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing,
       software distributed under the License is distributed on an
       "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
       KIND, either express or implied.  See the License for the
       specific language governing permissions and limitations
       under the License.
*/
package org.apache.cordova.firebase;

import android.os.Bundle;
import android.util.Log;

import com.google.firebase.analytics.FirebaseAnalytics;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

public class Firebase extends CordovaPlugin {
    public static final String TAG = "Firebase";

    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if ("log".equals(action)) {
            String logName = args.optString(0);
            JSONObject obj = args.optJSONObject(1);
            Iterator keys = obj.keys();
            Bundle params = new Bundle();
            while (keys.hasNext()) {
                String key = (String) keys.next();
                params.putString(key, obj.optString(key));
            }
            Log.v("log-" + logName, params.toString());
            FirebaseAnalytics.getInstance(cordova.getActivity()).logEvent(logName, params);
            callbackContext.success();
        } else {
            return false;
        }
        return true;
    }
}
