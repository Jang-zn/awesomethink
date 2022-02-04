import 'package:awesomethink/controller/auth_controller.dart';
import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/ui/component/today_work_tile.dart';
import 'package:awesomethink/ui/page/login.dart';
import 'package:awesomethink/ui/page/new_member_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  _AdminMainPageState createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  late final UserController userController;
  late final WorkController workController;
  late final AuthController authController;

  void tempFunc(){  }


  @override
  void initState() {
    userController = Get.find<UserController>();
    authController = Get.find<AuthController>();
    workController = Get.find<WorkController>(tag:userController.userInfo.uid);
  }

  void newMemberAuthCheck(){
    Get.to(NewMemberAuthPage(),
      binding: BindingsBuilder((){
        Get.put(userController);
        Get.put(workController);
      })
    );

  }

  void logout() {
    workController.onDelete();
    userController.onDelete();
    Get.offAll(AwesomeThinkLoginPage(title: "AwesomeThink"),
        binding: BindingsBuilder(() {
          authController.signOut();
          Get.put(authController);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //뒤로가기 버튼 삭제
          automaticallyImplyLeading: false,
          //타이틀 중앙정렬
          centerTitle: true,
          title:Text("Awesome Admin",),
        actions: [
          Builder(
             builder: (context) {
                return IconButton(
                  onPressed: (){
                    print("open");
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(Icons.menu)
                );
              }
          )],
      ),
      endDrawer: Drawer(
        child:ListView(
          children:[
            ListTile(
              title:Text("신규가입 신청"),
              onTap: newMemberAuthCheck
            ),
            ListTile(
                title:Text("로그아웃"),
                onTap: logout
            )
          ]
        ),
      ),
      body:ListView(
        children:[Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children:[
            Container(
              margin:EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1, top:MediaQuery.of(context).size.width*0.1),
              child:Text("오늘 근무 현황",)
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.15,vertical: MediaQuery.of(context).size.width*0.03 ),
              height:MediaQuery.of(context).size.height*0.3,

              //오늘 근무상태 리스트뷰
              child:Obx(()=>ListView.builder(
                  key:UniqueKey(),
                  itemCount: userController.todayMemberList.length,
                  itemBuilder: (context, index) {
                    Work? work;
                    for(Work? w in userController.todayWorkList){
                      if(w!.userUid==userController.todayMemberList[index].uid){
                        work=w;
                        break;
                      }
                    }
                    return TodayWorkTile(userController.todayMemberList[index], work);
                  }
              )
            ),
            ),
            Container(
                margin:EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1, top:MediaQuery.of(context).size.width*0.1),
                child:Text("주간 근무 현황",)
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.15,vertical: MediaQuery.of(context).size.width*0.03 ),
                height:MediaQuery.of(context).size.height*0.3,


                //주간 근무시간 현황
                child:ListView(
                    children:[
                      Container(
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
                            Flexible(child:
                            IconButton(icon:Icon(Icons.arrow_forward_ios), onPressed: tempFunc,)),
                          ]
                        )
                      ),

                    ]

                )
            )
          ]
        )
      ])
    );
  }
}
