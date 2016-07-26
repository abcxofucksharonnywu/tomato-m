package org.apache.cordova.firebase;

import android.util.Log;

import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.FirebaseInstanceIdService;

/**
 * Created by SHARON on 16/7/26.
 */

public class InstanceIDService extends FirebaseInstanceIdService {
    public static final String TAG = "InstanceIDService";

    @Override
    public void onTokenRefresh() {
        super.onTokenRefresh();
        String token = FirebaseInstanceId.getInstance().getToken();
        Log.v(TAG, token);
        Utils.registerToken();
    }
}
