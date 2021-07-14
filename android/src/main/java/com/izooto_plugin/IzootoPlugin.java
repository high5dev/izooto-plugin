package com.izooto_plugin;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.google.gson.Gson;
import com.izooto.NotificationHelperListener;
import com.izooto.NotificationReceiveHybridListener;
import com.izooto.NotificationWebViewListener;
import com.izooto.Payload;
import com.izooto.TokenReceivedListener;
import com.izooto.iZooto;

import org.json.JSONArray;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class IzootoPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler
{
    @SuppressLint("StaticFieldLeak")
    static Context context;
    MethodChannel channel;
    private String notificationOpenedData, notificationToken, notificationWebView,notificationPayload;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), iZootoConstant.iZOOTO_PLUGIN_NAME); //define the chanel name
        channel.setMethodCallHandler(this);
    }
    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
// Handle the all methods
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        iZootoNotificationListener iZootoNotificationListener = new iZootoNotificationListener();
        switch (call.method) {
            case iZootoConstant.AndroidINITIASE:
                iZooto.isHybrid=true;
                iZooto.initialize(context)
                        .setTokenReceivedListener(iZootoNotificationListener)
                        .setNotificationReceiveListener(iZootoNotificationListener)
                        .setLandingURLListener(iZootoNotificationListener)
                        .setNotificationReceiveHybridListener(iZootoNotificationListener)
                        .build();
                break;
            case iZootoConstant.SETSUBSCRIPTION:
                try {
                    boolean setSubscription = (boolean) call.arguments;
                    iZooto.setSubscription(setSubscription);
                }catch (Exception ex)
                {
                    Log.v("Handle",ex.toString());
                }
                break;
            case iZootoConstant.FIREBASEANLYTICS:
                    boolean trackFirebaseAnalytics = (boolean) call.arguments;
                    iZooto.setFirebaseAnalytics(trackFirebaseAnalytics);
                break;
            case iZootoConstant.ADDEVENTS:
                    String eventName = call.argument(iZootoConstant.EVENT_NAME);
                    HashMap<String, Object> hashMapEvent = new HashMap<>();
                    hashMapEvent = (HashMap<String, Object>) call.argument(iZootoConstant.EVENT_VALUE);
                    iZooto.addEvent(eventName, hashMapEvent);
                break;
            case iZootoConstant.ADDPROPERTIES:

                HashMap<String, Object> hashMapUserProperty = new HashMap<>();
                hashMapUserProperty = (HashMap<String, Object>) call.arguments;
                iZooto.addUserProperty(hashMapUserProperty);
                break;
            case iZootoConstant.Notification_SOUND:
                try {
                    String soundName = (String) call.arguments;
                    iZooto.setNotificationSound(soundName);
                    Log.e("SoundName",soundName);
                }catch (Exception ex)
                {
                    Log.v("Handle",ex.toString());
                }
                break;
            case iZootoConstant.ADDTAGS: {
                List<String> addTagList = new ArrayList<>();
                addTagList = (List<String>) call.arguments;
                iZooto.addTag(addTagList);
                break;
            }
            case iZootoConstant.REMOVETAG: {
                List<String> addTagList = new ArrayList<>();
                addTagList = (List<String>) call.arguments;
                iZooto.removeTag(addTagList);
                break;
            }
            case iZootoConstant.iZOOTO_HANDLE_NOTIFICATION:
                Object handleNotification = (Object) call.argument(iZootoConstant.iZOOTO_HANDLE_NOTIFICATION);
                Map<String, String> map = (Map<String, String>) handleNotification;
                iZooto.iZootoHandleNotification(context, map);
                break;
            case iZootoConstant.iZOOTO_IN_APP_BEHAVIOUR:
                int notificationBehaviour = call.argument(iZootoConstant.iZOOTO_IN_APP_BEHAVIOUR);
                setNotificationBehaviour(notificationBehaviour);
                break;
            case iZootoConstant.iZOOTO_RECEIVED_PAYLOAD:
                iZootoNotificationListener.onNotificationReceivedHybrid(notificationPayload);
                iZooto.notificationReceivedCallback(iZootoNotificationListener);
                break;
            case iZootoConstant.iZOOTO_OPEN_NOTIFICATION:
                iZootoNotificationListener.onNotificationOpened(notificationOpenedData);
                iZooto.notificationClick(iZootoNotificationListener);
                break;
            case iZootoConstant.iZOOTO_DEVICE_TOKEN:
                iZootoNotificationListener.onTokenReceived(notificationToken);
                break;
            case iZootoConstant.iZOOOTO_HANDLE_WEBVIEW:
                iZootoNotificationListener.onWebView(notificationWebView);
                iZooto.notificationWebView(iZootoNotificationListener);
                break;
            default:
                 result.notImplemented();
                break;
        }
    }

    private class iZootoNotificationListener implements TokenReceivedListener, NotificationHelperListener, NotificationWebViewListener ,NotificationReceiveHybridListener{
        @Override
        public void onNotificationReceived(Payload payload) {
//            notificationPayload = payload;
//
//            if (payload!=null) {
//                Gson gson = new Gson();
//                String jsonPayload = gson.toJson(payload);
//                try {
//                    invokeMethodOnUiThread(iZootoConstant.iZOOTO_RECEIVED_PAYLOAD, jsonPayload);
//                } catch (Exception e) {
//                    e.getStackTrace();
//                }
//            }

        }

        @Override
        public void onNotificationOpened(String data) {
            notificationOpenedData = data;
            if (data!=null) {
                try {
                    invokeMethodOnUiThread(iZootoConstant.iZOOTO_OPEN_NOTIFICATION, data);
                } catch (Exception e) {
                    e.getStackTrace();
                }
            }
        }

        @Override
        public void onTokenReceived(String token) {
            notificationToken = token;
            if (token!=null) {
                try {
                    invokeMethodOnUiThread(iZootoConstant.iZOOTO_DEVICE_TOKEN, token);
                } catch (Exception e) {
                    e.getStackTrace();
                }
            }
        }

        @Override
        public void onWebView(String landingUrl) {
            notificationWebView = landingUrl;
            if (landingUrl!=null) {
                try {
                    invokeMethodOnUiThread(iZootoConstant.iZOOOTO_HANDLE_WEBVIEW, landingUrl);
                } catch (Exception e) {
                    e.getStackTrace();
                }
            }
        }

        @Override
        public void onNotificationReceivedHybrid(String receiveData) {
            notificationPayload = receiveData;
            if (receiveData!=null) {
                try {
                    JSONArray listArray = new JSONArray(receiveData);
                    JSONArray reverseList = new JSONArray();
                    for (int i = listArray.length()-1; i>=0; i--) {
                        reverseList.put(listArray.getJSONObject(i));
                    }
                    invokeMethodOnUiThread(iZootoConstant.iZOOTO_RECEIVED_PAYLOAD, reverseList.toString());
                } catch (Exception e) {
                    e.getStackTrace();
                }
            }

        }
    }

    private void runOnMainThread(final Runnable runnable) {
        if (Looper.getMainLooper().getThread() == Thread.currentThread())
            runnable.run();
        else {
            Handler handler = new Handler(Looper.getMainLooper());
            handler.post(runnable);
        }
    }

    void invokeMethodOnUiThread(final String methodName, final String map) {
        final MethodChannel channel = this.channel;
        runOnMainThread(new Runnable() {
            @Override
            public void run() {
                channel.invokeMethod(methodName ,map);
            }
        });
    }

    private static void setNotificationBehaviour(int index){
        if (index == 0)
            iZooto.setInAppNotificationBehaviour(iZooto.OSInAppDisplayOption.None);
        else if (index == 1)
            iZooto.setInAppNotificationBehaviour(iZooto.OSInAppDisplayOption.InAppAlert);
        else
            iZooto.setInAppNotificationBehaviour(iZooto.OSInAppDisplayOption.Notification);
    }
}
