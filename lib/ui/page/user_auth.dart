import 'package:awesomethink/controller/auth_controller.dart';
import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/data/provider/auth_provider.dart';
import 'package:awesomethink/data/provider/user_provider.dart';
import 'package:awesomethink/data/repository/user_repo.dart';
import 'package:awesomethink/ui/page/admin_main.dart';
import 'package:awesomethink/ui/page/auth_wait_page.dart';
import 'package:awesomethink/ui/page/login.dart';
import 'package:awesomethink/ui/page/member_main.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


//여기..필요 없을지도..?
class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);



  final AuthController _authController = Get.put(
      AuthController(
          authProvider: UserAuthProvider()
      )
  );

  late final UserController _userController = Get.put(
    UserController(
        userRepository: UserRepository(
          userProvider: UserProvider(),
          currentUser: _authController.getCurrentUser()
        )
    )
  );

  get logger => null;

  @override
  Widget build(BuildContext context) {

    //최근 로그인 기록 보고서 로그인페이지 또는 메인페이지로 이동
    if (_authController.getCurrentUser()?.uid != null) {
      if (_userController.userInfo.state == false) {
        return AuthWaitPage();
      }
      if (_userController.userInfo.type == UserType.admin.index) {
        return AdminMainPage();
      }
      return Container();
    } else {
      return AwesomeThinkLoginPage(title: 'AwesomeThink');
    }
  }
}