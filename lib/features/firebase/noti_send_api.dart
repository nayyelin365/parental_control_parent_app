import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../constants.dart';

Future<String> postNotification(
    String title, String body, String packageName) async {
  Map data = {
    "to":
        "d-8YtQUkRa-LgFvNhdTvpT:APA91bG6c7DxHXbdE_d6r88i8BK1T3meNYKfNkh6elHncbfmXuN9ik2hP42GBxolIqVD4t8utrvhrHFmk-cOD1uTtd7CrPk-404WSexSm9JKdX-Af_a3_nQ6Cq_fhcI8E2xzmGpmK6WF",
    "data": {"title": title, "body": body, "packageName": packageName},
    "notification": {"title": title, "body": body, "packageName": packageName},
    "priority": "high"
  };
  //encode Map to JSON
  var jsonBody = json.encode(data);
  var response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Constants.apiAuthorizationKey,
    },
    body: jsonBody,
  );
  if (response.statusCode == 200) {
    print("@@@NotiSend");
    return "Already send";
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    //throw Exception('Failed to create album.');
    print("@@@NotiSendError");
    return "Error Occur";
  }
}
