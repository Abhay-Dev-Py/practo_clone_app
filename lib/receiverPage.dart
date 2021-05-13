import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:caller_app/call.dart';
import 'package:caller_app/roleSelection.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ReceiverCall extends StatefulWidget {
  @override
  _ReceiverCallState createState() => _ReceiverCallState();
}

class _ReceiverCallState extends State<ReceiverCall> {
  bool isCalling = false;
  bool isRinging = false;
  String MyMobileNumber = '100';
  Container isRingingScreen()
  {
    return Container(
      child: Center(
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RaisedButton(
              child: Text('Pickup'),
              onPressed: () async{
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>CallPage()));
                await _handleCameraAndMic(Permission.camera);
                await _handleCameraAndMic(Permission.microphone);
                await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => CallerPage(
                    channelName: MyMobileNumber,
                    role : ClientRole.Broadcaster,
                  ),
                ));
              }
          ),
          SizedBox(width: 20,),
          RaisedButton(
              child: Text('HangUp'),
              onPressed: (){
                final databaseReference = Firestore.instance;
                databaseReference.collection('users').document(MyMobileNumber).setData({
                  'isCalling' : false,
                });
                isRinging = false;
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RoleSelect()));
              }
          ),
        ],

      ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    checkStatus();
    return Scaffold(
      appBar: AppBar(
        title: Text('Receive Call'),
      ),
      body: isCalling? (isRinging)?isRingingScreen():Center(child: Text('Someone is calling'),):Center(child: Text("Waiting to receive a call"),),

    );
  }
  Future<void> checkStatus() async
  {
    final databaseReference = Firestore.instance;
    databaseReference.collection('users').document(MyMobileNumber).get().then((DocumentSnapshot)
    {
      print('Idher -> '+DocumentSnapshot.data['isCalling'].toString());
      setState(() async {
        isCalling = DocumentSnapshot.data['isCalling'];
        if(isCalling)
           {
             setState(() {
               isRinging = true;
             });
            await _handleCameraAndMic(Permission.camera);
            await _handleCameraAndMic(Permission.microphone);
            await Navigator.push(context, MaterialPageRoute(
              builder: (context) => CallerPage(
                  channelName: MyMobileNumber,
                  role : ClientRole.Broadcaster,
              ),
            ));
          }
      });
    }
    );
  }
  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
