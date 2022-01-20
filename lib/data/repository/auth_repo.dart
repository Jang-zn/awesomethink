
import 'package:awesomethink/data/model/member.dart';
import 'package:awesomethink/data/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthRepository{
  final UserAuthProvider authProvider;
  Logger logger = Logger();
  User? _user; //FirebaseUser -> User 로 바뀜

  AuthRepository({required this.authProvider}){
    _prepareUser();
    logger.d("init UserAuthProvider"+_user.toString());
  }

  _prepareUser() {
    _user = authProvider.getCurrentUser();
  }

  //현재유저
  User? getCurrentUser() {
    return _user;
  }




  void signInWithEmail(String email, String password) {
    bool result = authProvider.signInWithEmail(email, password);
    if(result) {
      _user = authProvider.getCurrentUser();
    }else{
      throw Exception("Sign Failed");
    }
  }

  void signUpWithEmail(String email, String password) async {
    bool result = await authProvider.signUpWithEmail(email, password);
    if (result) {
      // 새로운 계정 생성이 성공하였으므로 기존 계정이 있을 경우 로그아웃 시킴
      signOut();
    }else{
      throw Exception("Sign Failed");
    }
  }


  void signOut() {
    _user=null;
    authProvider.signOut();
  }
}