import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserProvider{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //가입정보 저장
  Future<void> setUserInfo(Member user) async{
    DocumentReference documentReference = firestore.collection("user").doc(user.uid);
    var data = user.toJson();
    await documentReference.set(data).catchError((e)=>(e));
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