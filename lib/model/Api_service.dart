import 'package:http/http.dart' as http;
import 'dart:convert';

class Api {
  String serverToken ="AAAAvGv-L3w:APA91bHCpMdKKf600PMVZW0iFICQ0CRQcKzB7XxEUWsiwXNoPAIL5FUag2O6JFTheDa2OAdrrGH0cOU3b-0Ejj5KAHAj0xLWVTVAuInwWfx-RzauG3CwAVc9Uy1Iy6EuMG_9iPtzMhxs";
  sendAndRetrieveMessage(String name, String message,
      String targetToken) async {
    await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '$message',
            'title': '$name'
          },
          'priority': 'high',
          'to': targetToken,
        },
      ),
    );
  }
}