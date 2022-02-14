import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteWorkDialog extends StatelessWidget {
  DeleteWorkDialog(this.work, {Key? key}) : super(key: key);
  Work? work;

  late final WorkController workController =
      Get.find<WorkController>(tag: work!.userUid);

  late TextEditingController startHour =
      TextEditingController(text: work!.startTime!.hour.toString());
  late TextEditingController startMinute =
      TextEditingController(text: work!.startTime!.minute.toString());
  late TextEditingController endHour =
      TextEditingController(text: work!.endTime!.hour.toString());
  late TextEditingController endMinute =
      TextEditingController(text: work!.endTime!.minute.toString());

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
        onPressed: () {
          Get.back(result: true);
        },
      ),
    );
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
          Get.back(result: false);
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
                children: const <Widget>[
                  Text(
                    "근무기록을 삭제하시겠습니까?",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
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
