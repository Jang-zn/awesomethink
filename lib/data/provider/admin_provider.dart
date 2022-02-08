

import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProvider{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //신규가입 목록
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getNewbieList() async{
    return Future.delayed(const Duration(milliseconds: 500),()=>firestore.collection("user")
        .where("state",isEqualTo: false)
        .snapshots());
  }


  //직원목록
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getMemberList() async {
    return Future.delayed(const Duration(milliseconds: 400),
            ()=>firestore
            .collection("user")
            .where("state",isEqualTo: true)
            .where("type", isEqualTo: UserType.normal.index)
            .orderBy("joinedDate")
            .snapshots());
  }

  //오늘 출근현황
  //오늘 workList 받고, 이거 컨트롤러 가져가서 userUid랑 맞는 user들만 갖다가 띄워준다
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getTodayWorkList() async{
    //오늘날짜
    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year,now.month,now.day);
    DateTime todayEnd = DateTime(now.year,now.month,now.day+1);
    return Future.delayed(const Duration(milliseconds: 500),()=>firestore.collection("work")
        .where("startTime", isGreaterThan: todayStart, isLessThan: todayEnd) //'오늘 근무만 호출'
        .orderBy("startTime",descending: true).snapshots());
  }


  //휴무신청한 리스트 조회
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getVacationList() async {
    return Future.delayed(
        const Duration(milliseconds: 500),
            () => firestore
            .collection("work")
            .where("workingTimeState",
            isEqualTo: WorkingTimeState.vacationWait.index) //휴무신청인거 다가져오기
            .snapshots());
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> acceptVacation(Work? vacation) async {
    await firestore
        .collection("work")
        .where("userUid", isEqualTo: vacation!.userUid)
        .where("workingTimeState",
        isEqualTo: WorkingTimeState.vacationWait.index)
        .get()
        .then(
          (val) {
        for (var doc in val.docs) {
          doc.reference
              .update({"workingTimeState": WorkingTimeState.vacation.index});
        }
      },
    );
    return await getVacationList();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> rejectVacation(Work? vacation) async {
    await firestore
        .collection("work")
        .where("userUid", isEqualTo: vacation!.userUid)
        .where("workingTimeState", isEqualTo: WorkingTimeState.vacationWait.index)
        .get()
        .then(
          (val) {
        for (var doc in val.docs) {
          doc.reference.delete();
        }
      },
    );
    return await getVacationList();
  }


}