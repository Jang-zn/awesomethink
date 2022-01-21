import 'package:awesomethink/data/model/member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserProvider{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection = firestore.collection("user");
  late Stream<QuerySnapshot> currentStream = firestore.collection("user").snapshots();

  storeUserData(Member user) async{
    DocumentReference documentReference = userCollection.doc(user.uid);

    var data = user.toJson();

    await documentReference.set(data).whenComplete(() {
    }).catchError((e)=>(e));
  }

  Stream<QuerySnapshot> retrieveUsers(){
    Stream<QuerySnapshot> queryUsers = userCollection
        .orderBy('joinedDate', descending: true)
        .snapshots();

    return queryUsers;
  }


  Future<List<Member?>> getNewbieList() async {
    return await firestore
        .collection("user")
        .where("state",isEqualTo: false)
        .snapshots().map(
            (snapshot) => snapshot.docs.map(
                (doc)=> Member.fromJson(doc.data())
            ).toList()
        ).single;
  }

  Future<List<Member?>> getMemberList() async {
    return await firestore
        .collection("user")
        .where("state",isEqualTo: true)
        .snapshots().map(
            (snapshot) => snapshot.docs.map(
                (doc)=> Member.fromJson(doc.data())
        ).toList()
    ).single;
  }

  Future<DocumentSnapshot> getUserInfoByUid(String? uid) {
    return firestore.collection("user").doc(uid).snapshots().single;
  }

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