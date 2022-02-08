// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'dart:math';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/member.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeeklyWorkTile extends StatefulWidget {
  WeeklyWorkTile(this.member, {Key? key}) : super(key: key);
  Member? member;

  @override
  _WeeklyWorkTileState createState() => _WeeklyWorkTileState(member);
}

class _WeeklyWorkTileState extends State<WeeklyWorkTile> {
  Member? member;
  late final WorkController workController;

  _WeeklyWorkTileState(this.member);

  @override
  void initState() {
    super.initState();
    workController = Get.put(WorkController(member!.uid), tag: member!.uid);
    workController.getAllWorkList(member!.uid, DateTime.now());
    workController.getWeeklyWorkingTime();
  }

  void moveDetailPage() {
    Get.snackbar(
      "test",
      "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          color: Color.fromRGBO(200, 240, 200, 1),
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
                  color: Color.fromRGBO(60, 140, 60, 1),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.lime,
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      member!.name!,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      workController.weeklyWorkingTime.value,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                )),
            Material(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromRGBO(200, 240, 200, 1),
              child: InkWell(
                splashColor: Color.fromRGBO(130, 230, 130, 1),
                borderRadius: BorderRadius.circular(15),
                onTap: moveDetailPage,
                child: Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "남은시간",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        workController.requiredWorkingTime.value,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
