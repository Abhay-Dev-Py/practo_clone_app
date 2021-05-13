import 'package:flutter/material.dart';
import 'dart:async';
import 'call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
class CallPage extends StatefulWidget {
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _phoneNo = TextEditingController();
  bool error = false;
  ClientRole _role = ClientRole.Broadcaster;
  @override
  void dispose() {
    // dispose input controller
    _phoneNo.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caller App'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 400,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _phoneNo,
                      decoration: InputDecoration(
                        errorText : error? "Please enter phone no.":null,
                        hintText: 'Mobile no.',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        onPressed: onCall,
                        child: Text('Call'),
                        color: Colors.yellowAccent,
                        textColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> onCall() async
  {


    setState(() {
      _phoneNo.text.isEmpty? error = true : error = false;
    });
    if(_phoneNo.text.isNotEmpty)
      {
        await updateCall();
        await _handleCameraAndMic(Permission.camera);
        await _handleCameraAndMic(Permission.microphone);
        await Navigator.push(context, MaterialPageRoute(
            builder: (context) => CallerPage(
              channelName: _phoneNo.text,
              role :_role
            ),
        ));
      }
  }
  Future<void> _handleCameraAndMic(Permission permission) async
  {
    final status = await permission.request();
    print('->'+status.toString());
  }
  Future<void> updateCall() async
  {
    //Set value of incoming call to true of phoneNumber
    String phoneNumber = _phoneNo.text;
    print('Mobile Number --> '+phoneNumber);
    final databaseReference = Firestore.instance;
    databaseReference.collection('users').document(phoneNumber).setData({
      'isCalling' : true,
    });
  }
}
