// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/ui/component/admin_work_manage_listtile_delete_dialog.dart';
import 'package:awesomethink/ui/component/admin_work_manage_listtile_dialog.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkManageListTile extends StatefulWidget {
  WorkManageListTile(this.work, {Key? key}) : super(key: key);

  Work? work;

  @override
  _WorkManageListTileState createState() => _WorkManageListTileState(work);
}

class _WorkManageListTileState extends State<WorkManageListTile> {
  _WorkManageListTileState(this.work);

  final Work? work;
  late final WorkController workController =
      Get.find<WorkController>(tag: work?.userUid);

  int? getIndex() {
    for (int i = 0; i < workController.weeklyWorkList.length; i++) {
      if (work?.startTime == workController.weeklyWorkList[i].startTime) {
        return i;
      }
    }
    return null;
  }

  Widget getWorkingTimeStateBtn(Work? work) {
    const double left = 20;
    const double top = 0;
    const double fontSize = 11;
    const double width = 40;
    const double height = 20;

    switch (work!.workingTimeState) {
      //wait
      case 0:
        return Container(
            margin: const EdgeInsets.only(top: top, left: left),
            width: width,
            height: height,
            child: TextButton(
                child: const Text("출근",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    )),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, backgroundColor: Colors.green),
                onPressed: () {}));
      //check
      case 1:
        return Container(
            margin: const EdgeInsets.only(top: top, left: left),
            width: width,
            height: height,
            child: TextButton(
                child: const Text("퇴근",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    )),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, backgroundColor: Colors.blue),
                onPressed: () {}));
      //vacationWait
      case 2:
        return Container(
            margin: const EdgeInsets.only(top: top, left: left),
            width: width,
            height: height,
            child: TextButton(
                child: const Text("휴무신청",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    )),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, backgroundColor: Colors.orange),
                onPressed: () {}));
      //vacation
      default:
        return Container(
            margin: const EdgeInsets.only(top: top, left: left),
            width: width,
            height: height,
            child: TextButton(
                child: const Text("휴무",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    )),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.redAccent),
                onPressed: () {}));
    }
  }

  Widget updateBtn(int? state) {
    if(state==WorkingTimeState.vacation.index||state==WorkingTimeState.wait.index){
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 220),
      width: 45,
      height: 30,
      child: TextButton(
        child: const Text(
          "수정",
          style: TextStyle(
            color: Colors.black38,
            fontSize: 13,
          ),
        ),
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero, backgroundColor: Colors.lime),
        onPressed: () {
          Get.dialog(
            UpdateWorkDialog(work),
          );
        },
      ),
    );
  }

  Widget deleteBtn() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 280),
      width: 45,
      height: 30,
      child: TextButton(
        child: const Text(
          "삭제",
          style: TextStyle(
            color: Colors.lime,
            fontSize: 13,
          ),
        ),
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero, backgroundColor: Colors.blueGrey),
        onPressed: alertDelete,
      ),
    );
  }

  void alertDelete() async {
    bool check = await Get.dialog(DeleteWorkDialog(work));
    if(check){
      workController.deleteWork(work);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: workController.weeklyWorkList[getIndex()] != null
                ? Stack(
                    children: [
                      ListTile(
                        title: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Text(workController.weeklyWorkList[getIndex()]
                                  .createTimeToMMDDW()),
                              const SizedBox(width: 10, height: 10),
                              Text(workController.weeklyWorkList[getIndex()]
                                  .workingTimeCalc()),
                            ],
                          ),
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            Text(workController.weeklyWorkList[getIndex()]
                                .workingTimeToHHMM()),
                            getWorkingTimeStateBtn(
                                workController.weeklyWorkList[getIndex()]),
                          ],
                        ),
                      ),
                      updateBtn(workController.weeklyWorkList[getIndex()]
                          .workingTimeState),
                      deleteBtn(),
                    ],
                  )
                : Container()),
      ),
    );
  }
}
