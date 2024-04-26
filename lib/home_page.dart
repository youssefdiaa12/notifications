import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:notifications/Common/constants.dart';
import 'package:notifications/UI/Files/show_files.dart';
import 'package:notifications/UI/Msgs/msgsListUi.dart';
import 'package:notifications/model/Api_service.dart';
import 'package:notifications/model/fireBase.dart';
import 'package:notifications/model/msgDao.dart';
import 'package:notifications/viewModel/provider.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = '/home';
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  PlatformFile? file;
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    provider obj = Provider.of<provider>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      String title = "Assigment";
                      String message = "Hey there";
                      var snapshot2 = await FirebaseFirestore.instance
                          .collection("FCMs")
                          .get();
                      FireBaseData.createTask(msgDao(
                          targetToken: token,
                          name: title,
                          message: message,
                          date: Timestamp.now()));
                      for (var doc in snapshot2.docs) {
                        Api().sendAndRetrieveMessage(
                            title, message, doc['token']);
                        // sendAndRetrieveMessage(currentUserName
                        //     ,message,doc['token']);
                      }
                      FirebaseMessaging.instance.getToken().then((value) {});
                    },
                    child: const Text("Send a message to FCM"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, MsgsListUi.routeName);
                    },
                    child: const Text("Show messages List"),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await UploadFile(obj.user!.email??'');
                      },
                      child: const Text("Upload a file")),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, ShowFiles.routeName);
                    },
                    child: const Text("Show Files List"),
                  ),


                ],
              ),
            ),
            const SizedBox(height: 20),
            file != null
                ? Expanded(
                    child: file!.name.contains('.jpeg')
                        ? Image.file(
                            File(file!.path!),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        :
                        // pdf show
                        file!.name.contains('.pdf')
                            ? PDFView(
                                filePath: file!.path!,
                                enableSwipe: true,
                                //    swipeHorizontal: true,

                                autoSpacing: false,
                                pageFling: false,
                                onRender: (_pages) {
                                  setState(() {
                                    pages = _pages;
                                    isReady = true;
                                  });
                                },
                                onError: (error) {},
                                onPageError: (page, error) {},
                                onViewCreated:
                                    (PDFViewController pdfViewController) {
                                  _controller.complete(pdfViewController);
                                },
                                onPageChanged: (int? page, int? total) {
                                  setState(() {
                                    currentPage = page;
                                  });
                                },
                              )
                            : const Text("No file selected"),
                  )
                : const Text("No file selected"),
          ],
        )));
  }

  Future<void> UploadFile(String email) async {
    FilePicker.platform.pickFiles().then((value) {
      setState(() {
        file = value!.files.first;
        final path = "$email/files/${file!.name}";
        final file1 = File(file!.path!);
        FireBaseData.UploadFile(file1, path);
      });
    });
  }
}
