# live_push

七牛推流插件

## Getting Started

#### 七牛直播推流插件
  * Android is OK
  * IOS is developing

#### 如何使用
* Android集成
    * 在你的`pubspec.yaml`中添加 `live_push: ^0.0.1`
    * 执行 flutter pub get 命令
    * 打开 android -> app -> src -> main -> AndroidManifest.xml  文件添加推流相关权限

          <uses-permission android:name="android.permission.INTERNET" />
          <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
          <uses-permission android:name="android.permission.RECORD_AUDIO" />
          <uses-permission android:name="android.permission.CAMERA" />
          <uses-permission android:name="android.permission.WAKE_LOCK" />
          <uses-feature android:name="android.hardware.camera.autofocus" />
          <uses-feature android:glEsVersion="0x00020000" android:required="true" />
          <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
  * 高版本Android需要动态权限申请
  * 在需要使用到推流的地方导入 ` import 'package:live_push/live_push.dart';` 包
  *  方法说明

          livePush.onPushPrepare(pushUrl: pushUrl); //初始化的时候  pushUrl 推流地址 必传
          livePush.onPushStart(); //开始推流
          livePush.onPushStop(); //停止推流
          livePush.onPushEnd(); //结束推流
          livePush.onPlayOrPause();//暂停或者继续播放

         ///推流连接状态监听 ` stateResponse` 如：
          livePush.stateResponse.listen((streamState) {
               setState(() {
                 this.streamState = this.streamState + '->' + streamState;
               });
             });
         ///推流fps监听 `fpsResponse` 如：
         livePush.fpsResponse.listen((text) {
               setState(() {
                 fps = text;
               });
             });

* IOS
   * 开发中

### 个人开发使用，插件只实现了音频推流
