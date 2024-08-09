/*import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talkito1/widgets/chatcard.dart';
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:talkito1/helper/dialog.dart';
import 'package:talkito1/jsonmodel/chatuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talkito1/screens/profilescreen.dart';
import '../apis/api.dart';
import '../widgets/chatcard.dart';

class homescreens extends StatefulWidget {
  const homescreens({super.key});

  @override
  State<homescreens> createState() => _homescreensState();
}

class _homescreensState extends State<homescreens> {
  List<chatusres> list = [];
  List<chatusres> searchlist = [];
  bool _isSearching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Apis.selfinfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: _isSearching
                  ? TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "Name,Email.."),
                      autofocus: true,
                      onChanged: (val) {
                        searchlist.clear();

                        for (var i in list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            searchlist.add(i);
                          }
                          setState(() {
                            searchlist;
                          });
                        }
                      },
                    )
                  : Text('TalkiTO'),
              leading: Icon(Icons.home),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(_isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => profilescreens(
                                    user: list[0],
                                  )));
                    },
                    icon: const Icon(Icons.more_vert_rounded))
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 20),
              child: FloatingActionButton(
                onPressed: () async {
                  await Apis.auth.signOut();
                  await GoogleSignIn().signOut();
                },
                child: Icon(Icons.add_comment_outlined),
                backgroundColor: Color(0XFF76ABAE),
              ),
            ),
            body: StreamBuilder<QuerySnapshot<Object?>>(
                //stream: Apis.firestore.collection("users").where('id',isNotEqualTo: !user.uid).snapshots(),
                stream: Apis.firestore.collection("users").snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      list = data
                              ?.map((e) => chatusres
                                  .fromJson(e.data() as Map<String, dynamic>))
                              .toList() ??
                          [];

                      if (list.isNotEmpty) {
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                _isSearching ? searchlist.length : list.length,
                            itemBuilder: (context, index) {
                              return chatcards(
                                user: _isSearching
                                    ? searchlist[index]
                                    : list[index],
                              );
                              //return Text('name : ${list[index]}');
                            });
                      } else {
                        return const Center(
                            child: Text("No Connection Found Brother!"));
                      }
                  }
                }),
        ),
      ),
    );
  }
}
