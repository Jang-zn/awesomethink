import 'package:awesomethink/utils/time_format_converter.dart';
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
                  //TODO 출퇴근기능
                  SizedBox(
                      width:MediaQuery.of(context).size.width*0.4,
                      child : const ElevatedButton(
                        onPressed: tempFunction,
                        child: Text("출근"),
                      )
                  ),

                  //TODO 휴무신청
                  SizedBox(
                      width:MediaQuery.of(context).size.width*0.4,
                      child : const ElevatedButton(
                        onPressed: tempFunction,
                        child: Text("휴무신청"),
                      )
                  )
                ],
              )
            ),

            //TODO XXX 사원님 이번주 근무시간은 xx시간 xx분, 잔여 의무 근로시간은 xx시간 xx분 남았습니다 멘트치는곳
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

            //TODO 이게 근태현황 넣어줄 위젯 context에서 리스트뷰 써서 컬럼으로 처리해도 된다.
            Container(
                margin:const EdgeInsets.symmetric(horizontal: 20,),
                child:Column(
                  children: [
                    //TODO 근태 Data 처리영역
                    Container(
                      margin:EdgeInsets.symmetric(vertical:3),
                      height: MediaQuery.of(context).size.height*0.1,
                      decoration: BoxDecoration(
                          border: Border.all(color:Colors.black)
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //TODO 출근일, 출근시간 ~ 퇴근시간 찍힐곳
                          Flexible(
                            fit:FlexFit.tight,
                            child:
                              Column(
                                children:[
                                  Text(TimeFormatConverter.dateTimeToMMDDW(DateTime.now())),
                                  Row(
                                    children:[
                                      Text(TimeFormatConverter.dateTimeToHHMM(DateTime.now())),
                                      Text(" ~ "),
                                      Text(TimeFormatConverter.dateTimeToHHMM(DateTime.now().add(const Duration(hours: 3)))),
                                    ]
                                  )
                                ]
                              ),
                          ),

                          //TODO 출-퇴근 시간계산 00시간 00분 형태
                          Flexible(
                              fit:FlexFit.tight,
                              child:
                                Column(
                                  children:[
                                    Text("3시간 00분"),
                                  ]
                                ),
                          ),

                          //TODO '확정' 버튼
                          Flexible(
                              fit:FlexFit.tight,
                              child:
                                Column(
                                  children: const [
                                    ElevatedButton(onPressed: tempFunction, child: Text("확정"))
                                  ],
                                )
                          )
                        ],
                      )
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

