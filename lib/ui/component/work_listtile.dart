import 'package:awesomethink/controller/tile_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/ui/component/work_listtile_checkbtn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class WorkListTile extends StatelessWidget {
  final Work? work;
  WorkListTile(this.work);


  @override
  Widget build(BuildContext context) {
    TileController tileController=Get.put<TileController>(TileController(work), tag:work!.startTime.toString());

    return Obx(()=>Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child:
          tileController.work.value!=null
              ?
          Stack(children: [
            ListTile(
              title: Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    Text(tileController.work.value.createTimeToMMDDW()),
                    SizedBox(width: 10, height: 10),
                    Text(tileController.work.value.workingTimeCalc()),
                  ])),
              subtitle: Row(
                children: <Widget>[
                  Text(tileController.work.value.workingTimeToHHMM()),
                ],
              ),
            ),
            WorkListTileCheckBtn(work:tileController.work.value)
          ])
            :
              Container()
        )));
  }
}
