import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/ui/component/work_listtile_checkbtn.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:flutter/material.dart';

class WorkListTile extends StatefulWidget {
  WorkListTile(this.work);
  Work? work;
  @override
  _WorkListTileState createState() => _WorkListTileState(work);
}

class _WorkListTileState extends State<WorkListTile> {

  final Work? work;
  _WorkListTileState(this.work);


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child:
          work!=null
              ?
          Stack(children: [
            ListTile(
              title: Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    Text(work!.createTimeToMMDDW()),
                    SizedBox(width: 10, height: 10),
                    Text(work!.workingTimeCalc()),
                  ])),
              subtitle: Row(
                children: <Widget>[
                  Text(work!.workingTimeToHHMM()),
                ],
              ),
            ),
            work!.workingTimeState==WorkingTimeState.wait.index&&work!.endTime!=null
                ?
                  WorkListTileCheckBtn(work:work)
                : Container()
          ])
            :
              Container()
        ));
  }
}
