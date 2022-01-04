import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SignUpWidget();
  }
}

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController pwCheckController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController rankController = TextEditingController();
  TextEditingController emailController1 = TextEditingController();
  TextEditingController emailController2 = TextEditingController();
  TextEditingController phoneController1 = TextEditingController();
  TextEditingController phoneController2 = TextEditingController();
  TextEditingController phoneController3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 70),
                child: TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    hintText: "ID",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 70),
                child: TextField(
                  controller: pwController,
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 70),
                child: TextField(
                  controller: pwCheckController,
                  decoration: const InputDecoration(
                    hintText: "Password Check",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 70),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Name",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 70),
                child: TextField(
                  controller: rankController,
                  decoration: const InputDecoration(
                    hintText: "직급",
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 70),
                    child: TextField(
                      controller: emailController1,
                      decoration: const InputDecoration(
                        hintText: "Email",
                      ),
                    ),
                  ),
                  Text("@"),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 70),
                    child: TextField(
                      controller: emailController2,
                      decoration: const InputDecoration(
                        hintText: "domain",
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 70),
                    child: TextField(
                      controller: phoneController1,
                    ),
                  ),
                  Text("-"),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 70),
                    child: TextField(
                      controller: phoneController2,
                    ),
                  ),
                  Text("-"),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 70),
                    child: TextField(
                      controller: phoneController3,
                    ),
                  )
                ],
              )
            ],
    )));
  }
}
