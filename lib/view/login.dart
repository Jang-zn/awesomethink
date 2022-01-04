import 'package:flutter/material.dart';

class AwesomeThink extends StatelessWidget {
  const AwesomeThink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  void login(){

  }
  void signUp(){

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //키보드가 화면 밀어버리는거 방지
      resizeToAvoidBottomInset : false,

      body: SafeArea(
        child:Column(
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
                  )
              ),

            ),
            ElevatedButton(onPressed: login,
                child: const Text("Login")),
            ElevatedButton(onPressed: signUp,
                child: const Text("SignUp")),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}