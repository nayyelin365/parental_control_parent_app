import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parent_app/data/child_app_model.dart';
import 'package:parent_app/features/firebase/noti_send_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ChildAppModel> childAppList = [];
  var collection = FirebaseFirestore.instance.collection('child_table');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent App"),
      ),
      body: StreamBuilder(
        stream: _getStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Text("No Internet Connection"),
            );
          }
          if (snapshot.hasData) {
            return Container(
              child: generalKnowledgeWidget(snapshot),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget generalKnowledgeWidget(AsyncSnapshot<QuerySnapshot> snapshot) {
    childAppList.clear();
    snapshot.data!.docs.forEach((f) {
      //print(f["appName"]);
      childAppList.add(ChildAppModel(
          appName: f['appName'],
          version: f['version'],
          appIcon: f['appIcon'],
          packageName: f['packageName'],
          enable: f['enable']));
    });
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: childAppList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 14,
                  ),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    // color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(10),
                    // ignore: prefer_const_literals_to_create_immutables
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 20.0,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: MemoryImage(_convertListToInt(
                        childAppList[index].appIcon.toString())),
                    backgroundColor: Theme.of(context).primaryColorDark,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        childAppList[index].appName.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        childAppList[index].version.toString(),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: FlutterSwitch(
                    width: 50.0,
                    height: 25.0,
                    valueFontSize: 25.0,
                    toggleColor: Colors.white,
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Colors.grey,
                    toggleSize: 20.0,
                    value: childAppList[index].enable == "1",
                    borderRadius: 30.0,
                    padding: 2.0,
                    showOnOff: false,
                    onToggle: (val) {
                      if (childAppList[index].enable == "1") {
                        collection
                            .doc("5EyYPL3K6DC5jBfrwRgO")
                            .collection('applist')
                            .where('appName',
                                isEqualTo: childAppList[index].appName)
                            .get()
                            .then((querySnapshot) {
                          print('answer: success');
                          querySnapshot.docs.forEach((doc) {
                            doc.reference.update({'enable': '0'});
                          });
                        }).catchError((error) => print('onError:$error'));
                        postNotification(
                            "${childAppList[index].appName} is allowed.",
                            "${childAppList[index].appName} is allowed by your parents.",
                            childAppList[index].packageName.toString());
                        Fluttertoast.showToast(msg: "In Active");
                      } else {
                        collection
                            .doc("5EyYPL3K6DC5jBfrwRgO")
                            .collection('applist')
                            .where('appName',
                                isEqualTo: childAppList[index].appName)
                            .get()
                            .then((querySnapshot) {
                          print('answer: success');
                          querySnapshot.docs.forEach((doc) {
                            doc.reference.update({'enable': '1'});
                          });
                        }).catchError((error) => print('onError: $error'));
                        postNotification(
                            "${childAppList[index].appName} is not allowed.",
                            "${childAppList[index].appName} is not allowed by your parents.",
                            childAppList[index].packageName.toString());
                        Fluttertoast.showToast(msg: "Active");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Uint8List _convertListToInt(String input) {
    final reg = RegExp(r"([0-9]+|\d+)");
    final pieces = reg.allMatches(input);
    final result = pieces.map((e) => int.parse(e.group(0).toString())).toList();

    List<int> example = result;

    return Uint8List.fromList(example);
  }

  Stream<QuerySnapshot> _getStream() {
    return FirebaseFirestore.instance
        .collection("child_table")
        .doc("5EyYPL3K6DC5jBfrwRgO")
        .collection('applist')
        .snapshots();
  }
}
