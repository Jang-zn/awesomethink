import 'package:awesomethink/firebase/user_database.dart';
import 'package:awesomethink/view/admin_main.dart';
import 'package:awesomethink/view/auth_wait_page.dart';
import 'package:awesomethink/view/login.dart';
import 'package:awesomethink/view/member_main.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase/firebase_provider.dart';
import 'model/member.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseProvider()),
      ],
      child: AwesomeThink()));
}

class AwesomeThink extends StatelessWidget {
  const AwesomeThink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AwesomeThink',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const AuthPage(),
    );
  }
}


//인증서비스 첫페이지 --> 로그인 화면에서 singUp 하면 여기로 넘어옴


late AuthPageState pageState;

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  AuthPageState createState() {
    pageState = AuthPageState();
    return pageState;
  }
}

class AuthPageState extends State<AuthPage> {
  late FirebaseProvider fp;

  get logger => null;

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    //최근 로그인 기록 보고서 로그인페이지 또는 메인페이지로 이동
    if (fp.getUser() != null ) {
      Member _user = UserDatabase().getUserByUid(fp.getUser()!.uid);
      print(fp.getUser());
      print(_user.toString());

      if(_user.state!=false){
        return AuthWaitPage();
      }

      if(_user.type==1){
        return AdminMainPage();
      }

      return AwesomeMainPage();

    } else {
      return  AwesomeThinkLoginPage(title: 'AwesomeThink');
    }
  }
}