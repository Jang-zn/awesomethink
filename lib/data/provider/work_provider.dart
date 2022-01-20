import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class WorkProvider {

  Logger logger = Logger();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Work>> getWeeklyWorkList(String? uid) async{
    //현재 기준으로 지난 월요일 날짜 구하기 (월:1 ~ 일:7)
    DateTime now = DateTime.now();
    DateTime lastMonday = DateTime(now.year, now.month, now.day - (now.weekday-1));
    DateTime thisSunday = DateTime(now.year, now.month, now.day + (7-now.weekday),23,59);

    var query = firestore.collection("work")
        .where("userUid",isEqualTo: uid)//User id에 해당하는 work들
        .where("startTime", isGreaterThan: lastMonday, isLessThan: thisSunday) //중에서 월요일부터 일요일까지
        .orderBy("startTime",descending: true);

    return await query.snapshots().map(
            (snapshot) => snapshot.docs.map(
                (doc) => Work
                .fromJson(doc.data())
        ).toList()
    ).single;
  }

  Future<List<Work>> getMonthlyWorkList(String? uid, DateTime dateTime) async{
    DateTime monthFirst = DateTime(dateTime.year, dateTime.month, 1);
    DateTime nextMonthFirst = DateTime(dateTime.year,dateTime.month+1,1);
    DateTime monthLast = DateTime(dateTime.year, dateTime.month, nextMonthFirst.day-1);

    print(monthFirst.toString());
    print(monthLast.toString());

    var query = firestore.collection("work")
        .where("userUid",isEqualTo: uid)//User id에 해당하는 work들
        .where("startTime", isGreaterThan: monthFirst, isLessThan: monthLast) //중에서 1일부터 말일까지
        .orderBy("startTime",descending: true);

    return await query.snapshots().map(
            (snapshot) => snapshot.docs.map(
                (doc) => Work
                .fromJson(doc.data())
        ).toList()
    ).single;
  }

  bool updateWorkingTimeState(Work? work, int state){
    firestore.collection("work")
        .where("startTime",isEqualTo: work!.startTime)
        .get()
        .then((val) {
      val.docs.first.reference.update({"workingTimeState": state});
      return true;
    });

    print("false 걸림");
    return false;
  }

  // Future<bool?> isVacationWait(String? userUid) async {
  //   bool? isWait;
  //   await firestore.collection('work')
  //       .where("userUid",isEqualTo: userUid)
  //       .where("workingTimeState",isEqualTo: WorkingTimeState.vacationWait.index)
  //       .get()
  //       .then((snapShot) {
  //     if(snapShot.docs.isNotEmpty){
  //       isWait=true;
  //     }else{
  //       isWait=false;
  //     }
  //   });
  //   return isWait;
  // }


  // //타일 워크 호출
  // Future<QuerySnapshot> getCurrentTileWork(DateTime? startTime) async {
  //   return await firestore.collection('work').where("startTime",isEqualTo: startTime).get();
  // }



  // //중복체크... List 길이 이용하면 되네
  // Future<bool> checkDuplication(String userUid) async {
  //   DateTime now = DateTime.now();
  //   DateTime today = DateTime(now.year, now.month, now.day);
  //   int total=0;
  //   await firestore.collection('work')
  //       .where("userUid",isEqualTo: userUid)
  //       .where("startTime",isGreaterThanOrEqualTo: today)
  //       .get()
  //       .then((snapShot) {
  //     total = snapShot.docs.length;
  //   });
  //   return total==0?true:false;
  // }
  //
  //
  // //recentWork 호출 -> 휴무대기는 제외
  // Future<Work?> getRecentWork(String? userUid) async {
  //   Work? work;
  //   await firestore.collection('work')
  //       .where("userUid",isEqualTo: userUid)
  //       .where("workingTimeState",isNotEqualTo: WorkingTimeState.vacationWait.index)
  //       .get()
  //       .then((snapShot) {
  //     work = Work.fromJson(snapShot.docs.isNotEmpty?snapShot.docs.first.data():{});
  //   });
  //   return work;
  // }



}