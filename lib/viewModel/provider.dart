import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notifications/model/user.dart' as myuser;
class provider extends ChangeNotifier {


  User? firebaseauth;
  myuser.User? user;

  int selectedindex = 0;
  SharedPreferences? preferences;

  void changeVisability() {
    notifyListeners();
  }

  bool Loggedin() {

    return FirebaseAuth.instance.currentUser != null;


  }
void saveUser(myuser.User user){
    preferences!.setString('email', user.email??'');
    this.user=user;
  notifyListeners();
}
  void retrivedata()  {
    firebaseauth = FirebaseAuth.instance.currentUser;

    if (firebaseauth != null) {
      user = myuser.User(firebaseauth!.email!.substring(0,firebaseauth!.email!.indexOf('@')), firebaseauth!.email!);
      return;
    }
    print('retrivedata');
    return; // Return null if firebaseauth or user is null
  }


  Future<void> logout() async {
    user = null;
    await FirebaseAuth.instance.signOut();
  }


  Future<void> login(String email, String password) async {
 await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    user =myuser.User(email.substring(0,email.indexOf('@')), email);
  }



  Future<void> register(String email, String password, String firstName,Timestamp time) async {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    user =myuser.User(email.substring(0,email.indexOf('@')), email);
  }
  Future<void>Delete() async{
    await FirebaseAuth.instance.currentUser!.delete();
    user=null;
  }








}
//bf376d3cbdbf47c9a8c4bf1ef7d27f8a
