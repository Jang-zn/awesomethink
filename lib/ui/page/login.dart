import 'package:awesomethink/controller/admin_controller.dart';
import 'package:awesomethink/controller/auth_controller.dart';
import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/ui/page/auth_wait_page.dart';
import 'package:awesomethink/ui/page/member_main.dart';
import 'package:awesomethink/ui/page/signUp.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


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

  late final AuthController authController;
  late final UserController userController;
  late final WorkController workController;
  late final AdminController adminController;


  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
    userController = Get.put(UserController());
    adminController = Get.put(AdminController());
  }

  void login() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
    Get.snackbar(
      "Login....",
      "",
      snackPosition : SnackPosition.TOP,
      duration: const Duration(milliseconds: 800),

    );
    //로그인 후 에러 안나면
      try {
        await authController.signInWithEmail(emailController.text, pwController.text);
          if(authController.getCurrentUser()!.email==emailController.text) {
            await initController().whenComplete(() {
              //Admin / Normal 구분
              if ((userController.userInfo as Member?)!.type == UserType.admin.index) {
                Get.to(const AdminMainPage(), binding: BindingsBuilder(() {
                  Get.put(authController);
                  Get.put(userController);
                  Get.put(adminController);
                }));
              } else if((userController.userInfo as Member?)!.state == false){
                Get.to(const AuthWaitPage(), binding: (BindingsBuilder(((){
                  Get.lazyPut<AuthController>(() => authController);
                  Get.put(userController);
                }))));
              }else{
                Get.to(const AwesomeMainPage(), binding: BindingsBuilder(() {
                  Get.lazyPut<AuthController>(() => authController);
                  Get.put(userController);
                  Get.put(workController);
                }));
              }
            });
          }
      }catch(e){
        e.printError();
        e.printInfo();
        Get.snackbar("Error", "이메일 또는 비밀번호를 확인해주세요", snackPosition: SnackPosition.TOP);
      }
  }


  Future<void> initController() async {
    if (authController.getCurrentUser()!.email != "admin@admin.com"){
      try {
        workController = Get.put(
            WorkController(authController.getCurrentUser()!.uid),
            tag: authController.getCurrentUser()!.uid);
        await Future.wait([
          userController.getUserInfo(authController.getCurrentUser()!.uid),
          workController.getAllWorkList(
              authController.getCurrentUser()!.uid, DateTime.now())
        ]);
      } catch (e) {
        e.printError();
      }
    }else{
      try {
        await Future.wait([
          userController.getUserInfo(authController.getCurrentUser()!.uid),
          adminController.getMemberList(),
          adminController.getNewbieList(),
          adminController.getTodayWorkList(),
          adminController.getVacationList(),
        ]);
      }catch(e){
        e.printError();
      }
    }
  }

  void signUp(){
    Get.to(const SignUpPage(), binding: BindingsBuilder(
    (){
      Get.lazyPut<AuthController>(()=>authController);
    }));
  }

  // void deleteAllWork(){
  //   Get.put(WorkController("temp"), tag:"temp").deleteAllWork();
  // }

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
              margin: const EdgeInsets.symmetric(horizontal: 70),
              child : TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText:"ID",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
              child : TextField(
                  controller: pwController,
                  decoration: const InputDecoration(
                    hintText:"Password",
                  ),
                  obscureText:true,
              ),

            ),
            Container(
              padding:const EdgeInsets.symmetric(horizontal: 30),
              child:Column(
                children: [
                  SizedBox(
                      width:MediaQuery.of(context).size.width*0.5,
                      child:ElevatedButton(onPressed: login,
                          child: const Text("Login")),
                  ),
                  SizedBox(
                      width:MediaQuery.of(context).size.width*0.5,
                      child:ElevatedButton(onPressed: signUp,
                          child: const Text("SignUp")),
                  ),
                ],
              )
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
