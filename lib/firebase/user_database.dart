import 'dart:io';

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

  Future<DocumentSnapshot> getUserByUid (String uid) async{
    return await firestore.collection("user").doc(uid).get();
  }


}