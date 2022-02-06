import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/member.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/work.dart';

class VacationListTile extends StatelessWidget {
  Member? member;
  Work? vacation;

  VacationListTile(this.member, this.vacation, {Key? key}) : super(key: key);

  final WorkController workController = Get.find<WorkController>();

  //TODO 휴가 승인
  void vacationAuth() async {
    await Future.wait([

    ]);
  }

  //TODO 휴가 반려
  void vacationCancle() async {
    await Future.wait([

    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Container(
            margin:const EdgeInsets.only(bottom:8),
            child:Row(
              children:[
                Text(member!.name!),
                const SizedBox(width: 10, height: 10),
                Text(member!.position!),
                const SizedBox(width: 120, height: 10),
                SizedBox(
                  width:60,
                  height:20,
                  child: TextButton(
                    child: const Text("승인",
                        style:TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        )
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      padding:EdgeInsets.zero,
                      backgroundColor: Colors.lightGreen
                    ),
                    onPressed: vacationAuth
                  )
                ),
                SizedBox(
                    width:60,
                    height:20,
                    child: TextButton(
                        child: const Text("반려",
                            style:TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            )
                        ),
                        style: TextButton.styleFrom(
                            primary: Colors.black,
                            padding:EdgeInsets.zero,
                            backgroundColor: Colors.lightGreen
                        ),
                        onPressed: vacationCancle
                    )
                )
              ]
            )
          ),
          subtitle: Row(
            children: <Widget>[
              Text(newbie!.email!),
              const SizedBox(width: 10, height: 10),
              Text(newbie!.phone!),
            ],
          ),
        ),
      ),
    );
  }
}