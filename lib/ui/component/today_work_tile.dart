import 'dart:math';

import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:flutter/material.dart';

class TodayWorkTile extends StatefulWidget {
  TodayWorkTile(this.member, this.work, {Key? key}) : super(key: key);
  Work? work;
  Member? member;

  @override
  _TodayWorkTileState createState() => _TodayWorkTileState(member, work);
}

class _TodayWorkTileState extends State<TodayWorkTile> {
  Member? member;
  Work? work;

  _TodayWorkTileState(this.member, this.work);

  Widget? memberState() {
    double? fontSize = 18;
    //출근
    if (work!.endTime == null) {
      return Text(
        "출근",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
            fontSize: fontSize),
      );
    }
    //퇴근하고 확정 안누름
    if (work!.endTime != null&&work!.workingTimeState == WorkingTimeState.wait.index) {
      return Text(
        "확정\n대기",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
            fontSize: fontSize),
      );
    }


    //퇴근
    if (work!.endTime != null &&
        work!.workingTimeState == WorkingTimeState.check.index) {
      return Text(
        "퇴근",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
            fontSize: fontSize),
      );
    }
    //휴무 승인대기
    if (work!.endTime != null &&
        work!.workingTimeState == WorkingTimeState.vacationWait.index) {
      return Text(
        "휴무\n신청",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
            fontSize: fontSize),
      );
    }
    //휴무 승인
    if (work!.endTime != null &&
        work!.workingTimeState == WorkingTimeState.vacation.index) {
      return Text(
        "휴무",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: fontSize),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        color: Color.fromRGBO(Random().nextInt(50), Random().nextInt(200),
            Random().nextInt(255), 0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Icon(
                Icons.person,
                size: MediaQuery.of(context).size.width * 0.12,
                color: Color.fromRGBO(Random().nextInt(50),
                    Random().nextInt(150), Random().nextInt(150), 0.8),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Color.fromRGBO(Random().nextInt(255),
                    Random().nextInt(255), Random().nextInt(255), 0.5),
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    member!.name!,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    work!.workingTimeToHHMM(),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              )),
          Expanded(
            flex: 1,
            child: memberState()!,
          ),
        ],
      ),
    );
  }
}
