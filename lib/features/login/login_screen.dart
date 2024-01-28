import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parent_app/constants.dart';
import 'package:parent_app/utils/share_prefs_utils.dart';

import '../home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passCodeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    passCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              const Text(
                "Child Application",
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              const SizedBox(
                height: 12,
              ),
              Image.asset(
                "assets/images/login.png",
                width: 200,
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: userNameController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Enter UserName',
                  fillColor: Colors.amber,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 2),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: passCodeController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Enter PassCode',
                  fillColor: Colors.amber,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 2),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                    onPressed: () async {
                      List<DocumentSnapshot> docs = [];
                      await FirebaseFirestore.instance
                          .collection('child_table')
                          .where("name", isEqualTo: userNameController.text)
                          .where("pass_code",
                              isEqualTo: passCodeController.text)
                          .get()
                          .then((query) {
                        docs = query.docs;
                        if (docs.isEmpty) {
                          Fluttertoast.showToast(msg: "User does not exist");
                        } else {
                          query.docs.forEach((f) {
                            var childId = f['child_id'];
                            var firebaseToken = f['firebase_token'];
                            //save data
                            StorageUtils.putString(
                                Constants.firebaseToken, firebaseToken);
                            StorageUtils.putString(Constants.childId, childId);

                            Fluttertoast.showToast(msg: "success");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          });
                        }
                      });
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.black),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
