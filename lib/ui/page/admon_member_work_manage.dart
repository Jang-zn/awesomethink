// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:awesomethink/controller/admin_controller.dart';
import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/ui/component/work_listtile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkManagePage extends StatefulWidget {
  WorkManagePage(this.uid);
  String? uid;
  @override
  _WorkManagePageState createState() => _WorkManagePageState(uid);
}

class _WorkManagePageState extends State<WorkManagePage> {
  _WorkManagePageState(this.uid);

  late final UserController userController;
  late final WorkController workController;
  late final AdminController adminController;
  String? uid;

  @override
  void initState() {
    super.initState();
    userController = Get.find(tag:uid);
    workController = Get.find(tag:uid);
    adminController = Get.find();
  }


  void backPage() async {
    await adminController.getTodayWorkList();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    print("memeberMain build");
    return Obx(
      () => WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: backPage,
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
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
                  //TODO Tile 만들어주고, 수정/삭제기능 추가
                  // Expanded(
                  //   child: GetBuilder<WorkController>(
                  //     builder: (wc) => ListView.builder(
                  //       shrinkWrap: true,
                  //       itemCount: (wc.weeklyWorkList as List<Work?>).length,
                  //       scrollDirection: Axis.vertical,
                  //       itemBuilder: (context, index) {
                  //         Work? w = wc.weeklyWorkList.value[index];
                  //         //UniqueKey 넣어줘야 완전 새로 빌드됨
                  //         return WorkListTile(
                  //           w,
                  //           key: UniqueKey(),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          onWillPop: null),
    );
  }
}
