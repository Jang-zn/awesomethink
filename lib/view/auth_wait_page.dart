import 'package:awesomethink/firebase/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AuthWaitPage extends StatefulWidget {
  const AuthWaitPage({Key? key}) : super(key: key);

  @override
  State<AuthWaitPage> createState() => _AuthWaitPageState();
}

class _AuthWaitPageState extends State<AuthWaitPage> {
  FirebaseProvider? fp;

  void logout() {
    fp!.signOut();
  }


  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

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
              margin:const EdgeInsets.only(top:150, bottom:20),
            ),
            Container(
              padding:EdgeInsets.symmetric(horizontal: 50),
                child:const LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                )
            ),
            Container(
              margin: EdgeInsets.only(top:20),
              alignment: Alignment.center,
              child: Text("가입 승인 대기중", style:TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            TextButton(
              onPressed: logout,
              child: Text("뒤로가기"),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
