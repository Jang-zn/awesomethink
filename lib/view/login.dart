import 'package:awesomethink/view/admin_main.dart';
import 'package:awesomethink/view/member_main.dart';
import 'package:awesomethink/view/signUp.dart';
import 'package:awesomethink/view/test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AwesomeThinkLoginPage extends StatefulWidget {
  const AwesomeThinkLoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AwesomeThinkLoginPage> createState() => _AwesomeThinkLoginPageState();
}

class _AwesomeThinkLoginPageState extends State<AwesomeThinkLoginPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  void login(){
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>AwesomeMainPage()));
  }
  void signUp(){
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>SignUpPage()));
  }
  void test(){
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>TestPage()));
  }
  void admin(){
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>AdminMainPage()));
  }


  @override
  Widget build(BuildContext context) {

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
                controller: idController,
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
                    child:ElevatedButton(onPressed: test,
                        child: const Text("Test")),
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
