import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewbieListTile extends StatelessWidget {
  late final DocumentSnapshot documentData;
  NewbieListTile(this.documentData);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(documentData["name"]),
          subtitle: Row(
            children: <Widget>[
              Text(documentData["email"]),
              SizedBox(width: 10, height: 10),
              Text(documentData["phone"]),
            ],
          ),
        ),
      ),
    );
  }
}