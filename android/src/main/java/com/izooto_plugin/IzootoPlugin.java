package com.izooto_plugin;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.google.gson.Gson;
import com.izooto.NotificationHelperListener;
import com.izooto.NotificationReceiveHybridListener;
import com.izooto.NotificationWebViewListener;
import com.izooto.Payload;
import com.izooto.PushTemplate;
import com.izooto.TokenReceivedListener;
import com.izooto.iZooto;
import com.xiaomi.mipush.sdk.help.HelpService;

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

@SuppressWarnings("IzootoPlugin")
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
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
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
                iZooto.setPluginVersion(iZootoConstant.Plugin_Version);
                break;
            case iZootoConstant.SETSUBSCRIPTION:
                try {
                    boolean setSubscription = (boolean) call.arguments;
                    iZooto.setSubscription(setSubscription);
                }catch (Exception ex)
                {
                    Log.v(iZootoConstant.PLUGIN_EXCEPTION,ex.toString());
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
                }catch (Exception ex)
                {
                    Log.v(iZootoConstant.PLUGIN_EXCEPTION,ex.toString());
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
            case iZootoConstant.IZOOTO_DEFAULT_TEMPLATE:
                int notificationTemplate = call.argument(iZootoConstant.IZOOTO_DEFAULT_TEMPLATE);
                setCustomNotification(notificationTemplate);
                break;
            case iZootoConstant.IZOOTO_DEFAULT_NOTIFICATION_BANNER:
                String notificationTemplateBanner = call.argument(iZootoConstant.IZOOTO_DEFAULT_NOTIFICATION_BANNER);
                if (getBadgeIcon(context, notificationTemplateBanner) != 0)
                    iZooto.setDefaultNotificationBanner(getBadgeIcon(context, notificationTemplateBanner));
                break;
            case iZootoConstant.iZOOTO_HANDLE_NOTIFICATION:
                Object handleNotification = (Object) call.argument(iZootoConstant.iZOOTO_HANDLE_NOTIFICATION);
                Map<String, String> map = (Map<String, String>) handleNotification;
                iZooto.iZootoHandleNotification(context, map);
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
                try {
                    iZootoNotificationListener.onWebView(notificationWebView);
                    iZooto.notificationWebView(iZootoNotificationListener);
                }catch (Exception ex)
                {
                    Log.v(iZootoConstant.PLUGIN_EXCEPTION,ex.toString());

                }
                break;
            case iZootoConstant.NOTIFICATION_PERMISSION:
                try {
                    if (Build.VERSION.SDK_INT>=33){
                        iZooto.promptForPushNotifications();
                    }else {
                        Log.e(iZootoConstant.NOTIFICATION_PERMISSION,"Api level is lower than 33");
                    }
                }catch (Exception ex)
                {
                    Log.v(iZootoConstant.PLUGIN_EXCEPTION,ex.toString());

                }
                break;
            default:
                 result.notImplemented();
                break;
        }
    }

    private class iZootoNotificationListener implements TokenReceivedListener, NotificationHelperListener, NotificationWebViewListener ,NotificationReceiveHybridListener{
        @Override
        public void onNotificationReceived(Payload payload) {

            if (payload!=null) {
                Gson gson = new Gson();
                String jsonPayload = gson.toJson(payload);
                try {
                    invokeMethodOnUiThread(iZootoConstant.iZOOTO_RECEIVED_PAYLOAD, jsonPayload);
                } catch (Exception e) {
                    Log.v(iZootoConstant.PLUGIN_EXCEPTION,e.toString());
                }
            }

        }

        @Override
        public void onNotificationOpened(String data) {
            notificationOpenedData = data;
            if (data!=null) {
                try {
                    invokeMethodOnUiThread(iZootoConstant.iZOOTO_OPEN_NOTIFICATION, data);
                } catch (Exception e) {
                    Log.v(iZootoConstant.PLUGIN_EXCEPTION,e.toString());
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
                    Log.v(iZootoConstant.PLUGIN_EXCEPTION,e.toString());
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
                    Log.v(iZootoConstant.PLUGIN_EXCEPTION,e.toString());
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
                    Log.v(iZootoConstant.PLUGIN_EXCEPTION,e.toString());
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

    private static void setCustomNotification(int index) {
        if (index == 2) {
            iZooto.setDefaultTemplate(PushTemplate.TEXT_OVERLAY);
        }
        else if(index == 3) {
            iZooto.setDefaultTemplate(PushTemplate.DEVICE_NOTIFICATION_OVERLAY);
        }
         else {
            iZooto.setDefaultTemplate(PushTemplate.DEFAULT);
        }
    }

    static int getBadgeIcon(Context context, String setBadgeIcon){
        int bIicon = 0;
        int checkExistence = context.getResources().getIdentifier(setBadgeIcon, "drawable", context.getPackageName());
        if ( checkExistence != 0 ) {  // the resource exists...
            bIicon = checkExistence;
        }
        else {  // checkExistence == 0  // the resource does NOT exist!!
            int checkExistenceMipmap = context.getResources().getIdentifier(
                    setBadgeIcon, "mipmap", context.getPackageName());
            if (checkExistenceMipmap != 0) {  // the resource exists...
                bIicon = checkExistenceMipmap;

            }

        }

        return bIicon;
    }

}
