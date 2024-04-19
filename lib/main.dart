import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notifications/Api_service.dart';
import 'package:notifications/UI/msgsListUi.dart';
import 'package:notifications/constants.dart';
import 'package:notifications/fcm_helper.dart';
import 'package:notifications/Navigation_services.dart';
import 'package:notifications/model/fireBase.dart';
import 'package:notifications/model/msgDao.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FCMHelper fcmHelper = FCMHelper();
  String ?token1=await fcmHelper.firebaseMessaging.getToken();

  await fcmHelper.initFireBaseMessaging();
    await FirebaseFirestore.instance.collection("FCMs").doc
      (token1
    ).set(
      {
        "token": token1,
      }
    );
    token=token1!;
    print(token);
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        MsgsListUi.routeName: (context) => const MsgsListUi(),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () async {
                String title="Assigment";
                String message="Hey there";
                var snapshot2 = await FirebaseFirestore.instance.collection("FCMs").get();
                FireBaseData.createTask(msgDao(targetToken: token,name: title,message: message,
                    date: Timestamp.now()));
                for (var doc in snapshot2.docs) {

                  Api().sendAndRetrieveMessage(title,message,doc['token']);
                  // sendAndRetrieveMessage(currentUserName
                  //     ,message,doc['token']);
                }
                FirebaseMessaging.instance.getToken().then((value) {

                });
              },
              child: const Text("Send a message to FCM"),
            ),
            ElevatedButton(
              onPressed: () async {
               Navigator.pushNamed(context, MsgsListUi.routeName);
              },
              child: const Text("Show messages List"),
            ),
          ],
        )
      )
    );

  }
}
