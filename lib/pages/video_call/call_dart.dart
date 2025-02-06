import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:go_router/go_router.dart';
import 'package:shamo/utils/settings.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key, this.clientName, this.role});

  final String? clientName;
  final ClientRole? role;

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool viewPanel = false;
  late RtcEngine _engine;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
  }

  Future<void> initialize() async {
    if (appId.isEmpty) {
      setState(() {
        _infoStrings.add('App id is missing');
        _infoStrings.add("Agora is not starting");
      });
      return;
    }

    _engine = await RtcEngine.create(appId);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role!);
    _addAgoraEventHandlers();

    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = const VideoDimensions(width: 540, height: 260); // Mengubah resolusi
    await _engine.setVideoEncoderConfiguration(configuration);

    // Cek apakah token dan clientName sudah benar
    if (token != null && widget.clientName != null) {
      await _engine.joinChannel(token, widget.clientName!, null, 0);
    } else {
      setState(() {
        _infoStrings.add("Token or client name is missing");
      });
    }
  }


  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code){
      setState(() {
        final info = 'error:$code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed){
      setState(() {
        final info = 'Join channel: $channel, uid : $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('leave channel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'user joined $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'user offline $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed){
      setState(() {

        final info = 'first remote video : $uid ${width} x $height';
        _infoStrings.add(info);
      });
    },),);
  }

  Widget _viewRows() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster){
      list.add(const rtc_local_view.SurfaceView());
    }

    for (var uid in _users) {
      list.add(rtc_remote_view.SurfaceView(
        uid: uid,
        channelId: widget.clientName!,
      ));
    }

    final views = list;

    return Column(

      children: List.generate(views.length, (index) {
        return Expanded(child: views[index]);
      }),
    );
  }

  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return const SizedBox();

    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RawMaterialButton(onPressed: (){
            setState(() {
              muted = !muted;
            });
            _engine.muteLocalAudioStream(muted);
          },
            child: Icon(muted ? Icons.mic_off : Icons.mic, color: muted ? Colors.white : Colors.blueAccent, size: 20,),
            shape: const CircleBorder(),
            elevation: 2,
            fillColor: muted ? Colors.blueAccent : Colors.white,
          ),
          RawMaterialButton(onPressed: () {
            // Navigator.pop(context);
            context.pop();
          },
            child: Icon(Icons.call_end, color: Colors.white, size: 35,),
            fillColor: Colors.redAccent,
            padding: EdgeInsets.all(15),
          ),
          RawMaterialButton(onPressed: (){
            _engine.switchCamera();
          },
            child: Icon(Icons.switch_camera, color: Colors.blueAccent, size: 20,),
            elevation: 2,
            fillColor: Colors.white,
            padding: EdgeInsets.all(12),
          ),
        ],
      ),
    );
  }

  Widget _panels() {
    return Visibility(
      visible: viewPanel,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 48),
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.5,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: ListView.builder(
                reverse: true,
                itemCount: _infoStrings.length,
                itemBuilder: (context, index) {
                  if (_infoStrings.isEmpty){
                    return Text("null");
                  }
                  return Padding(
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Text(_infoStrings[index], style: TextStyle(color: Colors.blueGrey),),
                            )
                        ),
                      ],
                    ),
                  );

              },),
            ),
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agora'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              viewPanel = !viewPanel;
            });
          }, icon: Icon(Icons.info_outline))
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            _viewRows(),
            _panels(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
