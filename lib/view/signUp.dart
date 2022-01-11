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
  List<String> position = ["사원","팀장","사장"];
  String? selectedValue;

  SignUpPageState(){
    selectedValue= position[0];
  }

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordCheckFocus = FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late FirebaseProvider fp;

  @override
  void didChangeDependencies() {
    fp = Provider.of<FirebaseProvider>(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
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

            //연락처
            Container(
              margin: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
              child: TextFormField(
                decoration: const InputDecoration(
                    hintText: "Phone (000-0000-0000)",
                    hintStyle: TextStyle(color: Color.fromRGBO(180, 180, 180, 100))),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value)=>SignUpValidation().validatePhoneNumber(value),
                onSaved: (value)=>{
                  member.putIfAbsent("phone", () => value!)
                },
              ),
            ),

            //직급
            Container(
                margin:
                    EdgeInsets.only(top: 15, left: 70, right: 70, bottom: 40),
                child: DropdownButtonFormField(
                  value: selectedValue,
                  items: position.map(
                    (value) {
                      return DropdownMenuItem(
                        value:value,
                        child:Text(value)
                      );
                    }).toList(),
                  onChanged: (value) {
                    setState(() {
                      if(value!=null) {
                        selectedValue = value as String?;
                      }
                    });
                  },
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

  void submit() async {
    if(this._formKey.currentState!.validate()) {
      print(member);
    }
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     duration: Duration(seconds: 10),
  //     content: Row(
  //       children: <Widget>[
  //         CircularProgressIndicator(),
  //         Text("   Signing-Up...")
  //       ],
  //     ),
  //   ));
  //    bool result = await fp.signUpWithEmail(
  //        emailController.text, pwController.text);
  //   if (result) {
  //     Navigator.pop(context);
  //   } else {
  //
  //   }
   }
}


