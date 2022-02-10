import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateWorkDialog extends StatelessWidget {
  UpdateWorkDialog(this.work, {Key? key}) : super(key: key);
  Work? work;


  late final WorkController workController =
      Get.find<WorkController>(tag: work!.userUid);

  late TextEditingController startHour = TextEditingController(text:work!.startTime!.hour.toString());
  late TextEditingController startMinute = TextEditingController(text:work!.startTime!.minute.toString());
  late TextEditingController endHour = TextEditingController(text:work!.endTime!.hour.toString());
  late TextEditingController endMinute = TextEditingController(text:work!.endTime!.minute.toString());

  Widget getWorkingTimeStateBtn(Work? work) {
    const double left = 20;
    const double top = 0;
    const double fontSize = 13;
    const double width = 60;
    const double height = 25;

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

  Widget acceptBtn() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: 65,
      height: 40,
      child: TextButton(
        child: const Text(
          "확인",
          style: TextStyle(
            color: Colors.black38,
            fontSize: 18,
          ),
        ),
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero, backgroundColor: Colors.lime),
        onPressed: acceptFunction,
      ),
    );
  }

  void acceptFunction() async {
    Map<String, int> dateMap = {
      "startYear" : work!.startTime!.year,
      "startMonth" : work!.startTime!.month,
      "startDay" : work!.startTime!.day,
      "sh" : int.parse(startHour.text),
      "sm" :  int.parse(startMinute.text),
      "endYear" : work!.endTime!.year,
      "endMonth" : work!.endTime!.month,
      "endDay" : work!.endTime!.day,
      "eh" : int.parse(endHour.text),
      "em" : int.parse(endMinute.text),

    };
    if(acceptValidation(dateMap)) {
      DateTime newStartWorkingTime = DateTime(
          dateMap["startYear"]!, dateMap["startMonth"]!, dateMap["startDay"]!, dateMap["sh"]!, dateMap["sm"]!);
      DateTime newEndWorkingTime = DateTime(
          dateMap["endYear"]!, dateMap["endMonth"]!, dateMap["endDay"]!, dateMap["eh"]!, dateMap["em"]!);
      work!.startTime = newStartWorkingTime;
      work!.endTime = newEndWorkingTime;
      await workController.updateWork(work);
      Get.back();
      Get.snackbar("수정완료", "");
    }else{
      Get.snackbar("입력 오류", "시작시간, 종료시간을 확인해주세요", colorText: Colors.red);
    }
  }

  bool acceptValidation(Map<String, int> dateMap){
    // case 1 : 시간 0~24 분 0~59
    if(dateMap["sh"]!<0||dateMap["sh"]!>24){return false;}
    if(dateMap["eh"]!<0||dateMap["eh"]!>24){return false;}
    if(dateMap["sm"]!<0||dateMap["sm"]!>59){return false;}
    if(dateMap["em"]!<0||dateMap["em"]!>59){return false;}
    // case 2 : 시간시작이 종료시간 이후일때 (종료시간이 시작시간 이전일때)
      // 시간비교
    if(dateMap["sh"]!>dateMap["eh"]!){return false;}
      // 같은시간일때 분 비교
    if(dateMap["sh"]==dateMap["eh"] && dateMap["sm"]!>dateMap["em"]!){return false;}

    return true;
  }

  Widget cancleBtn() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: 65,
      height: 40,
      child: TextButton(
        child: const Text(
          "취소",
          style: TextStyle(
            color: Colors.lime,
            fontSize: 18,
          ),
        ),
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero, backgroundColor: Colors.blueGrey),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double textFieldWidth = 33;
    double textFieldHeight = 20;

    return Scaffold(
        backgroundColor: const Color.fromRGBO(50, 50, 50, 0.3),
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(work!.createTimeToMMDDW(),
                        style: const TextStyle(fontSize: 23)),
                    const SizedBox(width: 10, height: 10),
                    Text(work!.workingTimeCalc(),
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: textFieldWidth,
                    height: textFieldHeight,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: startHour,
                    ),
                  ),
                  const Text(" : ", style: TextStyle(fontSize: 18)),
                  SizedBox(
                    width: textFieldWidth,
                    height: textFieldHeight,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: startMinute,
                    ),
                  ),
                  const Text(" ~ ", style: TextStyle(fontSize: 18)),
                  SizedBox(
                    width: textFieldWidth,
                    height: textFieldHeight,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: endHour,
                    ),
                  ),
                  const Text(" : ", style: TextStyle(fontSize: 18)),
                  SizedBox(
                    width: textFieldWidth,
                    height: textFieldHeight,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: endMinute,
                    ),
                  ),
                  getWorkingTimeStateBtn(work!),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  acceptBtn(),
                  cancleBtn(),
                ],
              ),
            ],
          ),
        )));
  }
}
