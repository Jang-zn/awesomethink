import 'package:awesomethink/view/member_main.dart';
import 'package:awesomethink/view/signUp.dart';
import 'package:awesomethink/view/test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AwesomeThink extends StatelessWidget {
  const AwesomeThink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AwesomeThink',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const AwesomeThinkLoginPage(title: 'AwesomeThink'),
    );
  }
}

class AwesomeThinkLoginPage extends StatefulWidget {
  const AwesomeThinkLoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AwesomeThinkLoginPage> createState() => _AwesomeThinkLoginPageState();
}

class _AwesomeThinkLoginPageState extends State<AwesomeThinkLoginPage> {

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
