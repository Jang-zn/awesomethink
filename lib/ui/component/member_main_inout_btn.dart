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

  late UserController userController;
  late WorkController workController;

  Work? today;
  late bool out;

  bool checkDuplication(){
    if((workController.weeklyWorkList as List<Work?>).isEmpty){
      return true;
    }
    int? year = workController.weeklyWorkList?[0].startTime?.year;
    int? month = workController.weeklyWorkList?[0].startTime?.month;
    int? day = workController.weeklyWorkList?[0].startTime?.day;
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

  void startTodayWorkingTime() async {
    //당일 중복등록 못하게 validation
    bool check = checkDuplication();

    //당일 첫 출근인경우
    if (check) {
      today = Work().createWork(userController.userInfo.uid);
      //work doc 생성
      await workController.setWork(today);
      //당일에 퇴근후 출근 또누른경우
    } else {
      Get.snackbar("당일 중복등록 불가", "같은날 기록이 중복될 수 없습니다");
    }
  }

  void endTodayWorkingTime() {
    //TODO dialog나 snackbar로 확인후 퇴근 처리되게 변경할것
    today?.endTime = DateTime.now();
    workController.updateWork(today);
  }

  //퇴근체크
  void isOut(){
    print("isOut");
    out = true;
    for(Work? w in workController.weeklyWorkList){
      if(w!.endTime==null){
        print(w.toString());
        out = false;
        break;
      }
    }
    print("out "+out.toString());
  }

  @override
  Widget build(BuildContext context) {
    userController = Get.find<UserController>();
    workController = Get.find<WorkController>(tag:userController.userInfo.uid);

    print("inout build");
    if((workController.weeklyWorkList as List<Work?>).isNotEmpty
        &&(workController.weeklyWorkList as List<Work?>).first!.startTime!.year==DateTime.now().year
        &&(workController.weeklyWorkList as List<Work?>).first!.startTime!.month==DateTime.now().month
        &&(workController.weeklyWorkList as List<Work?>).first!.startTime!.day==DateTime.now().day){
      today = (workController.weeklyWorkList as List<Work?>).first;
    }
    isOut();

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

