import 'package:awesomethink/model/member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserDatabase{

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("user");
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  storeUserData(Member user) async{
    DocumentReference documentReference = userCollection.doc(user.uid);

    var data = user.toJson();

    await documentReference.set(data).whenComplete(() {
      print("User data added");
    }).catchError((e)=>print(e));
  }

  Stream<QuerySnapshot> retrieveUsers(){
    Stream<QuerySnapshot> queryUsers = userCollection
        .orderBy('joinedDate', descending: true)
        .snapshots();

    return queryUsers;
  }

  Iterable<Member> getUserByUid(String uid){
    Iterable<Member> queryUserByUid = userCollection
        .where("uid",isEqualTo: uid)
        .snapshots().map(_snapShotToMember) as Iterable<Member>;

    return queryUserByUid;
  }

  Iterable<Member> _snapShotToMember(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
        return Member(
          uid: doc.get("uid"),
          email: doc.get("email"),
          name:doc.get("name"),
          position: doc.get("position"),
          phone:doc.get("phone"),
          joinedDate: doc.get("joinedDate"),
          retiredDate: doc.get("retiredDate"),
          type: doc.get("type"),
          state:doc.get("state")
        );
      }
    );
  }



}