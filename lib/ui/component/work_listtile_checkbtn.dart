import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkListTileCheckBtn extends StatelessWidget {

  WorkListTileCheckBtn({required this.work});
  Work? work;

  final WorkController workController = Get.find<WorkController>();

  void workingCheck () {
    //TODO 확인창 띄우고 확인하면 체크됨.
    workController.updateWorkingTimeState(work, WorkingTimeState.check.index);
  }

  void getThisWork(){
    for(Work? w in workController.weeklyWorkList){
      if((workController.weeklyWorkList as List<Work?>).isNotEmpty
          &&work!.startTime!.year==w!.startTime!.year
          &&work!.startTime!.month==w.startTime!.month
          &&work!.startTime!.day==w.startTime!.day){
        work = w;
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getThisWork();
    bool isVisible = work!.workingTimeState==0?true:false;
    //휴무일 경우
    if(work!.workingTimeState==WorkingTimeState.vacation.index){
      isVisible=true;
      return Obx(()=>Container(
          margin: EdgeInsets.only(top: 20, left: 250),
          width: 60,
          height: 30,
          child: TextButton(
              child: const Text("휴무",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  )),
              style: TextButton.styleFrom(
                  primary: Colors.red,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.redAccent),
              onPressed: () {
              })));
    }
    //휴무 대기중인경우
    if(work!.workingTimeState==WorkingTimeState.vacationWait.index){
      isVisible=true;
      return Obx(()=>Container(
          margin: EdgeInsets.only(top: 20, left: 250),
          width: 60,
          height: 30,
          child: TextButton(
              child: const Text("대기",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  )),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.orange),
              onPressed: () {
              })));
    }

    if(!isVisible){
      return Container();
    }
    if (work!.workingTimeState== WorkingTimeState.wait.index&&work!.endTime!=null) {
      isVisible=true;
      return Obx(()=>Container(
          margin: EdgeInsets.only(top: 20, left: 250),
          width: 60,
          height: 30,
          child: TextButton(
              child: const Text("확정",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  )),
              style: TextButton.styleFrom(
                  primary: Colors.black,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.lightGreen),
              onPressed: () {
                workingCheck();
              })));
    } else {
      return Container();
    }
  }
}
