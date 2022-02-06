import 'package:awesomethink/controller/user_controller.dart';
import 'package:awesomethink/controller/work_controller.dart';
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/ui/component/newbie_listtile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VacationAuthPage extends StatefulWidget {
  const VacationAuthPage({Key? key}) : super(key: key);

  @override
  _VacationAuthPageState createState() => _VacationAuthPageState();
}

class _VacationAuthPageState extends State<VacationAuthPage> {


  late final UserController userController;
  late final WorkController workController;

  @override
  void initState() {
    super.initState();
    userController = Get.find<UserController>();
    workController = Get.find<WorkController>();
  }

  void backPage() {
    Get.back();
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child:Obx(()=>ListView.builder(
                    itemCount: vacationList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index){
                      return VacationListTile(,vacationList[index]);
                    }
                ),)
            )));
  }
}
