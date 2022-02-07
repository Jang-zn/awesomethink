import 'package:awesomethink/controller/admin_controller.dart';
import 'package:awesomethink/controller/auth_controller.dart';
import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/ui/component/vacation_listtile.dart';
import 'package:awesomethink/ui/page/admin_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VacationAuthPage extends StatefulWidget {
  const VacationAuthPage({Key? key}) : super(key: key);

  @override
  _VacationAuthPageState createState() => _VacationAuthPageState();
}

class _VacationAuthPageState extends State<VacationAuthPage> {
  late final AdminController adminController;

  @override
  void initState() {
    super.initState();
    adminController = Get.find<AdminController>();
  }

  void backPage() async{
    await Future.wait(
        [FirebaseFirestore.instance.clearPersistence()]);
    Get.offAll(const AdminMainPage(), arguments: "build" ,binding: BindingsBuilder((){
      Get.find<AuthController>();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: backPage,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(children: [
            Text("휴무 신청 현황", style:TextStyle(fontSize: 20)),
            Obx(
              () => Container(
                height: MediaQuery.of(context).size.height*0.7,
                child:ListView.builder(
                  shrinkWrap: true,
                  itemCount: adminController.vacationList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    Member? member;
                    for (Member? m in adminController.memberList) {
                      if (m!.uid ==
                          adminController.vacationList[index].userUid) {
                        member = m;
                        break;
                      }
                    }
                    return VacationListTile(
                        member, adminController.vacationList[index]);
                  }),
            ),),
          ]),
        ),
      ),
    );
  }
}
