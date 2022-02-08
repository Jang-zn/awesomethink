import 'package:awesomethink/controller/admin_controller.dart';
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/ui/component/newbie_listtile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewMemberAuthPage extends StatefulWidget {
  const NewMemberAuthPage({Key? key}) : super(key: key);

  @override
  _NewMemberAuthPageState createState() => _NewMemberAuthPageState();
}

class _NewMemberAuthPageState extends State<NewMemberAuthPage> {
  late List<Member?> newbieList;
  late final AdminController adminController;

  @override
  void initState() {
    super.initState();
    adminController = Get.find<AdminController>();
    newbieList = adminController.newbieList;
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
          child: Column(
            children: [
              const Text("신규 가입 신청", style:TextStyle(fontSize: 20)),
              Obx(
                () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: newbieList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return NewbieListTile(newbieList[index]);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
