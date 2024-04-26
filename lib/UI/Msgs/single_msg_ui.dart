import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notifications/Common/constants.dart';
import 'package:notifications/model/fireBase.dart';
import 'package:notifications/model/msgDao.dart';
@immutable
class SingleMsgUI extends StatelessWidget {
  msgDao msg;

  SingleMsgUI({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    //make date be year/month/day hours:minutes:seconds
  String date = msg.date!.toDate().toString();
  date = date.substring(0, date.length - 7);
    return Slidable(
      startActionPane:ActionPane(    motion: const ScrollMotion(), children:[
        SlidableAction(

          // An action can be bigger than the others.
          flex: 2,
          onPressed: (context) async {
           await FireBaseData.deleteTask(msg, token);
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ]

      ),

      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration:  BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(msg.name!,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(msg.message!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    )),
                Text(date,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
