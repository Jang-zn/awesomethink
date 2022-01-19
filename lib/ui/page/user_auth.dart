import 'package:awesomethink/data/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_main.dart';
import 'auth_wait_page.dart';
import 'login.dart';
import 'member_main.dart';

late AuthPageState pageState;

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  AuthPageState createState() {
    return AuthPageState();
  }
}

class AuthPageState extends State<AuthPage> {
  UserAuthProvider? fp;

  get logger => null;

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<UserAuthProvider>(context);
    //최근 로그인 기록 보고서 로그인페이지 또는 메인페이지로 이동
    if (fp!.getUserInfo()?.uid != null) {
      if (fp!.getUserInfo()?.state == false) {
        return const AuthWaitPage();
      }
      if (fp!.getUserInfo()?.type == 1) {
        return const AdminMainPage();
      }
      return AwesomeMainPage(firebaseProvider: fp!);
    } else {
      return const AwesomeThinkLoginPage(title: 'AwesomeThink');
    }
  }
}