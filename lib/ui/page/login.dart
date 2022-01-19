import 'package:awesomethink/data/provider/auth_provider.dart';
import 'package:awesomethink/ui/page/signUp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'admin_main.dart';


class AwesomeThinkLoginPage extends StatefulWidget {
  const AwesomeThinkLoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AwesomeThinkLoginPage> createState() => _AwesomeThinkLoginPageState();
}

class _AwesomeThinkLoginPageState extends State<AwesomeThinkLoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late UserAuthProvider fp;


  void login() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: const Duration(seconds: 5),
        content: Row(
          children: const <Widget>[
            CircularProgressIndicator(),
            Text("   Login...")
          ],
        ),
      ));
      bool result = await fp.signInWithEmail(
          emailController.text, pwController.text);
      if (result != true) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            content: Row(
              children: const [
                Text("이메일 또는 비밀번호를 확인해주세요")
              ],
            ),
          ));
      }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
  void signUp(){
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>SignUpPage()));
  }
  void admin(){
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>AdminMainPage()));
  }


  @override
  Widget build(BuildContext context) {
    fp = Provider.of<UserAuthProvider>(context);


    return Scaffold(
      //키보드가 화면 밀게 함. 대신 리스트뷰로 스크롤 가능하게 해야 사용 가능
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
              margin: EdgeInsets.symmetric(horizontal: 70),
              child : TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText:"ID",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
              child : TextField(
                  controller: pwController,
                  decoration: const InputDecoration(
                    hintText:"Password",
                  ),
                  obscureText:true,
              ),

            ),
            Container(
              padding:EdgeInsets.symmetric(horizontal: 30),
              child:Column(
                children: [
                  Container(
                      width:MediaQuery.of(context).size.width*0.5,
                      child:ElevatedButton(onPressed: login,
                          child: const Text("Login")),
                  ),
                  Container(
                      width:MediaQuery.of(context).size.width*0.5,
                      child:ElevatedButton(onPressed: signUp,
                          child: const Text("SignUp")),
                  ),
                  Container(
                    width:MediaQuery.of(context).size.width*0.5,
                    child:ElevatedButton(onPressed: admin,
                        child: const Text("Admin")),
                  )
                ],
              )
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
