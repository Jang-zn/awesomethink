import 'package:awesomethink/controller/auth_controller.dart';
import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/model/work.dart';
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
  late List<Member?> memberList;
  late List<Work?> workList;

  void tempFunc(){  }


  @override
  void initState() {
    userController = Get.find<UserController>();
    workController = Get.find<WorkController>();
    authController = Get.find<AuthController>();
    memberList = userController.memberList;
    workList = workController.weeklyWorkList;
  }

  void newMemberAuthCheck(){
    Get.to(NewMemberAuthPage(),
      binding: BindingsBuilder((){
        Get.put(userController);
        Get.put(workController);
      })
    );

  }

  void logout(){
    authController.signOut();
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
                            Flexible(child: Text("출근")),
                          ]
                      )
                  ),
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
                                    child:Icon(Icons.person),
                                    decoration: BoxDecoration(
                                        border: Border.all(color:Colors.black)
                                    )
                                )
                            ),
                            Flexible(child: Column()),
                            Flexible(child: Text("출근")),
                          ]
                      )
                  ),
                ]

              )
            ),
            Container(
                margin:EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1, top:MediaQuery.of(context).size.width*0.1),
                child:Text("주간 근무 현황",)
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.15,vertical: MediaQuery.of(context).size.width*0.03 ),
                height:MediaQuery.of(context).size.height*0.3,
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
