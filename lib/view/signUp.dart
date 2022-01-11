import 'dart:collection';

import 'package:awesomethink/firebase/firebase_provider.dart';
import 'package:awesomethink/service/signup_validation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() {
    return SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  TextEditingController pwController = TextEditingController();
  TextEditingController pwCheckController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController1 = TextEditingController();
  TextEditingController phoneController2 = TextEditingController();
  TextEditingController phoneController3 = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordCheckFocus = FocusNode();
  GlobalKey<SignUpPageState> formKey = GlobalKey<SignUpPageState>();

  void submit() {
    Navigator.of(context).pop();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late FirebaseProvider fp;

  @override
  void didChangeDependencies() {
    fp = Provider.of<FirebaseProvider>(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: formKey,
            child: SignUpForm()
        )
    );
  }

  Widget SignUpForm() {
    return SafeArea(
        child: ListView(children: [
      Container(
          margin: EdgeInsets.symmetric(vertical: 50),
          child: Column(children: [

            //이메일 입력
            Container(
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 70),
              child:  TextFormField(
                  controller: emailController,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.always,
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (value) => SignUpValidation().validateEmail(_emailFocus, value),
                ),
            ),

            //비밀번호 입력
            Container(
              margin: EdgeInsets.symmetric(horizontal: 70, vertical: 0),
              child: TextFormField(
                obscureText: true,
                controller: pwController,
                focusNode: _passwordFocus,
                autovalidateMode: AutovalidateMode.always,
                decoration: InputDecoration(hintText: 'Password'),
                validator: (value) => SignUpValidation().validatePassword(_passwordFocus, value),
              ),
            ),

          //비밀번호 체크
            Container(
              margin: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
              child: TextFormField(
                obscureText: true,
                controller: pwCheckController,
                focusNode: _passwordCheckFocus,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(hintText: 'Password'),
                validator: (value) => SignUpValidation().validatePasswordCheck(_passwordCheckFocus,pwController.text, value),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                    hintText: "Name",
                    hintStyle:
                        TextStyle(color: Color.fromRGBO(180, 180, 180, 100))),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
              child: TextField(
                controller: positionController,
                decoration: const InputDecoration(
                    hintText: "Position",
                    hintStyle:
                        TextStyle(color: Color.fromRGBO(180, 180, 180, 100))),
              ),
            ),
            Container(
                margin:
                    EdgeInsets.only(top: 15, left: 70, right: 70, bottom: 40),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 40,
                        child: TextField(
                          controller: phoneController1,
                          decoration: const InputDecoration(
                              hintText: "000",
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(180, 180, 180, 100))),
                        ),
                      ),
                      Container(
                        child: Text("-"),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      Container(
                        width: 40,
                        child: TextField(
                          controller: phoneController2,
                          decoration: const InputDecoration(
                              hintText: "0000",
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(180, 180, 180, 100))),
                        ),
                      ),
                      Container(
                        child: Text("-"),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      Container(
                        width: 40,
                        child: TextField(
                          controller: phoneController3,
                          decoration: const InputDecoration(
                              hintText: "0000",
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(180, 180, 180, 100))),
                        ),
                      ),
                    ])),
            Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  child: Text("Submit"),
                  onPressed: submit,
                )),
            //TODO 프사 등록, 안하면 기본이미지
          ]))
    ]));
  }

  //TODO 비밀번호, 입력양식 validation 통과해야 버튼 누를수 있음
  void _signUp() async {
    Map<String, String> member = HashMap();
    member.putIfAbsent("email", () => emailController.text);
    member.putIfAbsent("password", () => pwController.text);
    member.putIfAbsent("name", () => nameController.text);
    member.putIfAbsent("position", () => positionController.text);
    member.putIfAbsent("phone", () =>
    phoneController1.text + "-" + phoneController2.text + "-" +
        phoneController3.text);


    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 10),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          Text("   Signing-Up...")
        ],
      ),
    ));
     bool result = await fp.signUpWithEmail(
         emailController.text, pwController.text);
    if (result) {
      Navigator.pop(context);
    } else {

    }
  }


}


