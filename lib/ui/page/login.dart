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
import 'package:shared_preferences/shared_preferences.dart';


import 'admin_main.dart';


class AwesomeThinkLoginPage extends StatefulWidget {
  const AwesomeThinkLoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AwesomeThinkLoginPage> createState() => _AwesomeThinkLoginPageState();
}

class _AwesomeThinkLoginPageState extends State<AwesomeThinkLoginPage> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController pwController = TextEditingController();

  late final AuthController authController;
  late final UserController userController;
  late final WorkController workController;
  late final AdminController adminController;
  late final SharedPreferences _prefs;
  String? _id="";
  String? _pw="";
  bool? _isChecked = false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await _loadId();
    });
    authController = Get.put(AuthController());
    userController = Get.put(UserController());
    adminController = Get.put(AdminController());
  }

  Future<void> _loadId() async {
    _prefs = await SharedPreferences.getInstance(); // 캐시에 저장되어있는 값 호출
    setState(() { // 캐시에 저장된 값을 반영하여 현재 상태를 설정한다.
      // SharedPreferences에 id, pw로 저장된 값을 읽어 필드에 저장. 없을 경우 0으로 대입
      _id = (_prefs.getString('id') ?? '');
      _pw = (_prefs.getString('pw') ?? '');
      _isChecked = _prefs.getBool("isChecked") ?? false;
    });
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
        //체크여부로 preference 저장결정
        if(!_isChecked!){
          print("shared");
          _prefs.setString('id', emailController.text);
          _prefs.setString('pw', pwController.text);
          _prefs.setBool('isChecked', _isChecked!);
        }
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
    emailController.text = _id!;
    pwController.text = _pw!;
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

            //TODO shared_preference 써서 자동로그인 or 로그인정보 저장
            Container(
              padding:const EdgeInsets.symmetric(horizontal: 30),
              child:Column(
                children: [
                  Row(
                    children:[
                      SizedBox(
                        width:MediaQuery.of(context).size.width*0.15
                      ),
                      Checkbox(
                      value: _isChecked,
                      onChanged: (value){
                        setState(() {
                          _isChecked=value;
                        });
                      },
                    ),
                      const Text("로그인정보 저장하기"),
                    ]
                  ),
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
