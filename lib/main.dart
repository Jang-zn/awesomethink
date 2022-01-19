import 'package:awesomethink/ui/page/user_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AwesomeThink());
}

class AwesomeThink extends StatelessWidget {
  const AwesomeThink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return GetMaterialApp(
        title: 'AwesomeThink',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const AuthPage(),
      );
  }
}

