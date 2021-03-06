import 'package:awesomethink/controller/auth_controller.dart';
import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/ui/page/common_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthWaitPage extends StatefulWidget {
  const AuthWaitPage({Key? key}) : super(key: key);

  @override
  State<AuthWaitPage> createState() => _AuthWaitPageState();
}

class _AuthWaitPageState extends State<AuthWaitPage> {
  AuthController authController = Get.find<AuthController>();

  void logout() async {

    Get.find<UserController>().onDelete();
    Get.find<WorkController>(tag:authController.getCurrentUser()!.uid).onDelete();
    authController.signOut();
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();
    Get.offAll(const AwesomeThinkLoginPage(title: "AwesomeThink"));
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(child: Scaffold(
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
              margin:const EdgeInsets.only(top:150, bottom:20),
            ),
            Container(
              padding:const EdgeInsets.symmetric(horizontal: 50),
                child:const LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                )
            ),
            Container(
              margin: const EdgeInsets.only(top:20),
              alignment: Alignment.center,
              child: const Text("가입 승인 대기중", style:TextStyle(fontSize: 16)),
            ),
            TextButton(
              onPressed: logout,
              child: const Text("뒤로가기"),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ), onWillPop: null);
  }
}
