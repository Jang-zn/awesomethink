import 'dart:math';

import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:flutter/material.dart';

class WeeklyWorkTile extends StatefulWidget {
  WeeklyWorkTile(this.member, {Key? key}) : super(key: key);
  Member? member;

  @override
  _WeeklyWorkTileState createState() => _WeeklyWorkTileState(member);
}

class _WeeklyWorkTileState extends State<WeeklyWorkTile> {
  Member? member;

  _WeeklyWorkTileState(this.member);

  Widget? memberState() {


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        color: Color.fromRGBO(Random(2).nextInt(255), Random().nextInt(255),
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
                color: Color.fromRGBO(Random().nextInt(150),
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
