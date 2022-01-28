import 'dart:math';
import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkInOutBtn extends StatefulWidget {
  const WorkInOutBtn({Key? key}) : super(key: key);

  @override
  _WorkInOutBtnState createState() => _WorkInOutBtnState();
}

class _WorkInOutBtnState extends State<WorkInOutBtn> {
  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    late final WorkController workController=Get.find<WorkController>(tag:userController.userInfo.uid);

    Work? today;
    bool? out;

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
      //bool check = checkDuplication();

      //당일 첫 출근인경우
      if (true) {
        today = Work().createWork(userController.userInfo.uid);
        //work doc 생성
        Future.wait([workController.setWork(today)]);
        //당일에 퇴근후 출근 또누른경우
      } else {
        Get.snackbar("당일 중복등록 불가", "같은날 기록이 중복될 수 없습니다");
      }
    }

    void endTodayWorkingTime() async {
      //TODO dialog나 snackbar로 확인후 퇴근 처리되게 변경할것
      //TODO endTime -> DateTime.now로 바꿔야됨 지금은 임시로 랜덤줌
      today?.endTime = DateTime.now().add(Duration(hours: Random().nextInt(8), minutes: Random().nextInt(59)));
      today?.checkOut=true;
      await Future.wait([workController.updateWork(today)]).whenComplete(() {
        setState(() {});
      });
    }

    bool isOut(){
      for(Work? w in workController.weeklyWorkList){
        if(w!.checkOut==false){
          return false;
        }
      }
      return true;
    }


    print("inout build");
    print("hash : "+workController.hashCode.toString());
    out = isOut();
    if((workController.weeklyWorkList as List<Work?>).isNotEmpty
        &&(workController.weeklyWorkList as List<Work?>).first!.startTime!.year==DateTime.now().year
        &&(workController.weeklyWorkList as List<Work?>).first!.startTime!.month==DateTime.now().month
        &&(workController.weeklyWorkList as List<Work?>).first!.startTime!.day==DateTime.now().day){
      today = (workController.weeklyWorkList as List<Work?>).first;
    }

    //case 1. 출근기록 X --> list empty
    if((workController.weeklyWorkList as List<Work?>).isEmpty) {
      print("case1");
      return ElevatedButton(
        child: const Text("출근"),
        onPressed: startTodayWorkingTime,
        style: ElevatedButton.styleFrom(
          primary: Colors.blueAccent,
        ),
      );
    }

    //case 2. 출근기록 있음 / 근데 퇴근 안누름
    if(!out){
      print("case2");
      return ElevatedButton(
          child: const Text("퇴근"),
          onPressed: endTodayWorkingTime,
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          )
      );
    }else {
      //case 3. 출퇴근기록 있음 / 아직 출근버튼 안누름
      print("case3");
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

