import 'package:awesomethink/firebase/work_provider.dart';
import 'package:awesomethink/model/work.dart';
import 'package:awesomethink/widget/work_listtile_checkbtn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkListTile extends StatefulWidget {
  late final DocumentSnapshot documentData;
  final WorkProvider workProvider;

  WorkListTile(this.documentData, this.workProvider);

  @override
  _WorkListTileState createState() => _WorkListTileState(documentData:documentData, workProvider: workProvider);
}

class _WorkListTileState extends State<WorkListTile> {
  final WorkProvider workProvider;
  final DocumentSnapshot documentData;
  late int workingTimeState;
  Work? todayWork;
  Work? work;

  _WorkListTileState({required this.documentData, required this.workProvider});


  @override
  void didChangeDependencies() {
    todayWork = workProvider.getTodayWork();
  }

  @override
  Widget build(BuildContext context) {

    if(todayWork?.workUid==null) {
      work=Work.fromJson(documentData.data() as Map<String, dynamic>);
    }else{
      work=todayWork;
    }

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
            WorkListTileCheckBtn(work:work!, workProvider: workProvider,)
          ])
            :
              Container()
        ));
  }
}
