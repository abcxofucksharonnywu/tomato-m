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
package org.apache.cordova.scan;

import android.content.Intent;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

public class Scan extends CordovaPlugin {
    public static final String TAG = "Scan";
    public static final int REQ_CODE = 0x01;
    private CallbackContext callbackContext;

    /**
     * Constructor.
     */
    public Scan() {
    }

    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if ("recognize".equals(action)) {
            this.callbackContext = callbackContext;
            cordova.startActivityForResult(this, new Intent(cordova.getActivity(), ScanActivity.class), REQ_CODE);
        } else {
            return false;
        }
        return true;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        if (requestCode == REQ_CODE) {
            try {
                callbackContext.success(intent.getStringExtra("content"));
            } catch (Exception e) {
                callbackContext.error("識別出錯");
            }
        }


    }
}

