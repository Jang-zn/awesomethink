import 'package:awesomethink/firebase/firebase_provider.dart';
import 'package:awesomethink/firebase/user_database.dart';
import 'package:awesomethink/model/member.dart';
import 'package:awesomethink/model/work.dart';
import 'package:awesomethink/utils/time_format_converter.dart';
import 'package:awesomethink/widget/work_listtile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AwesomeMainPage extends StatelessWidget {
  const AwesomeMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AwesomeMainWidget();
  }
}

class AwesomeMainWidget extends StatefulWidget {
  const AwesomeMainWidget({Key? key}) : super(key: key);

  @override
  _AwesomeMainWidgetState createState() => _AwesomeMainWidgetState();
}

void tempFunction(){

}


class _AwesomeMainWidgetState extends State<AwesomeMainWidget> {

  FirebaseProvider? fp;

  void logout(){
    fp!.signOut();
  }

  void setTodayWorkingTime(){
    Work work = Work().createWork(fp!.getUser()!.uid);
    print(work.toString());
    FirebaseFirestore.instance.collection("work").doc()
        .set(work.toJson());
  }


  @override
  Widget build(BuildContext context) {
    print("main state build");
    fp = Provider.of<FirebaseProvider>(context);
    Stream<QuerySnapshot> workStream = UserDatabase().getWeeklyWorkStream(fp!.getUser()!.uid);

    Member? user = fp!.getUserInfo();


    return Scaffold(
      body:SafeArea(
        child:ListView(
          children: [
            //출퇴근버튼, 휴무신청버튼
            Container(
              padding:const EdgeInsets.only(left: 20, right:20, top:30, bottom:20),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //TODO 출퇴근기능
                  SizedBox(
                      width:MediaQuery.of(context).size.width*0.25,
                      child : ElevatedButton(
                        child: Text("출근"),
                        onPressed: setTodayWorkingTime,
                      )
                  ),

                  //TODO 휴무신청
                  SizedBox(
                      width:MediaQuery.of(context).size.width*0.25,
                      child : const ElevatedButton(
                        onPressed: tempFunction,
                        child: Text("휴무신청"),
                      )
                  ),
                  SizedBox(
                      width:MediaQuery.of(context).size.width*0.25,
                      child : ElevatedButton(
                        onPressed: logout,
                        child: Text("로그아웃"),
                      )
                  )
                ],
              )
            ),

            //TODO XXX 사원님 이번주 근무시간은 xx시간 xx분, 잔여 의무 근로시간은 xx시간 xx분 남았습니다 멘트치는곳
            Container(
              margin:const EdgeInsets.symmetric(horizontal: 20),
              padding:const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height*0.22,
              decoration: BoxDecoration(
                border: Border.all(color:Colors.grey)
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:EdgeInsets.only(bottom: 7),
                    child:Row(
                    children: [
                      Text("${user?.name} ",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                      Text("${user?.position} 님",style:TextStyle(fontSize: 18))
                    ],
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                              margin:EdgeInsets.symmetric(vertical: 4),
                              child:Text("이번주 근무시간 ")
                          ),
                          //TODO 주간 근무시간 계산로직..
                          Container(
                              margin:EdgeInsets.symmetric(vertical: 4),
                              child:Text("00시간 00분",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                              margin:EdgeInsets.symmetric(vertical: 4),
                              child:Text("잔여 근로시간 ")
                          ),
                          Container(
                              margin:EdgeInsets.symmetric(vertical: 4),
                              child:Text("00시간 00분",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                          )
                        ],
                      )
                    ]
                    ,),
                ],
              )
            ),



            //근태관리하는곳
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical:10),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children:const [
                 Text("이번주 근무 현황"),
                 ElevatedButton(onPressed: tempFunction, child: Text("근태관리")),
               ]
              )
            ),

            StreamBuilder(
              stream:workStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(!snapshot.hasData){
                  return Container();
                }
                List<DocumentSnapshot> documentsList = snapshot.data!.docs;
                return ListView(

                  //ListView안에 ListView 넣을수 있게 설정함. children 크기만큼 높이/길이를 갖게 만든다.
                  shrinkWrap: true,

                  children:
                    documentsList.map((eachDocument) => WorkListTile(eachDocument)).toList(),
                );
              },
            )
          ],
        )
      )
    );
  }
}

