// ignore_for_file: must_be_immutable

import 'package:awesomethink/controller/admin_controller.dart';
import 'package:awesomethink/data/model/member.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/work.dart';

class VacationListTile extends StatelessWidget {
  Member? member;
  Work? vacation;

  VacationListTile(this.member, this.vacation, {Key? key}) : super(key: key);

  final AdminController adminController = Get.find<AdminController>();

  void acceptVacation() async {
    await adminController.acceptVacation(vacation);
  }

  void rejectVacation() async {
    await adminController.rejectVacation(vacation);
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
                Text(member!.name!),
                const SizedBox(width: 10, height: 10),
                Text(member!.position!),
                const SizedBox(width: 60, height: 10),
                SizedBox(
                  width:60,
                  height:20,
                  child: TextButton(
                    child: const Text("승인",
                        style:TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        )
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      padding:EdgeInsets.zero,
                      backgroundColor: Colors.lightGreen
                    ),
                    onPressed: acceptVacation
                  )
                ),
                SizedBox(
                    width:60,
                    height:20,
                    child: TextButton(
                        child: const Text("반려",
                            style:TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            )
                        ),
                        style: TextButton.styleFrom(
                            primary: Colors.black,
                            padding:EdgeInsets.zero,
                            backgroundColor: Colors.redAccent
                        ),
                        onPressed: rejectVacation
                    )
                )
              ]
            )
          ),
          subtitle: Row(
            children: <Widget>[
              Text(vacation!.getVacationPeriod()),
            ],
          ),
        ),
      ),
    );
  }
}