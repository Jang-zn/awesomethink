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

  void tempFunc(){  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //뒤로가기 버튼 삭제
          automaticallyImplyLeading: false,
          //타이틀 중앙정렬
          centerTitle: true,
          title:Text("Awesome Admin",),
        actions: [IconButton(onPressed: tempFunc, icon: Icon(Icons.menu))],
      ),
      body:ListView(
        children:[Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children:[
            Container(
              margin:EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1, top:MediaQuery.of(context).size.width*0.1),
              child:Text("오늘 근무 현황",)
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.15,vertical: MediaQuery.of(context).size.width*0.03 ),
              height:MediaQuery.of(context).size.height*0.3,
              child:ListView(
                children:[
                  Container(
                      margin:EdgeInsets.symmetric(vertical:3),
                      padding:EdgeInsets.symmetric(horizontal:5),
                      height: MediaQuery.of(context).size.height*0.1,
                      decoration: BoxDecoration(border: Border.all(color:Colors.black)
                      ),
                      child : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Flexible(
                              child: Container(
                                child:Icon(Icons.person,size: MediaQuery.of(context).size.width*0.12,),
                                decoration: BoxDecoration(
                                  border: Border.all(color:Colors.black),
                                  borderRadius: BorderRadius.circular(100),
                                )
                              )
                            ),
                            Flexible(child: Column()),
                            Flexible(child: Text("출근")),
                          ]
                      )
                  ),
                  Container(
                      margin:EdgeInsets.symmetric(vertical:3),
                      padding:EdgeInsets.symmetric(horizontal:5),
                      height: MediaQuery.of(context).size.height*0.1,
                      decoration: BoxDecoration(border: Border.all(color:Colors.black)
                      ),
                      child : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Flexible(
                                child: Container(
                                    child:Icon(Icons.person),
                                    decoration: BoxDecoration(
                                        border: Border.all(color:Colors.black)
                                    )
                                )
                            ),
                            Flexible(child: Column()),
                            Flexible(child: Text("출근")),
                          ]
                      )
                  ),
                ]

              )
            ),
            Container(
                margin:EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1, top:MediaQuery.of(context).size.width*0.1),
                child:Text("주간 근태 현황",)
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.15,vertical: MediaQuery.of(context).size.width*0.03 ),
                height:MediaQuery.of(context).size.height*0.3,
                child:ListView(
                    children:[
                      Container(
                          margin:EdgeInsets.symmetric(vertical:3),
                          padding:EdgeInsets.symmetric(horizontal:5),
                          height: MediaQuery.of(context).size.height*0.1,
                          decoration: BoxDecoration(border: Border.all(color:Colors.black)
                          ),
                        child : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                              Flexible(
                                  child: Container(
                                      child:Icon(Icons.person,size: MediaQuery.of(context).size.width*0.12,),
                                      decoration: BoxDecoration(
                                        border: Border.all(color:Colors.black),
                                        borderRadius: BorderRadius.circular(100),
                                      )
                                  )
                              ),
                            Flexible(child: Column()),
                            Flexible(child:
                            IconButton(icon:Icon(Icons.arrow_forward_ios), onPressed: tempFunc,)),
                          ]
                        )
                      ),

                    ]

                )
            )
          ]
        )
      ])
    );
  }
}
