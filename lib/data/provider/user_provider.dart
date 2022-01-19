import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/utils/constants.dart';
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


  Stream<QuerySnapshot> getNewbieStream() {
    return firestore.collection("user").where("state",isEqualTo: false).snapshots();
  }

}