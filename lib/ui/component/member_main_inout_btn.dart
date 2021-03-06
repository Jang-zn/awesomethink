// ignore_for_file: no_logic_in_create_state

import 'dart:math';
import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkInOutBtn extends StatefulWidget {
  const WorkInOutBtn({required this.inout, Key? key}) : super(key: key);
  final bool? inout;

  @override
  _WorkInOutBtnState createState() => _WorkInOutBtnState(inout);
}

class _WorkInOutBtnState extends State<WorkInOutBtn> {

  _WorkInOutBtnState(this.inOut);
  bool? inOut;

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    late final WorkController workController=Get.find<WorkController>(tag:userController.userInfo.uid);
    Work? today;
    bool checkDuplication(){
      if((workController.weeklyWorkList as List<Work?>).isEmpty){
        return true;
      }
      int? year = DateTime.now().year;
      int? month = DateTime.now().month;
      int? day = DateTime.now().day;
      bool result = true;
      for(Work? w in workController.weeklyWorkList){
        //중복이면 false 하고 반복 중단
        if(w?.startTime!.year==year&&w?.startTime!.month==month&&w?.startTime!.day==day){
          result = false;
          break;
          //아니면
        }else{
          result = true;
        }
      }
      return result;
    }

    void startTodayWorkingTime() {
      //당일 중복등록 못하게 validation
      bool check = checkDuplication();

      //당일 첫 출근인경우
      if (check) {
        today = Work().createWork(userController.userInfo.uid);
        //work doc 생성
        workController.setWork(today);
        //당일에 퇴근후 출근 또누른경우
      } else {
        Get.snackbar("당일 중복등록 불가", "같은날 기록이 중복될 수 없습니다");
      }
    }

    void endTodayWorkingTime() async {
      //TODO dialog나 snackbar로 확인후 퇴근 처리되게 변경할것
      if(today!=null) {
        today?.endTime = DateTime.now();
        // .add(Duration(
        //     hours: Random().nextInt(8), minutes: Random().nextInt(59)));
        today?.checkOut = true;
        await Future.wait([workController.updateWork(today)]).whenComplete(() {
          setState(() {});
        });
      }else{
        Work? work = await workController.getTodayWork(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
        work?.endTime = DateTime.now().add(Duration(
            hours: Random().nextInt(8), minutes: Random().nextInt(59)));
        work?.checkOut = true;
        await Future.wait([workController.updateWork(work)]).whenComplete(() {
          setState(() {});
        });
      }
    }

    if((workController.weeklyWorkList as List<Work?>).isNotEmpty
        &&(workController.weeklyWorkList as List<Work?>).first!.startTime!.year==DateTime.now().year
        &&(workController.weeklyWorkList as List<Work?>).first!.startTime!.month==DateTime.now().month
        &&(workController.weeklyWorkList as List<Work?>).first!.startTime!.day==DateTime.now().day){
      today = (workController.weeklyWorkList as List<Work?>).first;
    }

    //case 1. 출근기록 X --> list empty
    if((workController.weeklyWorkList as List<Work?>).isEmpty) {
      return ElevatedButton(
        child: const Text("출근"),
        onPressed: startTodayWorkingTime,
        style: ElevatedButton.styleFrom(
          primary: Colors.blueAccent,
        ),
      );
    }

    //case 2. 출근기록 있음 / 근데 퇴근 안누름
    if(!inOut!){
      return ElevatedButton(
          child: const Text("퇴근"),
          onPressed: endTodayWorkingTime,
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          )
      );
    }else {
      //case 3. 출퇴근기록 있음 / 아직 출근버튼 안누름
      return ElevatedButton(
        child: const Text("출근"),
        onPressed: startTodayWorkingTime,
        style: ElevatedButton.styleFrom(
          primary: Colors.blueAccent,
        ),
      );
    }

  }
}

