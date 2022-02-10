import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateWorkDialog extends StatelessWidget {
  UpdateWorkDialog(this.work, {Key? key}) : super(key: key);
  Work? work;

  late final WorkController workController =
      Get.find<WorkController>(tag: work!.userUid);

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

  Widget acceptBtn() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 180),
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
          Get.dialog(UpdateWorkDialog(work));
        },
      ),
    );
  }

  Widget cancleBtn() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 240),
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
        onPressed: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      backgroundColor: Colors.grey,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Stack(
            children: [
              ListTile(
                title: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text(work!.createTimeToMMDDW()),
                      const SizedBox(width: 10, height: 10),
                      Text(work!.workingTimeCalc()),
                    ],
                  ),
                ),
                subtitle: Row(
                  children: <Widget>[
                    Text(work!.workingTimeToHHMM()),
                    getWorkingTimeStateBtn(work!),
                  ],
                ),
              ),
              acceptBtn(),
              cancleBtn(),
            ],
          ),
        ),
      ),
    );
  }
}
