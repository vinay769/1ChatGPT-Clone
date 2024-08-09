import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:talkito1/jsonmodel/chatuser.dart';
import 'package:talkito1/screens/homescreen.dart';
import 'package:talkito1/widgets/msgcard.dart';

import '../apis/api.dart';
import '../jsonmodel/messege.dart';
import '../main.dart';

class chatscreens extends StatefulWidget {
  final chatusres user;
  const chatscreens({super.key, required this.user});

  @override
  State<chatscreens> createState() => _chatscreensState();
}

class _chatscreensState extends State<chatscreens> {
  // for storing all messegs
  List<Messeges> _list = [];
  final _textcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appbar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                //stream: Apis.firestore.collection("users").where('id',isNotEqualTo: !user.uid).snapshots(),
                stream: Apis.getallmessages(widget.user),
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
                      log('\ndata : ${jsonEncode(data![0].data())}');
                        _list = data
                            ?.map((e) => Messeges.fromJson(e.data() as Map<String, dynamic>))
                            .toList() ??
                            [];


                      if (_list.isNotEmpty) {
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _list.length,
                            itemBuilder: (context, index) {
                              return msgcards(
                                messeges: _list[index],
                              );
                            });
                      } else {
                        return const Center(child: Text("Hey There..😊"));
                      }
                  }
                },
              ),
            ),
            _inputfield(),
          ],
        ),
      ),
    );
  }

  Widget _appbar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const homescreens())),
              icon: const Icon(Icons.arrow_back_ios)),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * 20),
            child: CachedNetworkImage(
              width: mq.width * 0.20,
              height: mq.height * 0.40,
              imageUrl: widget.user.image,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name.toUpperCase(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const Text(
                "Last seen 12 PM",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _inputfield() {
    return Row(children: [
      Expanded(
        child: Card(
          child: Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.emoji_emotions,
                    color: Color(0XFF76ABAE),
                  )),
               Expanded(
                  child: TextField(
                    controller: _textcontroller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Type Here...'),
              )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.attach_file,
                    color: Color(0XFF76ABAE),
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.camera,
                    color: Color(0XFF76ABAE),
                  )),
            ],
          ),
        ),
      ),
      MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Adjust corner radius as needed
        ),
        height: 47,
        color: const Color(0xffEEEEEE),
        highlightElevation: 5.0,
        onPressed: () {
          if(_textcontroller.text.isNotEmpty){
            Apis.sendmessages(widget.user, _textcontroller.text);
            _textcontroller.text = '';
          }
        },
        child: const Icon(
          Icons.rocket_launch,
          color: Color(0xff06D001),
        ),
      ),
    ]);
  }
}
