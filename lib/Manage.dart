import 'package:flutter/material.dart';
import 'package:desirth/Reusable.dart' as Reusable;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  static Map<String, dynamic> _userData = {};
  static Map<String, dynamic> _storyData = {};

  TextEditingController nameSearch = TextEditingController();
  TextEditingController storySearch = TextEditingController();

  List<Widget> userTiles = [];
  List<Widget> storyTiles = [];

  static void editUserData(String docId, Map<String, dynamic> data) {
    _userData[docId] = data;
  }

  void saveUserData() {
    _userData.forEach((key, value) {
      FirebaseFirestore.instance.collection('users').doc(key).update(value);
    });
  }

  static void editStoryData(String docId, Map<String, dynamic> data) {
    _storyData[docId] = data;
  }

  void saveStoryData() {
    _storyData.forEach((key, value) {
      FirebaseFirestore.instance.collection('stories').doc(key).update(value);
    });
  }

  @override
  void initState() {
    getUserData().then((value) {
      setState(() {
        _userData = value;
        userTiles = createUserTiles(_userData);
      });

      return value;
    });
    getStoryData().then((value) {
      setState(() {
        _storyData = value;
        storyTiles = createStoryTiles(_storyData);
      });
      return value;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Admin Management"),
      ),
      drawer: const Reusable.ReusableDrawer(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(children: [
            Text("User Management"),
            Container(
              width: 300,
              child: TextField(
                controller: nameSearch,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search for user',
                ),
                onChanged: (value) {
                  setState(() {
                    userTiles = createUserTiles(_userData);
                  });
                },
              ),
            ),
            // TODO: change this to a future builder? or a list of futurebuilders?
            ...userTiles.where((element) {
              return element
                  .toString()
                  .toLowerCase()
                  .contains(nameSearch.text.toLowerCase());
            }).toList(),
          ]),
          Column(children: [
            Text("Story Management"),
            Container(
              width: 300,
              child: TextField(
                controller: storySearch,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search for story',
                ),
                onChanged: (value) {
                  setState(() {
                    storyTiles = createStoryTiles(_storyData);
                  });
                },
              ),
            ),
            // TODO: change this to a future builder? or a list of futurebuilders?
            ...storyTiles.where((element) {
              return element
                  .toString()
                  .toLowerCase()
                  .contains(nameSearch.text.toLowerCase());
            }).toList(),
          ]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () {
            saveUserData();
            saveStoryData();
          }),
    ));
  }
}

Future<Map<String, dynamic>> getUserData() async {
  Map<String, dynamic> userData = {};

  await FirebaseFirestore.instance
      .collection('users')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      userData[doc.id] = doc.data();
    });
  });
  return userData;
}

class UserTile extends StatefulWidget {
  bool isAdmin;
  bool isWriter;
  final String name;
  final String docId;
  UserTile(
      {super.key,
      required this.isAdmin,
      required this.isWriter,
      required this.name,
      required this.docId});

  getName() {
    return name;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return name;
  }

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.name, softWrap: true, overflow: TextOverflow.visible),
        SizedBox(
          width: 155,
          child: CheckboxListTile(
            title: Text("Is Admin"),
            value: widget.isAdmin,
            onChanged: (value) {
              setState(() {
                widget.isAdmin = value ?? false;
                _ManagePageState.editUserData(widget.docId, {
                  "isAdmin": widget.isAdmin,
                  "isWriter": widget.isWriter,
                });
              });
            },
          ),
        ),
        SizedBox(
          width: 155,
          child: CheckboxListTile(
            title: Text("Is Writer"),
            value: widget.isWriter,
            onChanged: (value) {
              setState(() {
                widget.isWriter = value ?? false;
                _ManagePageState.editUserData(widget.docId, {
                  "isAdmin": widget.isAdmin,
                  "isWriter": widget.isWriter,
                });
              });
            },
          ),
        )
      ],
    );
  }
}

createUserTiles(Map<String, dynamic> userData) {
  List<Widget> userTiles = [];
  userData.keys.forEach((element) {
    userTiles.add(UserTile(
      docId: element,
      name: userData[element]["name"],
      isAdmin: userData[element]["isAdmin"],
      isWriter: userData[element]["isWriter"],
    ));
  });

  return userTiles;
}

Future<Map<String, dynamic>> getStoryData() async {
  Map<String, dynamic> storyData = {};

  FirebaseFirestore.instance
      .collection('stories')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      storyData.addAll({doc.id: doc.data()});
    });
  });

  return storyData;
}

class StoryTile extends StatefulWidget {
  final String title;
  final String docId;
  bool approved;
  StoryTile(
      {super.key,
      required this.docId,
      required this.title,
      required this.approved});

  @override
  toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return title;
  }

  @override
  State<StoryTile> createState() => _StoryTileState();
}

class _StoryTileState extends State<StoryTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.title),
        CheckboxListTile(
          title: Text("Approved"),
          value: widget.approved,
          onChanged: (value) {
            setState(() {
              widget.approved = value ?? false;
              _ManagePageState.editStoryData(widget.docId, {
                "approved": widget.approved,
              });
            });
          },
        ),
      ],
    );
  }
}

List<Widget> createStoryTiles(Map<String, dynamic> storyData) {
  List<Widget> storyTiles = [];
  storyData.forEach((key, value) {
    storyTiles.add(StoryTile(
      docId: key,
      title: value["title"],
      approved: value["approved"],
    ));
  });
  return storyTiles;
}
