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

package com.abcxo.tomato;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;

import org.apache.cordova.CordovaActivity;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.firebase.Utils;
import org.json.JSONObject;

public class MainActivity extends CordovaActivity {
    public static final String TAG = "MainActivity";
    public static CordovaWebView webView;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Set by <content src="index.html" /> in config.xml
        loadUrl(launchUrl);
        webView = appView;
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                handlePush(getIntent());
            }
        }, 2000);
    }

    @Override
    protected void onResume() {
        super.onResume();
        Utils.registerToken();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        handlePush(intent);

    }

    private void handlePush(Intent intent) {
        try {
            if (intent.getExtras() != null) {
                JSONObject object = new JSONObject();
                object.put("title", "新消息");
                object.put("text", "新消息");
                object.put("type", intent.getExtras().getString("type"));
                object.put("content", intent.getExtras().getString("content"));
                Utils.handlePush(object.toString(), false);
            }
        } catch (Exception e) {

        }
    }
}
