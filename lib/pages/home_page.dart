import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_setuptutorial/read_data/get_user_name.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection("users")
        // .orderBy("age", descending: true)
        // .where("age",isGreaterThan: 21)
        .get()
        .then((snapshot) {
      for (var document in snapshot.docs) {
        docIDs.add(document.reference.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.email!),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        actions: [
          GestureDetector(
            child: const Icon(Icons.logout),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text("Signed In as ${user.email}"),
          // MaterialButton(
          //   onPressed: () {
          //     FirebaseAuth.instance.signOut();
          //   },
          //   color: Colors.deepPurple,
          //   child: Text(
          //     "Sign Out",
          //     style: TextStyle(color: Colors.white),
          //   ),
          // ),
          Expanded(
              child: FutureBuilder(
                  future: getDocId(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        itemCount: docIDs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              tileColor: Colors.deepPurple[100],
                              title: GetUserName(documentId: docIDs[index]),
                              // title: Text(docIDs[index]),
                            ),
                          );
                        });
                  }))
        ],
      )),
    );
  }
}
