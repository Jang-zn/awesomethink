import 'package:awesomethink/controller/auth_controller.dart';
import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/ui/component/member_main_inout_btn.dart';
import 'package:awesomethink/ui/component/member_vacation_btn.dart';
import 'package:awesomethink/ui/component/work_listtile.dart';
import 'package:awesomethink/ui/page/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AwesomeMainPage extends StatelessWidget {
  AwesomeMainPage({
    Key? key,
  }) : super(key: key);

  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  late final WorkController workController =
      Get.find<WorkController>(tag: authController.getCurrentUser()!.uid);

  @override
  Widget build(BuildContext context) {
    void logout() {
      workController.onDelete();
      userController.onDelete();
      Get.offAll(const AwesomeThinkLoginPage(title: "AwesomeThink"),
          binding: BindingsBuilder(() {
        authController.signOut();
        Get.put(authController);
      }));
    }

    return Obx(
      () => Scaffold(
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
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: WorkInOutBtn(inout : workController.inOut,key:UniqueKey())),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: VacationBtn(context: context)),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: ElevatedButton(
                          onPressed: logout,
                          child: const Text("로그아웃"),
                        ))
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25)),
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
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: const Text("이번주 근무시간 ")),

                              //주간 근무시간 계산후 출력
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                    "${workController.weeklyWorkingTime.value}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: const Text("잔여 근로시간 ")),
                              Container(
                                key:UniqueKey(),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child:Text(
                                    workController.requiredWorkingTime.value,
                                    key:UniqueKey(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("이번주 근무 현황"),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("근태 관리"),
                    ),
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
                      return WorkListTile(w, key: UniqueKey(),);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
