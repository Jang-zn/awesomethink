import 'package:awesomethink/controller/admin_controller.dart';
import 'package:awesomethink/controller/auth_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/ui/component/admin_main_member_weekly_work_tile.dart';
import 'package:awesomethink/ui/component/admin_main_today_work_tile.dart';
import 'package:awesomethink/ui/page/common_login.dart';
import 'package:awesomethink/ui/page/admin_newbie_auth.dart';
import 'package:awesomethink/ui/page/admin_vacation_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  _AdminMainPageState createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  late final AuthController authController;
  late final AdminController adminController;


  @override
  void initState() {
    super.initState();
    adminController = Get.find<AdminController>();
    authController = Get.find<AuthController>();

  }

  void newMemberAuthCheck(){
    Get.to(const NewMemberAuthPage(),
      binding: BindingsBuilder((){
        Get.put(adminController);
      })
    );
  }

  void vacationAuthCheck(){
    Get.to(const VacationAuthPage(),
        binding: BindingsBuilder((){
          Get.put(adminController);
          Get.put(WorkController(authController.getCurrentUser()!.uid));
        })
    );
  }

  void logout() async {
    adminController.onDelete();
    authController.signOut();
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();
    Get.offAll(const AwesomeThinkLoginPage(title: "AwesomeThink"));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>WillPopScope(child: Scaffold(
      appBar: AppBar(
          //뒤로가기 버튼 삭제
          automaticallyImplyLeading: false,
          //타이틀 중앙정렬
          centerTitle: true,
          title:const Text("Awesome Admin",),
        actions: [
          Builder(
             builder: (context) {
                return IconButton(
                  onPressed: (){
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(Icons.menu)
                );
              }
          )],
      ),
      endDrawer: Drawer(
        child:ListView(
          children:[
            ListTile(
              title:const Text("신규가입 신청"),
              onTap: newMemberAuthCheck
            ),
            ListTile(
                title:const Text("휴뮤신청 승인"),
                onTap: vacationAuthCheck
            ),
            ListTile(
                title:const Text("로그아웃"),
                onTap: logout
            )
          ]
        ),
      ),
      body:ListView(
        children:[
          Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children:[
            Container(
              margin:EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1, top:MediaQuery.of(context).size.width*0.03),
              child:const Text("오늘 근무 현황",style:TextStyle(

                fontSize: 20,
              ))
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.15,vertical: MediaQuery.of(context).size.width*0.03 ),
              height:MediaQuery.of(context).size.height*0.4,

              //오늘 근무상태 리스트뷰
              child:ListView.builder(
                  key:UniqueKey(),
                  itemCount: adminController.todayMemberList.length,
                  itemBuilder: (context, index) {
                    Work? work;
                    for(Work? w in adminController.todayWorkList){
                      if(w!.userUid==adminController.todayMemberList[index].uid){
                        work=w;
                        break;
                      }
                    }
                    return TodayWorkTile(adminController.todayMemberList[index], work);
                  }
              )
            ),
            Container(
                margin:EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1, top:MediaQuery.of(context).size.width*0.03),
                child:const Text("주간 근무 현황",style:TextStyle(
                  fontSize: 20,
                ),),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.15,vertical: MediaQuery.of(context).size.width*0.03 ),
                height:MediaQuery.of(context).size.height*0.4,

                //주간 근무시간 현황
                child:ListView.builder(
                  key:UniqueKey(),
                  itemCount:adminController.memberList.length,
                  itemBuilder: (context, index){
                    return WeeklyWorkTile(adminController.memberList[index]);
                  },
                ),
            ),
          ]
        )
      ])
    ),
    onWillPop:null),
    );
  }
}
