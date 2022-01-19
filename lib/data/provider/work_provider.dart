import 'package:awesomethink/data/model/work.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class WorkProvider {

  Logger logger = Logger();
  FirebaseFirestore firestore = FirebaseFirestore.instance;



  Work? getCurrentWork(){
    return currentWork;
  }

  Future<bool?> getCurrentVacation() async {
    return await isVacationWait(currentUser?.uid);
  }

  Future<Work?> getCurrentTileWork(DateTime? startTime) async {
    return await getCurrentTileWork(startTime);
  }

  void setCurrentWork(Work? work){
    currentWork=work;
    notifyListeners();
  }

  Future<void> _prepareCurrentWork() async {
    currentWork=await getRecentWork(currentUser?.uid);
    notifyListeners();
  }

  Stream<QuerySnapshot> getWeeklyWorkStream(String uid) {
    //현재 기준으로 지난 월요일 날짜 구하기 (월:1 ~ 일:7)
    DateTime now = DateTime.now();
    DateTime lastMonday = DateTime(now.year, now.month, now.day - (now.weekday-1));
    DateTime thisSunday = DateTime(now.year, now.month, now.day + (7-now.weekday),23,59);
    Query<Map<String, dynamic>> query = firestore.collection("work")
        .where("userUid",isEqualTo: uid)//User id에 해당하는 work들
        .where("startTime", isGreaterThan: lastMonday, isLessThan: thisSunday)//중에서 월~일만 불러옴
        .orderBy("startTime",descending: true);

    return query.snapshots();
  }


  //중복체크... List 길이 이용하면 되네
  Future<bool> checkDuplication(String userUid) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    int total=0;
    await firestore.collection('work')
        .where("userUid",isEqualTo: userUid)
        .where("startTime",isGreaterThanOrEqualTo: today)
        .get()
        .then((snapShot) {
      total = snapShot.docs.length;
    });
    return total==0?true:false;
  }


  //recentWork 호출 -> 휴무대기는 제외
  Future<Work?> getRecentWork(String? userUid) async {
    Work? work;
    await firestore.collection('work')
        .where("userUid",isEqualTo: userUid)
        .where("workingTimeState",isNotEqualTo: WorkingTimeState.vacationWait.index)
        .get()
        .then((snapShot) {
      work = Work.fromJson(snapShot.docs.isNotEmpty?snapShot.docs.first.data():{});
    });
    return work;
  }

  Future<bool?> isVacationWait(String? userUid) async {
    bool? isWait;
    await firestore.collection('work')
        .where("userUid",isEqualTo: userUid)
        .where("workingTimeState",isEqualTo: WorkingTimeState.vacationWait.index)
        .get()
        .then((snapShot) {
      if(snapShot.docs.isNotEmpty){
        isWait=true;
      }else{
        isWait=false;
      }
    });
    return isWait;
  }

  Stream<List<Work>> getWeeklyWorkList(String? uid) {
    //현재 기준으로 지난 월요일 날짜 구하기 (월:1 ~ 일:7)
    DateTime now = DateTime.now();
    DateTime lastMonday = DateTime(now.year, now.month, now.day - (now.weekday-1));
    DateTime thisSunday = DateTime(now.year, now.month, now.day + (7-now.weekday),23,59);

    var query = firestore.collection("work")
        .where("userUid",isEqualTo: uid)//User id에 해당하는 work들
        .where("startTime", isGreaterThan: lastMonday, isLessThan: thisSunday) //중에서 월요일부터 일요일까지
        .orderBy("startTime",descending: true);
    return query.snapshots().map(
            (snapshot) => snapshot.docs.map(
                (doc) => Work
                .fromJson(doc.data())
        ).toList()
    );
  }

  //타일 워크 호출
  Future<Work?> getCurrentTileWork(DateTime? startTime) async {
    Work? work;
    await firestore.collection('work')
        .where("startTime",isEqualTo: startTime)
        .get()
        .then((snapShot) {
      work = Work.fromJson(snapShot.docs.isNotEmpty?snapShot.docs.first.data():{});
    });
    return work;
  }

}