import 'dart:async';

import 'package:awesomethink/firebase/work_provider.dart';
import 'package:awesomethink/model/work.dart';
import 'package:awesomethink/widget/work_listtile_checkbtn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkListTile extends StatefulWidget {
  late final DocumentSnapshot documentData;
  final WorkProvider workProvider;

  WorkListTile(this.documentData, this.workProvider);

  @override
  _WorkListTileState createState() => _WorkListTileState(documentData, workProvider);
}

class _WorkListTileState extends State<WorkListTile> {
  final DocumentSnapshot documentData;
  final WorkProvider workProvider;
  Work? thisTileWork;
  Work? currentWork;

  _WorkListTileState(this.documentData, this.workProvider);


  @override
  Widget build(BuildContext context) {
    currentWork = workProvider.getCurrentWork();
    thisTileWork=Work.fromJson(documentData.data() as Map<String, dynamic>);
    try {
      if (currentWork?.workUid != null
          && currentWork?.startTime?.year == thisTileWork?.startTime?.year
          && currentWork?.startTime?.month == thisTileWork?.startTime?.month
          && currentWork?.startTime?.day == thisTileWork?.startTime?.day
          && currentWork?.startTime?.hour == thisTileWork?.startTime?.hour
          && currentWork?.startTime?.minute == thisTileWork?.startTime?.minute
      ) {
        thisTileWork = currentWork;
      }
    }catch(e){
      return Container();
    }

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child:
          thisTileWork!=null
              ?
          Stack(children: [
            ListTile(
              title: Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    Text(thisTileWork!.createTimeToMMDDW()),
                    SizedBox(width: 10, height: 10),
                    Text(thisTileWork!.workingTimeCalc()),
                  ])),
              subtitle: Row(
                children: <Widget>[
                  Text(thisTileWork!.workingTimeToHHMM()),
                ],
              ),
            ),
            WorkListTileCheckBtn(work:thisTileWork!)
          ])
            :
              Container()
        ));
  }
}
