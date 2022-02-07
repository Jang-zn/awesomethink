

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
    return Future.delayed(Duration(milliseconds: 400),
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

  //uid에 해당하는 유저의 주간 업무일정
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getWeeklyWorkList(
      String? uid) async {
    //현재 기준으로 지난 월요일 날짜 구하기 (월:1 ~ 일:7)
    DateTime now = DateTime.now();
    DateTime lastMonday =
    DateTime(now.year, now.month, now.day - (now.weekday - 1));
    DateTime thisSunday =
    DateTime(now.year, now.month, now.day + (7 - now.weekday), 23, 59);
    return Future.delayed(
        const Duration(milliseconds: 500),
            () => firestore
            .collection("work")
            .where("userUid", isEqualTo: uid) //User id에 해당하는 work들
            .where("startTime",
            isGreaterThan: lastMonday,
            isLessThan: thisSunday) //중에서 월요일부터 일요일까지
            .orderBy("startTime", descending: true)
            .snapshots());
  }

  //uid에 해당하는 유저의 월간 업무일정
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getMonthlyWorkList(
      String? uid, DateTime dateTime) {
    DateTime monthFirst = DateTime(dateTime.year, dateTime.month, 1);
    DateTime nextMonthFirst = DateTime(dateTime.year, dateTime.month + 1, 1);
    DateTime monthLast =
    DateTime(dateTime.year, dateTime.month, nextMonthFirst.day - 1);

    return Future.delayed(
        const Duration(milliseconds: 500),
            () => firestore
            .collection("work")
            .where("userUid", isEqualTo: uid) //User id에 해당하는 work들
            .where("startTime",
            isGreaterThan: monthFirst,
            isLessThan: monthLast) //중에서 1일부터 말일까지
            .orderBy("startTime", descending: true)
            .snapshots());
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