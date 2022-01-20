import 'package:awesomethink/controller/auth_controller.dart';
import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/data/provider/auth_provider.dart';
import 'package:awesomethink/data/provider/user_provider.dart';
import 'package:awesomethink/data/repository/user_repo.dart';
import 'package:awesomethink/ui/page/member_main.dart';
import 'package:awesomethink/ui/page/signUp.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  late final AuthController authController;
  late final UserController userController;


  @override
  void initState() {
    authController = Get.put(
        AuthController(authProvider: UserAuthProvider())
    );
  }

  void login() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
    Get.snackbar(
      "Login....",
      "",
      snackPosition : SnackPosition.TOP,
    );
      try {
        authController.signInWithEmail(
            emailController.text, pwController.text);
        userController = Get.put(
            UserController(
                userRepository: UserRepository(
                    userProvider: UserProvider(),
                    currentUser: authController.getCurrentUser()
                ))
        );
        if(userController.userInfo.type == UserType.admin.index){
          Get.to(AdminMainPage(), binding: BindingsBuilder((){
            Get.lazyPut<AuthController>(() => authController);
            Get.lazyPut<UserController>(() => userController);
          }));
        }else{
          Get.to(AwesomeMainPage(), binding: BindingsBuilder((){
            Get.lazyPut<AuthController>(() => authController);
            Get.lazyPut<UserController>(() => userController);
          }));
        }
      }catch(e){
        Get.snackbar("Error", "이메일 또는 비밀번호를 확인해주세요", snackPosition: SnackPosition.TOP);
      }
  }

  void signUp(){
    Get.to(SignUpPage(), binding: BindingsBuilder((){
      Get.lazyPut<AuthController>(() => authController);
      Get.lazyPut<UserController>(() => userController);
    }));
  }

  void admin(){
    Get.to(AdminMainPage(), binding: BindingsBuilder((){
      Get.lazyPut<AuthController>(() => authController);
      Get.lazyPut<UserController>(() => userController);
    }));
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
