

import 'package:awesomethink/model/work.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkListTile extends StatelessWidget {
  late final DocumentSnapshot documentData;
  WorkListTile(this.documentData);

  // //firestore data update 과정
  // //Stream이라서 업데이트 되면 알아서 화면에서 지워짐
  // void newbieAuth(){
  //   print(documentData["email"]);
  //   FirebaseFirestore.instance.collection("user").where("email", isEqualTo:documentData["email"]).get()
  //       .then((val){
  //     val.docs.forEach(
  //             (element) {
  //           element.reference.update({"state":true});
  //         });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Work work = Work.fromJson((documentData.data()) as Map<String, dynamic>);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Container(
              margin:EdgeInsets.only(bottom:8),
              child:Row(
                  children:[
                    Text(work.createTimeToMMDDW()),
                    SizedBox(width: 10, height: 10),
                    Text(work.workingTimeCalc()),
                    SizedBox(width: 120, height: 10),
                    Container(
                        width:60,
                        height:20,
                        child: TextButton(
                            child: const Text("확정",
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
                            onPressed: (){}
                        )
                    )
                  ]
              )
          ),
          subtitle: Row(
            children: <Widget>[
              Text(work.workingTimeToHHMM()),
            ],
          ),
        ),
      ),
    );
  }
}