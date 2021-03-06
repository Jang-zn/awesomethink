import 'dart:async';
import 'package:awesomethink/ui/page/common_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runZonedGuarded((){
    runApp(const AwesomeThink());
  },FirebaseCrashlytics.instance.recordError);

}

class AwesomeThink extends StatelessWidget {
  const AwesomeThink({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
      return GetMaterialApp(
        title: 'AwesomeThink',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          fontFamily: 'ONE_Mobile_Pop',
        ),
        home: const AwesomeThinkLoginPage(title: 'AwesomeThink',),
      );
  }
}

