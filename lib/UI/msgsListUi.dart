import 'package:flutter/material.dart';
import 'package:notifications/UI/single_msg_ui.dart';
import 'package:notifications/constants.dart';
import 'package:notifications/fcm_helper.dart';
import 'package:notifications/model/fireBase.dart';
import 'package:notifications/model/msgDao.dart';

class MsgsListUi extends StatefulWidget {
  static const String routeName = '/msgsListUi';

  const MsgsListUi({Key? key}) : super(key: key);

  @override
  State<MsgsListUi> createState() => _MsgsListUiState();
}

class _MsgsListUiState extends State<MsgsListUi> {
  List<msgDao> msgs = [];

  @override
  void initState() {
    super.initState();
    initializeMessages();
  }

  Future<void> initializeMessages() async {
    FCMHelper fcmHelper = FCMHelper();
    String? token = await fcmHelper.firebaseMessaging.getToken();
    if (token != null) {
      List<msgDao> fetchedMsgs = await FireBaseData.getTasks(token);
      setState(() {
        msgs = fetchedMsgs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: StreamBuilder(
        stream: FireBaseData.listForTasks(token),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return SingleMsgUI(msg: snapshot.data![index]);
              },
            );
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Column(
                children: [
                  const Text('something went wrong'),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text('Refresh'))
                ],
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center();
        },
      ),
    );
  }
}
