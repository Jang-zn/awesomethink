// ignore_for_file: avoid_print

import 'package:awesomethink/data/model/work.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkProvider {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
        const Duration(milliseconds: 300),
        () => firestore
            .collection("work")
            .where("userUid", isEqualTo: uid) //User id에 해당하는 work들
            .where("startTime",
                isGreaterThan: lastMonday,
                isLessThan: thisSunday) //중에서 월요일부터 일요일까지
            .orderBy("startTime", descending: true)
            .snapshots());
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getNextWeekWorkList(
      String? uid) async {
    //현재 기준으로 지난 월요일 날짜 구하기 (월:1 ~ 일:7)
    DateTime now = DateTime.now();
    DateTime lastMonday =
    DateTime(now.year, now.month, now.day - (now.weekday - 1));
    DateTime thisSunday =
    DateTime(now.year, now.month, now.day + (7 - now.weekday), 23, 59);
    //다음주처리
    lastMonday.add(const Duration(days:7));
    thisSunday.add(const Duration(days:7));

    return Future.delayed(
        const Duration(milliseconds: 400),
            () => firestore
            .collection("work")
            .where("userUid", isEqualTo: uid) //User id에 해당하는 work들
            .where("startTime",
            isGreaterThan: lastMonday,
            isLessThan: thisSunday) //중에서 월요일부터 일요일까지
            .orderBy("startTime", descending: true)
            .snapshots());
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getPrevWeekWorkList(
      String? uid) async {
    //현재 기준으로 지난 월요일 날짜 구하기 (월:1 ~ 일:7)
    DateTime now = DateTime.now();
    //지난주처리
    DateTime lastMonday =
    DateTime(now.year, now.month, now.day - (now.weekday - 1));
    DateTime thisSunday =
    DateTime(now.year, now.month, now.day + (7 - now.weekday), 23, 59);

    return Future.delayed(
        const Duration(milliseconds: 400),
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
        const Duration(milliseconds: 400),
        () => firestore
            .collection("work")
            .where("userUid", isEqualTo: uid) //User id에 해당하는 work들
            .where("startTime",
                isGreaterThan: monthFirst,
                isLessThan: monthLast) //중에서 1일부터 말일까지
            .orderBy("startTime", descending: true)
            .snapshots());
  }



  //WorkingTimeState 수정
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> updateWorkingTimeState(
      Work? work, int state) async {
    Future.wait([
      firestore
          .collection("work")
          .where("startTime", isEqualTo: work!.startTime)
          .get()
          .then((val) {
        work.workingTimeState = state;
        val.docs.first.reference.set(work.toJson());
      }).onError((error, stackTrace) {
        print(stackTrace);
      })
    ]);
    return await getWeeklyWorkList(work.userUid);
  }

  //Work 생성
  Future<void> setWork(Work? work) async {
    firestore
        .collection("work")
        .doc()
        .set(work!.toJson())
        .onError((error, stackTrace) {
      print(stackTrace);
    });
  }

  //Work 수정
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> updateWork(
      Work? work) async {
    Future.wait([
      firestore
          .collection("work")
          .where("startTime", isEqualTo: work?.startTime)
          .get()
          .then((value) {
        value.docs.first.reference
            .set(work!.toJson())
            .onError((error, stackTrace) {
          print(stackTrace);
        });
      })
    ]);
    return await getWeeklyWorkList(work!.userUid);
  }

  //Work 수정2
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> updateWorkByAdmin(
      Work? work, DateTime start, DateTime end) async {
    Future.wait([
      firestore
          .collection("work")
          .where("startTime", isEqualTo: work?.startTime)
          .get()
          .then((value) {
            work!.startTime=start;
            work.endTime=end;
        value.docs.first.reference
            .set(work.toJson())
            .onError((error, stackTrace) {
          print(stackTrace);
        });
      })
    ]);
    return await getWeeklyWorkList(work!.userUid);
  }

  //Work 삭제
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> deleteWork(
      Work? work) async {
    Future.wait([
      firestore
          .collection("work")
          .where("startTime", isEqualTo: work?.startTime)
          .get()
          .then((value) {
        value.docs.first.reference
            .delete()
            .onError((error, stackTrace) {
          print(stackTrace);
        });
      })
    ]);
    return await getWeeklyWorkList(work!.userUid);
  }


  //uid 로 work정보 가져옴
  Stream<QuerySnapshot<Map<String, dynamic>?>> getWorkByStartTime(Work? work) {
    return firestore
        .collection("work")
        .where("startTime", isEqualTo: work!.startTime)
        .snapshots();
  }

  //uid 로 work정보 가져옴
  Future<QuerySnapshot<Map<String, dynamic>>> getTodayWork(DateTime today) {
    return firestore
        .collection("work")
        .where("startTime", isGreaterThan: today, isLessThan: today.add(const Duration(days:1)))
        .get();
  }
}
