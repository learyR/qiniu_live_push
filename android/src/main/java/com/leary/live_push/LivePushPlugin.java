package com.leary.live_push;

import android.util.Log;

import com.qiniu.pili.droid.streaming.AVCodecType;
import com.qiniu.pili.droid.streaming.MediaStreamingManager;
import com.qiniu.pili.droid.streaming.StreamStatusCallback;
import com.qiniu.pili.droid.streaming.StreamingEnv;
import com.qiniu.pili.droid.streaming.StreamingProfile;
import com.qiniu.pili.droid.streaming.StreamingState;
import com.qiniu.pili.droid.streaming.StreamingStateChangedListener;

import org.json.JSONObject;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * LivePushPlugin
 *
 * @author leary
 */
public class LivePushPlugin implements MethodCallHandler {
    private static final String TAG = "leary_LivePushPlugin";
    private MediaStreamingManager mMediaStreamingManager;
    private StreamingProfile mProfile;
    private boolean mIsStreaming;
    private Registrar mRegistrar;
    private static MethodChannel mChannel;

    public LivePushPlugin(Registrar mRegistrar) {
        this.mRegistrar = mRegistrar;
        StreamingEnv.init(mRegistrar.activity());
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        LivePushPlugin plugin = new LivePushPlugin(registrar);
        mChannel = new MethodChannel(registrar.messenger(), "live_push");
        mChannel.setMethodCallHandler(plugin);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "pushPrepare":
                String pushUrl = call.argument("pushUrl");
                pushPrepare(pushUrl, result);
                break;
            case "pushStart":
                if (mMediaStreamingManager != null) {
                    mMediaStreamingManager.startStreaming();
                }
                break;
            case "pushStop":
                if (mMediaStreamingManager != null) {
                    mMediaStreamingManager.stopStreaming();
                }
                break;
            case "pushEnd":
                if (mMediaStreamingManager != null) {
                    mMediaStreamingManager.stopStreaming();
                    mMediaStreamingManager.destroy();
                }
                break;
            case "onPlayOrPause":
                onPlayOrPause();
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    /**
     * 开始推流点击事件
     */
    private void onPlayOrPause() {
        if (mMediaStreamingManager == null) {
            return;
        }
        if (mIsStreaming) {
            mMediaStreamingManager.stopStreaming();
        } else {
            mMediaStreamingManager.startStreaming();
        }
    }

    /**
     * 准备推流
     *
     * @param url
     */
    private void pushPrepare(String url, final Result result) {
        Log.e(TAG, "开始准备直播");
        try {
            mProfile = new StreamingProfile();
            JSONObject streamJson = new JSONObject(url);

            mProfile.setVideoQuality(StreamingProfile.AUDIO_QUALITY_HIGH1)
                    .setEncodingSizeLevel(StreamingProfile.VIDEO_ENCODING_HEIGHT_480)
                    .setEncoderRCMode(StreamingProfile.EncoderRCModes.QUALITY_PRIORITY)
                    .setStream(new StreamingProfile.Stream(streamJson));

            mMediaStreamingManager = new MediaStreamingManager(mRegistrar.activity(), AVCodecType.SW_AUDIO_CODEC);
            mMediaStreamingManager.prepare(mProfile);
            mMediaStreamingManager.setStreamStatusCallback(new StreamStatusCallback() {
                @Override
                public void notifyStreamStatusChanged(StreamingProfile.StreamStatus streamStatus) {
                    mChannel.invokeMethod("audioFps", streamStatus.audioFps + "fps");
                }
            });
            mMediaStreamingManager.setStreamingStateListener(new StreamingStateChangedListener() {
                @Override
                public void onStateChanged(StreamingState streamingState, Object o) {
                    Log.e(TAG, streamingState.name());
                    mChannel.invokeMethod("streamState", streamingState.name());
                    switch (streamingState) {
                        case PREPARING:
                            //可以显示加载进度
                            break;
                        case READY:
                            // start streaming when READY
                            break;
                        case CONNECTING:
                            //已连接
                            break;
                        case STREAMING:
                            //正在推流
                            mIsStreaming = true;
                            break;
                        case IOERROR:
                            // 与七牛网络连接错误（一般是推流地址的错误）
                            break;
                        case SHUTDOWN:
                            //停止推流
                        case DISCONNECTED:
                            //断开连接
                            mIsStreaming = false;
                            mChannel.invokeMethod("audioFps", "0fps");
                            break;
                        default:
                            break;
                    }
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}
