import 'package:flutter/material.dart';


class AdminMainPage extends StatelessWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminWidget();
  }
}

class AdminWidget extends StatefulWidget {
  const AdminWidget({Key? key}) : super(key: key);

  @override
  _AdminWidgetState createState() => _AdminWidgetState();
}

class _AdminWidgetState extends State<AdminWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child:Column(
          children:[
            //TODO 높이 지정하면 리스트뷰 2개 사용 가능한가?
            Container(
              height:MediaQuery.of(context).size.height*0.35,
              child:ListView(
                children:[
                  Container(
                    margin:EdgeInsets.symmetric(vertical:3),
                    height: MediaQuery.of(context).size.height*0.1,
                    decoration: BoxDecoration(border: Border.all(color:Colors.black)
                    )
                  ),
                  Container(
                      margin:EdgeInsets.symmetric(vertical:3),
                      height: MediaQuery.of(context).size.height*0.1,
                      decoration: BoxDecoration(border: Border.all(color:Colors.black)
                      )
                  ),
                  Container(
                      margin:EdgeInsets.symmetric(vertical:3),
                      height: MediaQuery.of(context).size.height*0.1,
                      decoration: BoxDecoration(border: Border.all(color:Colors.black)
                      )
                  ),
                  Container(
                      margin:EdgeInsets.symmetric(vertical:3),
                      height: MediaQuery.of(context).size.height*0.1,
                      decoration: BoxDecoration(border: Border.all(color:Colors.black)
                      )
                  ),
                ]

              )
            ),
            Container(
                height:MediaQuery.of(context).size.height*0.35,
                child:ListView(
                    children:[
                      Container(
                          margin:EdgeInsets.symmetric(vertical:3),
                          height: MediaQuery.of(context).size.height*0.1,
                          decoration: BoxDecoration(border: Border.all(color:Colors.black)
                          )
                      ),
                      Container(
                          margin:EdgeInsets.symmetric(vertical:3),
                          height: MediaQuery.of(context).size.height*0.1,
                          decoration: BoxDecoration(border: Border.all(color:Colors.black)
                          )
                      ),
                      Container(
                          margin:EdgeInsets.symmetric(vertical:3),
                          height: MediaQuery.of(context).size.height*0.1,
                          decoration: BoxDecoration(border: Border.all(color:Colors.black)
                          )
                      ),
                      Container(
                          margin:EdgeInsets.symmetric(vertical:3),
                          height: MediaQuery.of(context).size.height*0.1,
                          decoration: BoxDecoration(border: Border.all(color:Colors.black)
                          )
                      ),
                    ]

                )
            )
          ]
        )
      )
    );
  }
}
