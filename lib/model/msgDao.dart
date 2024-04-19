import 'package:cloud_firestore/cloud_firestore.dart';

class msgDao{
  String? name;
  String? message;
  String? targetToken;
  Timestamp? date;


  msgDao({this.name, this.message, this.targetToken, this.date});


  msgDao.fromFireStore(Map<String, dynamic>? mp) {
    name=mp?['name'];
    message=mp?['message'];
    targetToken=mp?['targetToken'];
    date=mp?['date'];
  }

  Map<String, dynamic> toFireStore() {
    return {
      'name': name,
      'message': message,
      'targetToken': targetToken,
      'date': date
    };
  }


}