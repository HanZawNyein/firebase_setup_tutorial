import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_setuptutorial/read_data/get_user_name.dart';
import 'package:flutter/material.dart';

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
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              // print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }

  @override
  void initState() {
    // TODO: implement initState
    // getDocId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.email!),
        centerTitle: true,
        actions: [
          GestureDetector(
            child: Icon(Icons.logout),
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
                          return ListTile(
                            title: GetUserName(documentId: docIDs[index]),
                          );
                        });
                  }))
        ],
      )),
    );
  }
}
