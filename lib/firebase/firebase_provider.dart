import 'package:awesomethink/firebase/user_database.dart';
import 'package:awesomethink/model/member.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FirebaseProvider with ChangeNotifier{


  Logger logger = Logger();
  final FirebaseAuth fAuth = FirebaseAuth.instance; //firebase 인증 인스턴스

  User? _user; //FirebaseUser -> User 로 바뀜
  Member? _userInfo; //firestore에 저장된 user 정보

  String _lastFirebaseResponse = ""; //에러처리용 String

  FirebaseProvider() {
    logger.d("init FirebaseProvider");
    _prepareUser();
  }

  _prepareUser(){
    _user = fAuth.currentUser;
    if(_user!=null) {
      setUser(_user);
    }
  }

  void setUser(User? value) {
    _user = value;
  }

  void setUserInfo(Member? value){
    _userInfo = value;
    notifyListeners();
  }

  User? getUser() {
    return _user;
  }

  Member? getUserInfo() {
    return _userInfo;
  }



  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      UserCredential result = await fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        // 새로운 계정 생성이 성공하였으므로 기존 계정이 있을 경우 로그아웃 시킴
        signOut();
        return true;
      }else{
        throw Exception("Sign Failed");
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      return false;
    }
  }


  // 이메일/비밀번호로 Firebase에 로그인
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      var result = await fAuth.signInWithEmailAndPassword(
          email: email, password: password);
        setUser(result.user);
        Member info =await UserDatabase().getUserByUid(result.user!.uid);
        setUserInfo(info);
        logger.d(getUser());
        return true;
    } on Exception catch (e) {
      logger.e(e.toString());
      return false;
    }
  }
  // Firebase로부터 수신한 메시지 설정
  setLastFBMessage(String msg) {
    _lastFirebaseResponse = msg;
  }

  // Firebase로부터 수신한 메시지를 반환하고 삭제
  getLastFBMessage() {
    String returnValue = _lastFirebaseResponse;
    _lastFirebaseResponse = "";
    return returnValue;
  }

  // Firebase로부터 로그아웃
  signOut() async {
    await fAuth.signOut();
    setUser(null);
    setUserInfo(null);
  }

  // // 사용자에게 비밀번호 재설정 메일을 한글로 전송 시도
  // sendPasswordResetEmailByKorean() async {
  //   await fAuth.setLanguageCode("ko");
  //   sendPasswordResetEmail();
  // }
  //
  // // 사용자에게 비밀번호 재설정 메일을 전송
  // sendPasswordResetEmail() async {
  //   var sendPasswordResetEmail = fAuth.sendPasswordResetEmail(
  //       email: getUser().email);
  // }

}