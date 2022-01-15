import 'package:awesomethink/firebase/firebase_provider.dart';
import 'package:awesomethink/firebase/user_database.dart';
import 'package:awesomethink/firebase/work_provider.dart';
import 'package:awesomethink/model/member.dart';
import 'package:awesomethink/widget/member_main_inout_btn.dart';
import 'package:awesomethink/widget/work_listtile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AwesomeMainPage extends StatelessWidget {
  AwesomeMainPage({Key? key, required this.firebaseProvider}) : super(key: key);

  final FirebaseProvider firebaseProvider;


  @override
  Widget build(BuildContext context) {
    return AwesomeMainWidget(firebaseProvider:firebaseProvider);
  }
}

class AwesomeMainWidget extends StatefulWidget {
  const AwesomeMainWidget({Key? key, required this.firebaseProvider}) : super(key: key);
  final FirebaseProvider firebaseProvider;

  @override
  _AwesomeMainWidgetState createState() => _AwesomeMainWidgetState(firebaseProvider);
}

void tempFunction(){

}


class _AwesomeMainWidgetState extends State<AwesomeMainWidget> {

  final FirebaseProvider firebaseProvider;
  WorkProvider? workProvider;
  Stream<QuerySnapshot>? workStream;


  _AwesomeMainWidgetState(this.firebaseProvider);


  //스트림 init에 쳐넣어놔서 반영 안됐는데 이제 되네,..
  @override
  void didChangeDependencies() {
    workStream = UserDatabase().getWeeklyWorkStream(firebaseProvider.getUserInfo()!.uid!);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          body:MemberMainWidget(firebaseProvider, context, workStream),
    );
  }

  Widget MemberMainWidget(FirebaseProvider? firebaseProvider, BuildContext context, Stream<QuerySnapshot>? workStream){
    Member? user = firebaseProvider!.getUserInfo();

    void logout() {
      firebaseProvider.signOut();
    }

    return SafeArea(
        child:Column(
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
                        child : WorkInOutBtn(firebaseProvider: firebaseProvider, buildContext: context,)
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
                switch(snapshot.connectionState) {
                  case ConnectionState.waiting :
                    return Container();
                  default :
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    //리스트로 불러와서 처리할 snapshot 가져옴
                    List<DocumentSnapshot> documentsList = snapshot.data!.docs;
                    List<WorkListTile> tileList = documentsList.map((
                        eachDocument) => WorkListTile(eachDocument, context))
                        .toList();
                    return Expanded(child:
                    ListView.builder(
                        itemCount: tileList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return tileList[index];
                        }
                    ));
                }
                }
            )
          ],
        )
    );
  }

}

