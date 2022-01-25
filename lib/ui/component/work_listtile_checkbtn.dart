import 'package:awesomethink/controller/tile_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkListTileCheckBtn extends StatefulWidget {
  WorkListTileCheckBtn({Key? key, required this.work}) : super(key: key);
  Work? work;
  @override
  _WorkListTileCheckBtnState createState() => _WorkListTileCheckBtnState(work:work);
}

class _WorkListTileCheckBtnState extends State<WorkListTileCheckBtn> {
  _WorkListTileCheckBtnState({required this.work});
  Work? work;
  late final TileController tileController=Get.put<TileController>(TileController(work), tag:work!.startTime.toString());
  late bool isVisible= tileController.work.value.workingTimeState==WorkingTimeState.check.index?false:true;

  void workingCheck () {
    //TODO 확인창 띄우고 확인하면 체크됨.
    tileController.updateWorkingTimeState(work, WorkingTimeState.check.index);
    Get.put<WorkController>(WorkController(work!.userUid!),tag:work!.userUid).updateWorkingTimeState(work, WorkingTimeState.check.index);
    setState(() {isVisible=false;});
  }


  @override
  Widget build(BuildContext context) {
     print("btn : "+tileController.work.toString());
    //휴무일 경우
    if(tileController.work.value.workingTimeState==WorkingTimeState.vacation.index){
      return Container(
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
              }));
    }
    //휴무 대기중인경우
    if(tileController.work.value.workingTimeState==WorkingTimeState.vacationWait.index){
      return Container(
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
              }));
    }

    if(!isVisible){
      return Container();
    }
    if (tileController.work.value.workingTimeState== WorkingTimeState.wait.index&&tileController.work.value.endTime!=null) {
      return Container(
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
              }));
    } else {
      return Container();
    }
  }
}
