package org.apache.cordova.firebase;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import org.json.JSONObject;

/**
 * Created by SHARON on 16/7/26.
 */

public class MessagingService extends FirebaseMessagingService {
    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);
        try {
            String title = remoteMessage.getNotification().getTitle();
            String text = remoteMessage.getNotification().getBody();
            String type = remoteMessage.getData().get("type");
            String content = remoteMessage.getData().get("content");
            JSONObject object = new JSONObject();
            object.put("title", title);
            object.put("text", text);
            object.put("type", type);
            object.put("content", content);
            Utils.handlePush(object.toString(), true);
        } catch (Exception e) {

        }

    }

}
