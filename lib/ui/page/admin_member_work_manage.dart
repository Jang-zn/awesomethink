// ignore_for_file: prefer_const_literals_to_create_immutables, must_be_immutable, no_logic_in_create_state
import 'package:awesomethink/controller/admin_controller.dart';
import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/ui/component/admin_work_manage_listtile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkManagePage extends StatefulWidget {
  WorkManagePage(this.uid, {Key? key}) : super(key: key);
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

  void prevWeek()async {
    await workController.getPrevWeekWorkList(uid);
  }

  void nextWeek() async {
    try {
      await workController.getNextWeekWorkList(uid);
    }catch(e){
      e.printError();
    }
  }

  void thisWeek() async {
    await workController.getWeeklyWorkList(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
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
                  //XXX ????????? ????????? ??????????????? xx?????? xx???, ?????? ?????? ??????????????? xx?????? xx??? ??????????????? ???????????????
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
                                  Text("${userController.userInfo.position} ???",
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
                                      child: const Text("?????? ???????????? ")),

                                  //?????? ???????????? ????????? ??????
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
                                      child: const Text("?????? ???????????? ")),
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
                  //?????????????????????
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex:1,
                          child:IconButton(
                            icon: const Icon(Icons.arrow_left),
                            onPressed: prevWeek,
                          ),
                        ),
                        Expanded(
                          flex:4,
                          child: Text("${workController.startWeekDay}  ~  ${workController.endWeekDay}"),
                        ),
                        Expanded(
                          flex: 1,
                          child:IconButton(
                            icon: const Icon(Icons.calendar_today_rounded),
                            onPressed: thisWeek,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child:IconButton(
                            icon: const Icon(Icons.arrow_right),
                            onPressed: nextWeek,
                          ),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {},
                        //   child: const Text("?????? ??????"),
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GetBuilder<WorkController>(
                      tag:uid,
                      builder: (wc) => ListView.builder(
                        shrinkWrap: true,
                        itemCount: (wc.weeklyWorkList as List<Work?>).length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          Work? w = wc.weeklyWorkList.value[index];
                          //UniqueKey ???????????? ?????? ?????? ?????????
                          return WorkManageListTile(
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
