import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:parent_app/utils/share_prefs_utils.dart';

import '../../constants.dart';

Future<String> postNotification(
    String title, String body, String packageName) async {
  Map data = {
    "to": StorageUtils.getString(Constants.firebaseToken),
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
    debugPrint("@@@NotiSend");
    return "Already send";
  } else {
    debugPrint("@@@NotiSendError");
    return "Error Occur";
  }
}
