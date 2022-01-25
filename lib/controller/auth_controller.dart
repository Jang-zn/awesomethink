import 'package:awesomethink/data/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class AuthController extends GetxController{
  final UserAuthProvider authProvider = UserAuthProvider();
  Logger logger = Logger();

  final Rxn<User?> _user =  Rxn<User?>(); //FirebaseUser -> User 로 바뀜

  AuthController(){
    _prepareUser();
    logger.d("init UserAuthProvider"+_user.toString());
  }

  _prepareUser() {
    _user.value = authProvider.getCurrentUser();
    _user.refresh();
  }

  //현재유저
  User? getCurrentUser() {
    return _user.value;
  }

  Future<void> signInWithEmail(String email, String password) async {
    _user((await authProvider.signInWithEmail(email, password)).user);
  }

  Future<void> signUpWithEmail(String email, String password) async {
    _user((await authProvider.signUpWithEmail(email, password)).user);
  }


  void signOut() {
    _user(null);
    authProvider.signOut();
  }
}