import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateWorkDialog extends StatelessWidget {
  UpdateWorkDialog(this.work, {Key? key}) : super(key: key);
  Work? work;
  TextEditingController startHour = TextEditingController();
  TextEditingController startMinute = TextEditingController();
  TextEditingController endHour = TextEditingController();
  TextEditingController endMinute = TextEditingController();

  late final WorkController workController =
      Get.find<WorkController>(tag: work!.userUid);

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
      margin: EdgeInsets.symmetric(horizontal: 15),
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
        onPressed: () {},
      ),
    );
  }

  Widget cancleBtn() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
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
    double textFieldWidth = 20;
    double textFieldHeight = 20;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 150),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(work!.createTimeToMMDDW(), style: TextStyle(fontSize: 23)),
                const SizedBox(width: 10, height: 10),
                Text(work!.workingTimeCalc(), style: TextStyle(fontSize: 18)),
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
                  keyboardType: TextInputType.number,
                  controller: startHour,
                ),
              ),
              Text(" : ", style: TextStyle(fontSize: 18)),
              SizedBox(
                width: textFieldWidth,
                height: textFieldHeight,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: startMinute,
                ),
              ),
              Text(" ~ ", style: TextStyle(fontSize: 18)),
              SizedBox(
                width: textFieldWidth,
                height: textFieldHeight,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: endHour,
                ),
              ),
              Text(" : ", style: TextStyle(fontSize: 18)),
              SizedBox(
                width: textFieldWidth,
                height: textFieldHeight,
                child: TextFormField(
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
    );
  }
}
