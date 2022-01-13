
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
      child: const AwesomeThink()));
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
  FirebaseProvider? fp;
  get logger => null;


  @override
  Widget build (BuildContext context) {
    fp=Provider.of<FirebaseProvider>(context);

    late Member user = UserDatabase().getUserByUid(fp!.getUser()!.uid);

    //최근 로그인 기록 보고서 로그인페이지 또는 메인페이지로 이동
    if (fp!.getUser() != null ) {
      print("user??? : "+user.toString());
      print("user? : "+fp!.getUser().toString());
      if(user.state==false){
        return const AuthWaitPage();
      }
      if(user.type==1){
        return const AdminMainPage();
      }
      return const AwesomeMainPage();
    } else {
      return  const AwesomeThinkLoginPage(title: 'AwesomeThink');
    }
  }
}

