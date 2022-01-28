import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/ui/component/work_listtile_checkbtn.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkListTile extends StatefulWidget {
  WorkListTile(this.work, {Key? key}) : super(key: key);
  Work? work;

  @override
  _WorkListTileState createState() => _WorkListTileState(work);
}

class _WorkListTileState extends State<WorkListTile> {
  _WorkListTileState(this.work);

  Work? work;

  @override
  Widget build(BuildContext context) {
    WorkController workController = Get.find<WorkController>();

    int? getIndex(){
      for(int i=0;i<workController.weeklyWorkList.length;i++){
        if(work!.startTime == workController.weeklyWorkList[i].startTime){
          return i;
        }
      }
    }


    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: workController.weeklyWorkList[getIndex()] != null
                ? Stack(
                    children: [
                      ListTile(
                        title: Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Text(workController.weeklyWorkList[getIndex()].createTimeToMMDDW()),
                              SizedBox(width: 10, height: 10),
                              Text(workController.weeklyWorkList[getIndex()].workingTimeCalc()),
                            ],
                          ),
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            Text(workController.weeklyWorkList[getIndex()].workingTimeToHHMM()),
                          ],
                        ),
                      ),
                      workController.weeklyWorkList[getIndex()].workingTimeState == WorkingTimeState.wait.index &&
                          workController.weeklyWorkList[getIndex()].endTime != null
                          ? WorkListTileCheckBtn(work: workController.weeklyWorkList[getIndex()])
                          : Container()
                    ],
                  )
                : Container()),
      ),
    );
  }
}
