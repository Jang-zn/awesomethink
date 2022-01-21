import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class UserAuthProvider {
  Logger logger = Logger();
  final FirebaseAuth fAuth = FirebaseAuth.instance; //provider 인증 인스턴스
  final FirebaseFirestore firestore = FirebaseFirestore.instance; //firestore 인스턴스


  User? getCurrentUser(){
    print("찾았다 이거지 씨발? : "+fAuth.currentUser.toString());
    return fAuth.currentUser;
  }


  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      await fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on Exception catch (e) {
      logger.e(e.toString());
      return false;
    }
  }


  // 이메일/비밀번호로 Firebase에 로그인
  bool signInWithEmail(String email, String password) {
    try {
      fAuth.signInWithEmailAndPassword(email: email, password: password);
        return true;
    } on Exception catch (e) {
      logger.e(e.toString());
      return false;
    }
  }

  // Firebase로부터 로그아웃
  void signOut() async {
    await fAuth.signOut();
  }


  //TODO
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