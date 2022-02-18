// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:awesomethink/controller/auth_controller.dart';
import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/ui/component/member_main_inout_btn.dart';
import 'package:awesomethink/ui/component/member_vacation_btn.dart';
import 'package:awesomethink/ui/component/work_listtile.dart';
import 'package:awesomethink/ui/page/common_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AwesomeMainPage extends StatefulWidget {
  const AwesomeMainPage({Key? key}) : super(key: key);

  @override
  _AwesomeMainPageState createState() => _AwesomeMainPageState();
}

class _AwesomeMainPageState extends State<AwesomeMainPage> {
  late final AuthController authController;
  late final UserController userController;
  late final WorkController workController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
    userController = Get.find<UserController>();
    workController =
        Get.find<WorkController>(tag: authController.getCurrentUser()!.uid);
  }

  void logout() async {
    workController.onDelete();
    userController.onDelete();
    authController.signOut();
    //Firestore 캐시삭제 이거 안하면 다른폰하고 호응 안됨
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();
    Get.offAll(const AwesomeThinkLoginPage(title: "AwesomeThink"));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  //출퇴근버튼, 휴무신청버튼
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 30, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: WorkInOutBtn(
                                inout: workController.inOut, key: UniqueKey())),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.23,
                            child: VacationBtn(context: context)),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: ElevatedButton(
                              onPressed: logout,
                              child: const Text("로그아웃"),
                            )),
                        //TODO 회원정보 페이지로 이동 / 회원정보 수정/탈퇴처리할 수 있는곳 작업 진행
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child:ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue,
                                padding: const EdgeInsets.all(0),
                              ),
                              child:Icon(Icons.person_pin_circle_outlined, size:MediaQuery.of(context).size.width * 0.1,),
                              onPressed: (){},
                          )
                        )
                      ],
                    ),
                  ),

                  //XXX 사원님 이번주 근무시간은 xx시간 xx분, 잔여 의무 근로시간은 xx시간 xx분 남았습니다 멘트치는곳
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height * 0.22,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              child: Row(
                                children: [
                                  Text("${userController.userInfo.name} ",
                                      style: const TextStyle(fontSize: 25)),
                                  Text("${userController.userInfo.position} 님",
                                      style: const TextStyle(fontSize: 18))
                                ],
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: const Text("이번주 근무시간 ")),

                                  //주간 근무시간 계산후 출력
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      "${workController.weeklyWorkingTime.value}",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: const Text("잔여 근로시간 ")),
                                  Container(
                                    key: UniqueKey(),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      workController.requiredWorkingTime.value,
                                      key: UniqueKey(),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )),
                  //근태관리하는곳
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("이번주 근무 현황"),
                        // ElevatedButton(
                        //   onPressed: () {},
                        //   child: const Text("근태 관리"),
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GetBuilder<WorkController>(
                      builder: (wc) => ListView.builder(
                        shrinkWrap: true,
                        itemCount: (wc.weeklyWorkList as List<Work?>).length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          Work? w = wc.weeklyWorkList.value[index];
                          //UniqueKey 넣어줘야 완전 새로 빌드됨
                          return WorkListTile(
                            w,
                            key: UniqueKey(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onWillPop: null),
    );
  }
}
