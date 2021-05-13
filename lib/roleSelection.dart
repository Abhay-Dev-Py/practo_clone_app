import 'package:caller_app/call.dart';
import 'package:caller_app/receiverPage.dart';
import 'package:flutter/material.dart';

import 'callPage.dart';
class RoleSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a role'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text('Caller'),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CallPage()));
                }
            ),
            SizedBox(width: 20,),
            RaisedButton(
                child: Text('Receiver'),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceiverCall()));
                }
            ),
          ],

        ),
      ),
    );
  }
}
