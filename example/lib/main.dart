import 'package:flutter/material.dart';
import 'package:live_push/live_push.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String pushUrl =
      '{"disabledTill":0,"hosts":{"play":{"rtmp":"pili-live-rtmp.dreambigcareer.com","http":"pili-live-hls.dreambigcareer.com"},"publish":{"rtmp":"pili-publish.dreambigcareer.com"},"playback":{"http":"10004ms.playback1.z1.pili.qiniucdn.com","hls":"10004ms.playback1.z1.pili.qiniucdn.com"},"live":{"rtmp":"pili-live-rtmp.dreambigcareer.com","hdl":"pili-live-hdl.dreambigcareer.com","http":"pili-live-hls.dreambigcareer.com","hls":"pili-live-hls.dreambigcareer.com","snapshot":"pili-live-snapshot.dreambigcareer.com"}},"expireAt":"0001-01-01T00:00:00Z","title":"DBC201811221037521531","nonce":0,"createdAt":"2017-08-31T04:01:25.757+08:00","hub":"dbc-product","publishSecurity":"static","disabled":false,"id":"z1.dbc-product.DBC201811221037521531","publishKey":"5de7fb8c312e7e1b","updatedAt":"2017-08-31T04:01:25.757+08:00"}';
  LivePush livePush = LivePush();
  String testUrl =
      'rtmp://pili-publish.qnsdk.com/sdk-live/b5f08462-c0b8-4cb8-a62e-94f7d61465f6?e=1563795000&token=QxZugR8TAhI38AiJ_cptTl3RbzLyca3t-AAiH-Hh:XzEdppCuYZdlycFoPGrAZLdQsbI=';
  String fps = '0fps';
  String streamState = 'Origial';

  @override
  void initState() {
    super.initState();
    livePush.onPushPrepare(pushUrl: pushUrl);
    _fps();
    _streamState();
  }

  _streamState() {
    livePush.stateResponse.listen((streamState) {
      setState(() {
        this.streamState = this.streamState + '->' + streamState;
      });
    });
  }

  _fps() {
    livePush.fpsResponse.listen((text) {
      print('leary_text' + text);
      setState(() {
        fps = text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  livePush.onPushStart();
                },
                child: Text('开始推流'),
                color: Colors.blue),
            FlatButton(
                onPressed: () {
                  livePush.onPushStop();
                },
                child: Text('停止推流'),
                color: Colors.blue),
            FlatButton(
                onPressed: () {
                  livePush.onPlayOrPause();
                },
                child: Text('暂停播放'),
                color: Colors.blue),
            Text(fps),
            Text(streamState)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    livePush.onPushEnd();
    super.dispose();
  }
}
