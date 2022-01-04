import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
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
                  Container(
                      width:MediaQuery.of(context).size.width*0.4,
                      child : const ElevatedButton(
                        onPressed: tempFunction,
                        child: Text("출근"),
                      )
                  ),
                  Container(
                      width:MediaQuery.of(context).size.width*0.4,
                      child : const ElevatedButton(
                        onPressed: tempFunction,
                        child: Text("휴무신청"),
                      )
                  )
                ],
              )
            ),

            //XXX 사원님 이번주 근무시간은 xx시간 xx분, 잔여 의무 근로시간은 xx시간 xx분 남았습니다 멘트치는곳
            Container(
              margin:const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height*0.25,
              decoration: BoxDecoration(
                border: Border.all(color:Colors.black)
              ),
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
            Container(
                margin:const EdgeInsets.symmetric(horizontal: 20,),
                child:Column(
                  children: [
                    Container(
                      margin:EdgeInsets.symmetric(vertical:3),
                      height: MediaQuery.of(context).size.height*0.1,
                      decoration: BoxDecoration(
                          border: Border.all(color:Colors.black)
                      ),
                    ),
                    Container(
                      margin:EdgeInsets.symmetric(vertical:3),
                      height: MediaQuery.of(context).size.height*0.1,
                      decoration: BoxDecoration(
                          border: Border.all(color:Colors.black)
                      ),
                    ),
                    Container(
                      margin:EdgeInsets.symmetric(vertical:3),
                      height: MediaQuery.of(context).size.height*0.1,
                      decoration: BoxDecoration(
                          border: Border.all(color:Colors.black)
                      ),
                    ),
                    Container(
                      margin:EdgeInsets.symmetric(vertical:3),
                      height: MediaQuery.of(context).size.height*0.1,
                      decoration: BoxDecoration(
                          border: Border.all(color:Colors.black)
                      ),
                    ),
                    Container(
                      margin:EdgeInsets.symmetric(vertical:3),
                      height: MediaQuery.of(context).size.height*0.1,
                      decoration: BoxDecoration(
                          border: Border.all(color:Colors.black)
                      ),
                    ),
                  ],
                )
            )
          ],
        )
      )
    );
  }
}

