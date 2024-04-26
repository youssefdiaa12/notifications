import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notifications/Common/constants.dart';
import 'package:notifications/UI/Auth/register.dart';
import 'package:notifications/UI/Files/show_files.dart';
import 'package:notifications/UI/Msgs/msgsListUi.dart';
import 'package:notifications/fcm_helper.dart';
import 'package:notifications/Navigation_services.dart';
import 'package:notifications/home_page.dart';
import 'package:notifications/viewModel/provider.dart';
import 'package:provider/provider.dart';


import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FCMHelper fcmHelper = FCMHelper();
  String? token1 = await fcmHelper.firebaseMessaging.getToken();

  await fcmHelper.initFireBaseMessaging();
  await FirebaseFirestore.instance.collection("FCMs").doc(token1).set({
    "token": token1,
  });
  token = token1!;
  var provider1 =provider();
  runApp(

      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (buildContext) => provider1),
        ],
        child: MyApp(),

      ));

}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    provider obj = Provider.of<provider>(context);
   bool is_logged_in = obj.Loggedin();
     obj.retrivedata();
    return MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: is_logged_in ?  const MyHomePage(title: 'Flutter Demo Home Page'): const Register(),
        routes: {
          ShowFiles.routeName: (context) => const ShowFiles(),
          Register.routeName: (context) => const Register(),
          MsgsListUi.routeName: (context) => const MsgsListUi(),
          MyHomePage.routeName: (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        });
  }
}


