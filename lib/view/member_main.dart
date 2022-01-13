import 'package:awesomethink/firebase/firebase_provider.dart';
import 'package:awesomethink/firebase/firebase_provider.dart';
import 'package:awesomethink/firebase/user_database.dart';
import 'package:awesomethink/model/member.dart';
import 'package:awesomethink/model/work.dart';
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
  Stream<QuerySnapshot>? workStream;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool workInOut = false; //false : 퇴근상태 / true : 출근상태
  Work? todayWork;

  void logout() {
    fp!.signOut();
  }

  void startTodayWorkingTime() async{
    todayWork = Work().createWork(fp!.getUser()!.uid);
    workInOut = workInOut==false?true:false;
      //당일 중복등록 못하게 validation
      bool checkDuplication = await UserDatabase().checkDuplication(todayWork!.userUid!);
      //첫출근인경우
      if(checkDuplication) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        //work doc 생성
        firestore.collection("work").doc().set(todayWork!.toJson());

        //한김에 workUid 없는애들 다 넣어줌
        firestore.collection("work")
            .where("workUid",isNull: true)
            .get().then(
                (value) {
              value.docs.forEach((doc) {
                doc.reference.update({"workUid":doc.id});
              });
            }
        );
      //당일에 퇴근후 출근 또누른경우
      }else{
        workInOut=false; //
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 1),
              content: Text("당일 중복등록 불가",
                style:TextStyle(color:Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black,
            )
        );
      }
      setState(() {}); //button 바꾸기 위해 호출 나중에 바꾸든가..
  }

  void endTodayWorkingTime() async{
    //TODO work 관련한건 provider로 교체
    workInOut = workInOut==false?true:false;
    todayWork!.endTime = DateTime.now();
    FirebaseFirestore.instance.collection("work")
        .where("userUid",isEqualTo: todayWork!.userUid)
        .where("endTime",isNull: true).get().then(
            (value) {
              value.docs.forEach((doc) {
                doc.reference.update(todayWork!.toJson());
              });
            }
        );
    //당일에 퇴근후 출근 또누른경우
    setState(() {}); //button 바꾸기 위해 호출 나중에 바꾸든가..
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:MemberMainWidget(),
      key:_scaffoldKey
    );
  }



  Widget MemberMainWidget(){
    print("main state build");
    fp = Provider.of<FirebaseProvider>(context);
    workStream = UserDatabase().getWeeklyWorkStream(fp!.getUser()!.uid);

    Member? user = fp!.getUserInfo();
    return SafeArea(
        child:ListView(
          shrinkWrap: true,
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
                      child :
                        workInOut==false
                            ? ElevatedButton(
                                child: const Text("출근"),
                                onPressed: startTodayWorkingTime,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent,
                                ),
                              )
                            : ElevatedButton(
                                child: const Text("퇴근"),
                                onPressed: endTodayWorkingTime,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                )
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
                        child: const Text("로그아웃"),
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
                    margin:const EdgeInsets.only(bottom: 7),
                    child:Row(
                    children: [
                      Text("${user?.name} ",style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                      Text("${user?.position} 님",style:const TextStyle(fontSize: 18))
                    ],
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                              margin:const EdgeInsets.symmetric(vertical: 4),
                              child:const Text("이번주 근무시간 ")
                          ),
                          //TODO 주간 근무시간 계산로직..
                          Container(
                              margin:const EdgeInsets.symmetric(vertical: 4),
                              child:const Text("00시간 00분",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                              margin:const EdgeInsets.symmetric(vertical: 4),
                              child:const Text("잔여 근로시간 ")
                          ),
                          Container(
                              margin:const EdgeInsets.symmetric(vertical: 4),
                              child:const Text("00시간 00분",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
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
                return Container(
                  margin:const EdgeInsets.symmetric(horizontal: 10),
                  child:ListView(
                    shrinkWrap: true,
                  //ListView안에 ListView 넣을수 있게 설정함. children 크기만큼 높이/길이를 갖게 만든다.
                    children:
                      documentsList.map((eachDocument) => WorkListTile(eachDocument, context)).toList(),
                    )
                );
              },
            )
          ],
        )
      );
  }
}

