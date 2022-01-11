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
  TextEditingController emailController = TextEditingController();


  Map<String, String> member = HashMap();

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
                  decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle:TextStyle(color: Color.fromRGBO(180, 180, 180, 100))),
                  validator: (value) => SignUpValidation().validateEmail(_emailFocus, value),
                  onSaved: (value)=>{
                    member.putIfAbsent("email", () => emailController.text)
                  },
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
                decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle:TextStyle(color: Color.fromRGBO(180, 180, 180, 100))),
                validator: (value) => SignUpValidation().validatePassword(_passwordFocus, value),
                onSaved: (value)=>{
                  member.putIfAbsent("password", () => pwController.text)
                },
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
                decoration: InputDecoration(
                    hintText: 'Password Check',
                    hintStyle:TextStyle(color: Color.fromRGBO(180, 180, 180, 100))),
                validator: (value) => SignUpValidation().validatePasswordCheck(_passwordCheckFocus,pwController.text, value),
              ),
            ),

            //이름
            Container(
              margin: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
              child: TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    hintText: "Name",
                    hintStyle:
                        TextStyle(color: Color.fromRGBO(180, 180, 180, 100))),
                onSaved: (value)=>{
                  member.putIfAbsent("name", () => value!)
                },
                autovalidateMode: AutovalidateMode.always,
                validator: (value)=>SignUpValidation().validateName(value),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
              child: TextField(
                decoration: const InputDecoration(
                    hintText: "Position",
                    hintStyle:
                        TextStyle(color: Color.fromRGBO(180, 180, 180, 100))),
              ),
            ),
            Container(
                margin:
                    EdgeInsets.only(top: 15, left: 70, right: 70, bottom: 40),
                child: TextFormField(

                    ),
            ),
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


