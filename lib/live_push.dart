import 'dart:async';

import 'package:flutter/services.dart';

class LivePush {
  MethodChannel _channel = const MethodChannel('live_push')
    ..setMethodCallHandler(_handler);

  //////////////////////////////
  ///flutter向原生交互块
  //////////////////////////////
  ///准备
  Future<bool> onPushPrepare({String pushUrl}) async {
    return await _channel.invokeMethod('pushPrepare', {'pushUrl': pushUrl});
  }

  ///推流
  Future onPushStart() async {
    return await _channel.invokeMethod('pushStart');
  }

  ///停止
  Future<bool> onPushStop() async {
    return await _channel.invokeMethod('pushStop');
  }

  ///结束
  Future<bool> onPushEnd() async {
    return await _channel.invokeMethod('pushEnd');
  }

  ///暂停或者播放
  Future onPlayOrPause() async {
    return await _channel.invokeMethod('onPlayOrPause');
  }

  //////////////////////////////
  ///原生向flutter交互块
  //////////////////////////////
  static Future<dynamic> _handler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'audioFps':
        return _fpsController.add(methodCall.arguments);
        break;
      case 'streamState':
        return _streamController.add(methodCall.arguments);
        break;
    }
    return Future.value();
  }

  static StreamController<String> _streamController =
      StreamController.broadcast();

  static StreamController<String> _fpsController = StreamController.broadcast();

  ///监听fps的Stream
  Stream<String> get fpsResponse => _fpsController.stream;

  ///监听推流状态的Stream
  Stream<String> get stateResponse => _streamController.stream;
}
