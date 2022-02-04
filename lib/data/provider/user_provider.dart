import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/provider/contant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserProvider{
  final FirebaseFirestore firestore = ProviderConstance.firestore;

  //가입정보 저장
  Future<void> setUserInfo(Member user) async{
    DocumentReference documentReference = firestore.collection("user").doc(user.uid);
    var data = user.toJson();
    await documentReference.set(data).catchError((e)=>(e));
  }

  //신규가입 목록
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getNewbieList() async{
    return Future.delayed(const Duration(milliseconds: 500),()=>firestore.collection("user")
        .where("state",isEqualTo: false)
        .snapshots());
  }


  //직원목록
  Stream<QuerySnapshot<Map<String, dynamic>?>> getMemberList() {
    return firestore
        .collection("user")
        .where("state",isEqualTo: true)
        .snapshots();
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



  //uid 로 user정보 가져옴
  Stream<QuerySnapshot<Map<String, dynamic>?>> getUserInfoByUid(String? uid) {
    return firestore.collection("user")
        .where("uid",isEqualTo: uid)
        .snapshots();
  }

  //user정보 업데이트
  Future<void> updateUserInfo(Member? user) async {
    firestore.collection("user").where("uid",isEqualTo: user?.uid)
        .get().then(
            (value){
          value.docs.first.reference.update(user!.toJson())
              .then((value) {
          }).onError((error, stackTrace) {
          });
        }
    );

  }

}