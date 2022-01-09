import 'package:awesomethink/firebase/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

late AuthPageState pageState;

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() {
    pageState = AuthPageState();
    return pageState;
  }
}

class AuthPageState extends State<AuthPage> {
  late FirebaseProvider fp;

  get logger => null;

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    logger.d("user: ${fp.getUser()}");
    if (fp.getUser() != null && fp.getUser().emailVerified == true) {
      return SignedInPage();
    } else {
      return SignInPage();
    }
  }
}