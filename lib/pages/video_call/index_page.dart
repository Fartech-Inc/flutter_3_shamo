import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:shamo/pages/video_call/call_dart.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _channelController = TextEditingController();
  bool _validateError = false;
  ClientRole? _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agora"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const SizedBox(height: 36),
              // Image.network("https://tinyurl.com/2p889y4k"),
              const SizedBox(height: 20),
              TextField(
                controller: _channelController,
                decoration: InputDecoration(
                  errorText: _validateError ? 'channel is mandatory' : null,
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(width: 1)
                  ),
                  hintText: 'Channel name'
                ),
              ),
              RadioListTile(title: Text('Broadcaster'),value: ClientRole.Broadcaster, groupValue: _role, onChanged: (ClientRole? value){
                setState(() {
                  _role = value;
                });
              }),
              RadioListTile(title: Text('Audience'),value: ClientRole.Audience, groupValue: _role, onChanged: (ClientRole? value){
                setState(() {
                  _role = value;
                });
              }),
              ElevatedButton(onPressed: onJoin, child: Text('JOIN'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _channelController.text.isEmpty ? _validateError = true : _validateError = false;
    });

    if (_channelController.text.isNotEmpty){
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      if (!mounted) return;
      await Navigator.push(context, MaterialPageRoute(builder: (context) => CallPage(clientName: _channelController.text, role: _role,),));
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    log(status.toString());
  }
}
