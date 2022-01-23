import 'package:awesomethink/data/model/member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserProvider{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //가입정보 저장
  Future<void> setUserInfo(Member user) async{
    DocumentReference documentReference = firestore.collection("user").doc(user.uid);
    var data = user.toJson();
    await documentReference.set(data).catchError((e)=>(e));
  }

  //신규가입 목록
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getNewbieList() async {
    return firestore.collection("user")
        .where("state",isEqualTo: false)
        .snapshots();
  }

  //직원목록
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getMemberList() async {
    return firestore
        .collection("user")
        .where("state",isEqualTo: true)
        .snapshots();
  }

  //uid 로 user정보 가져옴
  Future<DocumentSnapshot> getUserInfoByUid(String? uid) {
    return firestore.collection("user").doc(uid).snapshots().single;
  }

  //user정보 업데이트
  Future<bool?> updateUserInfo(Member? user) async {
    firestore.collection("user").where("uid",isEqualTo: user?.uid)
        .get().then(
            (value){
          value.docs.first.reference.update(user!.toJson())
              .then((value) {
            return true;
          }).onError((error, stackTrace) {
            return false;
          });
        }
    );

  }

}