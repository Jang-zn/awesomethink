import 'package:awesomethink/view/member_main.dart';
import 'package:awesomethink/view/signUp.dart';
import 'package:awesomethink/view/test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthWaitPage extends StatefulWidget {
  const AuthWaitPage({Key? key}) : super(key: key);

  @override
  State<AuthWaitPage> createState() => _AuthWaitPageState();
}

class _AuthWaitPageState extends State<AuthWaitPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset : true,
      body: SafeArea(
        child:ListView(
          children: [
            Container(
              child : const Image(
                image:AssetImage('assets/logo.png'),
                width:200,
                height:200,
              ),
              margin:const EdgeInsets.only(top:100, bottom:20),
            ),
            Container(
              child: Text("가입 승인 대기중"),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
