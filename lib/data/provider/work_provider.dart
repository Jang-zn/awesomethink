import 'package:awesomethink/data/model/work.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class WorkProvider {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //uid에 해당하는 유저의 주간 업무일정
  Future<Query<Map<String, dynamic>>> getWeeklyWorkList(String? uid) async{
    //현재 기준으로 지난 월요일 날짜 구하기 (월:1 ~ 일:7)
    DateTime now = DateTime.now();
    DateTime lastMonday = DateTime(now.year, now.month, now.day - (now.weekday-1));
    DateTime thisSunday = DateTime(now.year, now.month, now.day + (7-now.weekday),23,59);

    return firestore.collection("work")
        .where("userUid",isEqualTo: uid)//User id에 해당하는 work들
        .where("startTime", isGreaterThan: lastMonday, isLessThan: thisSunday) //중에서 월요일부터 일요일까지
        .orderBy("startTime",descending: true);
  }

  //uid에 해당하는 유저의 월간 업무일정
  Future<Query<Map<String, dynamic>>> getMonthlyWorkList(String? uid, DateTime dateTime) async{
    DateTime monthFirst = DateTime(dateTime.year, dateTime.month, 1);
    DateTime nextMonthFirst = DateTime(dateTime.year,dateTime.month+1,1);
    DateTime monthLast = DateTime(dateTime.year, dateTime.month, nextMonthFirst.day-1);

    return firestore.collection("work")
        .where("userUid",isEqualTo: uid)//User id에 해당하는 work들
        .where("startTime", isGreaterThan: monthFirst, isLessThan: monthLast) //중에서 1일부터 말일까지
        .orderBy("startTime",descending: true);
  }

  //WorkingTimeState 수정
  Future<void> updateWorkingTimeState(Work? work, int state) async {
    firestore.collection("work")
        .where("startTime",isEqualTo: work!.startTime)
        .get()
        .then((val) {
      val.docs.first.reference.update({"workingTimeState": state});
    }).onError((error, stackTrace) {
      print(stackTrace);
    });
  }

  //Work 생성
  Future<void> setWork(Work? work) async {
    firestore.collection("work").doc().set(work!.toJson()).then((value) {
    }).onError((error, stackTrace) {
      print(stackTrace);
    });
  }

  //Work 수정
  Future<void> updateWork(Work? work) async {
    firestore.collection("work").where("startTime",isEqualTo: work?.startTime)
        .get().then(
        (value){
          value.docs.first.reference.update(work!.toJson())
              .onError((error, stackTrace) {
                print(stackTrace);
              });
        }
    );

  }
}