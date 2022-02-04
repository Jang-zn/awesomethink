import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:flutter/material.dart';

class TodayWorkTile extends StatefulWidget {
  TodayWorkTile(this.member, this.work);
  Work? work;
  Member? member;

  @override
  _TodayWorkTileState createState() => _TodayWorkTileState(member, work);
}

class _TodayWorkTileState extends State<TodayWorkTile> {
  Member? member;
  Work? work;
  _TodayWorkTileState(this.member, this.work);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin:EdgeInsets.symmetric(vertical:3),
        padding:EdgeInsets.symmetric(horizontal:5),
        height: MediaQuery.of(context).size.height*0.1,
        decoration: BoxDecoration(border: Border.all(color:Colors.black)
        ),
        child : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Flexible(
                  child: Container(
                      child:Icon(Icons.person,size: MediaQuery.of(context).size.width*0.12,),
                      decoration: BoxDecoration(
                        border: Border.all(color:Colors.black),
                        borderRadius: BorderRadius.circular(100),
                      )
                  )
              ),
              Flexible(child: Column()),
              Flexible(child: Text("출근")),
            ]
        )
    );
  }
}
