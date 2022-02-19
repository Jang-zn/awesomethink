// ignore_for_file: file_names

import 'dart:collection';
import 'package:awesomethink/controller/auth_controller.dart';
import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/service/signup_validation.dart';
import 'package:awesomethink/ui/page/common_login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberInfoPage extends StatefulWidget {
  const MemberInfoPage({Key? key}) : super(key: key);

  @override
  MemberInfoPageState createState() {
    return MemberInfoPageState();
  }
}

class MemberInfoPageState extends State<MemberInfoPage> {
  TextEditingController pwController = TextEditingController();
  TextEditingController pwCheckController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Map<String, String> userMap = HashMap();
  List<String> position = ["사원", "팀장", "사장"];
  String? selectedValue;
  late final UserController userController;
  late final AuthController authController;

  MemberInfoPageState() {
    selectedValue = position[0];
  }

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordCheckFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  // ignore: must_call_super
  void initState() {
    userController = Get.put(UserController());
    authController = Get.find<AuthController>();
  }

  @override
  // ignore: must_call_super
  void didChangeDependencies() {
    userMap["position"] = selectedValue as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Form(key: _formKey, child: signUpForm()));
  }

  void backPage(){
    Get.back();
  }

  Widget signUpForm() {
    return SafeArea(
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              children: [
                //이메일 입력
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 70),
                  child: TextFormField(
                    controller: emailController,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.always,
                    decoration: const InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(180, 180, 180, 100))),
                    validator: (value) =>
                        SignUpValidation().validateEmail(_emailFocus, value),
                    onSaved: (value) => {
                      userMap.putIfAbsent("email", () => emailController.text)
                    },
                  ),
                ),

                //비밀번호 입력
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 7),
                  child: TextFormField(
                    obscureText: true,
                    controller: pwController,
                    focusNode: _passwordFocus,
                    autovalidateMode: AutovalidateMode.always,
                    decoration: const InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(180, 180, 180, 100))),
                    validator: (value) => SignUpValidation()
                        .validatePassword(_passwordFocus, value),
                    onSaved: (value) => {
                      userMap.putIfAbsent("password", () => pwController.text)
                    },
                  ),
                ),

                //비밀번호 체크
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 7),
                  child: TextFormField(
                    obscureText: true,
                    controller: pwCheckController,
                    focusNode: _passwordCheckFocus,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                        hintText: 'Password Check',
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(180, 180, 180, 100))),
                    validator: (value) => SignUpValidation()
                        .validatePasswordCheck(
                            _passwordCheckFocus, pwController.text, value),
                  ),
                ),

                //이름
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 7),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        hintText: "Name",
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(180, 180, 180, 100))),
                    onSaved: (value) =>
                        {userMap.putIfAbsent("name", () => value!)},
                    autovalidateMode: AutovalidateMode.always,
                    validator: (value) =>
                        SignUpValidation().validateName(value),
                  ),
                ),

                //연락처
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 7),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: "Phone (000-0000-0000)",
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(180, 180, 180, 100))),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        SignUpValidation().validatePhoneNumber(value),
                    onSaved: (value) =>
                        {userMap.putIfAbsent("phone", () => value!)},
                  ),
                ),

                //직급
                Container(
                  margin: const EdgeInsets.only(
                      top: 7, left: 70, right: 70, bottom: 40),
                  child: DropdownButtonFormField(
                    value: selectedValue,
                    items: position.map(
                      (value) {
                        return DropdownMenuItem(
                            value: value, child: Text(value));
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(
                        () {
                          if (value != null) {
                            selectedValue = value as String?;
                            userMap["position"] = value as String;
                          }
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      child: const Text("Submit"),
                      onPressed: submit,
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                      child: const Text("뒤로가기"), onPressed: backPage),
                ),
                //TODO 프사 등록, 안하면 기본이미지
              ],
            ),
          )
        ],
      ),
    );
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 10),
        content: Row(
          children: const <Widget>[
            CircularProgressIndicator(),
            Text("   Signing-Up...")
          ],
        ),
      ));
      //1. Member 객체 빈거 만들고 (user) signup 성공하면
      Member user = Member();
      try {
        await authController
            .signUpWithEmail(emailController.text, pwController.text)
            .then((value) {
          // 스낵바 접어주고, currentUser uid를 userMap에 넣어주고, userSignUpdata로 Member객체에 넣어줌.
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          userMap["uid"] = authController.getCurrentUser()!.uid;
          user = user.userSignUpData(userMap);
          //user 콜렉션에 현재 가입한 uid를 가지는 document 생성
          userController.setUserInfo(user);
          //페이지 닫음
          Get.offAll(const AwesomeThinkLoginPage(title: "AwesomeThink"),
              binding: BindingsBuilder(() {
            Get.put(authController);
          }));
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(
            content: Text("이미 가입된 계정입니다.",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            duration: Duration(milliseconds: 1000),
            margin: EdgeInsets.only(
              bottom: 520,
            ),
          ));
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("입력양식을 확인해주세요",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.only(
          bottom: 520,
        ),
      ));
    }
  }
}
