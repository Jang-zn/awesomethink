import 'package:flutter/material.dart';

class TodayWorkTile extends StatefulWidget {
  const TodayWorkTile({Key? key}) : super(key: key);

  @override
  _TodayWorkTileState createState() => _TodayWorkTileState();
}

class _TodayWorkTileState extends State<TodayWorkTile> {
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
