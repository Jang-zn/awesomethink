import 'package:awesomethink/controller/auth_controller.dart';
import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/ui/component/member_main_inout_btn.dart';
import 'package:awesomethink/ui/component/member_vacation_btn.dart';
import 'package:awesomethink/ui/component/work_listtile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AwesomeMainPage extends StatelessWidget {
  AwesomeMainPage({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AwesomeMainWidget();
  }
}

class AwesomeMainWidget extends StatefulWidget {
  const AwesomeMainWidget({Key? key}) : super(key: key);


  @override
  _AwesomeMainWidgetState createState() => _AwesomeMainWidgetState();
}


class _AwesomeMainWidgetState extends State<AwesomeMainWidget> {

  //필드
  String weeklyWorkingTime ="0시간 00분";
  String requiredWorkingTime ="40시간 00분";
  //생성자
  _AwesomeMainWidgetState();
  late final AuthController authController;
  late final UserController userController;
  late final WorkController workController;

  @override
  void initState() {
    authController = Get.find<AuthController>();
    userController = Get.find<UserController>();
    workController = Get.find<WorkController>();
    getWorkList();
  }

  Future<void> getWorkList() async{
    await workController.getWeeklyWorkList(userController.userInfo.uid);
    await workController.getMonthlyWorkList(userController.userInfo.uid, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    getWeeklyWorkingTime();
    return Obx(()=>Scaffold(
          body: SafeArea(
        child:Column(
          children: [
            //출퇴근버튼, 휴무신청버튼
            Container(
                padding:const EdgeInsets.only(left: 20, right:20, top:30, bottom:20),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width:MediaQuery.of(context).size.width*0.25,
                        child : WorkInOutBtn()
                    ),

                    SizedBox(
                        width:MediaQuery.of(context).size.width*0.25,
                        child : VacationBtn(context: context)
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

            //XXX 사원님 이번주 근무시간은 xx시간 xx분, 잔여 의무 근로시간은 xx시간 xx분 남았습니다 멘트치는곳
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
                            Text("${userController.userInfo.name} ",style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                            Text("${userController.userInfo.position} 님",style:const TextStyle(fontSize: 18))
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

                            //주간 근무시간 계산후 출력
                            Container(
                                margin:const EdgeInsets.symmetric(vertical: 4),
                                child:Text("${weeklyWorkingTime}",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
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
                                child:Text(requiredWorkingTime,style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
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
                      children:[
                        Text("이번주 근무 현황"),
                        ElevatedButton(onPressed: (){}, child: Text("근태 관리")),
                      ]
                  )
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: (workController.weeklyWorkList as List<Work?>).length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return WorkListTile((workController.weeklyWorkList as List<Work?>)[index]);
                })]
    ))));
  }



  void logout() {
    Get.find<AuthController>().signOut();
  }


  //주단위 시간계산
  void getWeeklyWorkingTime() async{
    print("주간 시간계산");
    //변수
    int weeklyHour=0;
    int weeklyMinute=0;
    int requiredHour=39;
    int requiredMinute=60;
      try {
        for (Work? w in workController.weeklyWorkList!) {
          Map<String, int> timeMap = w!.getWorkingTimeToMap();
          weeklyHour += timeMap["hour"]!;
          weeklyMinute += timeMap["minute"]!;
        }

        // 분 합계가 60분 이상이면 단위 올려줌
        if (weeklyMinute > 59) {
          weeklyHour += (weeklyMinute - weeklyMinute % 60) ~/ 60;
          weeklyMinute = weeklyMinute % 60;
        }

        //requiredHour / Minute 처리
        requiredHour = requiredHour - weeklyHour;
        requiredMinute = requiredMinute - weeklyMinute;
        if (requiredHour < 0) {
          requiredHour = 0;
          requiredMinute = 0;
        }

        if (requiredMinute == 60) {
          requiredMinute = 0;
          requiredHour += 1;
        }


        //출력메세지 세팅
        weeklyMinute > 0 ?
        weeklyWorkingTime =
            weeklyHour.toString() + "시간 " + weeklyMinute.toString() + "분"
            : weeklyWorkingTime =
            weeklyHour.toString() + "시간 " + "0" + weeklyMinute.toString() + "분";
        requiredMinute > 0 ?
        requiredWorkingTime =
            requiredHour.toString() + "시간 " + requiredMinute.toString() + "분"
            : requiredWorkingTime =
            requiredHour.toString() + "시간 " + "0" + requiredMinute.toString() +
                "분";
      }catch(e){
        if (requiredMinute == 60) {
          requiredMinute = 0;
          requiredHour += 1;
        }
        weeklyMinute > 0 ?
        weeklyWorkingTime =
            weeklyHour.toString() + "시간 " + weeklyMinute.toString() + "분"
            : weeklyWorkingTime =
            weeklyHour.toString() + "시간 " + "0" + weeklyMinute.toString() + "분";
        requiredMinute > 0 ?
        requiredWorkingTime =
            requiredHour.toString() + "시간 " + requiredMinute.toString() + "분"
            : requiredWorkingTime =
            requiredHour.toString() + "시간 " + "0" + requiredMinute.toString() +
                "분";
      }
    }
}

