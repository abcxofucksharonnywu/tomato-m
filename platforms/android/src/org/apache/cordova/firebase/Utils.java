package org.apache.cordova.firebase;

import android.text.TextUtils;
import android.util.Log;

import com.abcxo.tomato.MainActivity;
import com.google.firebase.iid.FirebaseInstanceId;

/**
 * Created by SHARON on 16/7/26.
 */

public class Utils {
    public static final String TAG = "Utils";

    public static void registerToken() {
        String refreshedToken = FirebaseInstanceId.getInstance().getToken();
        if (!TextUtils.isEmpty(refreshedToken)) {
            MainActivity.webView.sendJavascript("userTokenInit('" + refreshedToken + "')");
        }
    }

    public static void handlePush(String str, boolean isShow) {
        Log.v(TAG, str);
        MainActivity.webView.sendJavascript("notification(" + str + "," + (isShow ? "true" : "false") + ")");
    }


}

