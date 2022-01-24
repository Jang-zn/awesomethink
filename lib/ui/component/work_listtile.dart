import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/ui/component/work_listtile_checkbtn.dart';
import 'package:flutter/material.dart';


class WorkListTile extends StatelessWidget {
  late final Work? work;

  WorkListTile(this.work);

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
            WorkListTileCheckBtn(work:work!)
          ])
            :
              Container()
        ));
  }
}
