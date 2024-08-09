import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:talkito1/jsonmodel/chatuser.dart';
import 'package:talkito1/screens/chatscreen.dart';

import '../main.dart';

class chatcards extends StatefulWidget {
  final chatusres user;
  const chatcards({super.key, required this.user});


  @override
  State<chatcards> createState() => _chatcardsState();
}

class _chatcardsState extends State<chatcards> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .02, vertical:4),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => chatscreens(user: widget.user)));
                },
        child: ListTile(
        //  leading: const CircleAvatar(child: Icon(Icons.person),),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * 20),
            child: CachedNetworkImage(
              width: mq.width * 0.20,
              height: mq.height * 0.55,
              imageUrl: widget.user.image,
             // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => const CircleAvatar(child: Icon(Icons.person),),
            ),
          ),
          title: Text(widget.user.name),


          subtitle: Text(widget.user.about,maxLines: 1,),
         // trailing: Text("12 PM"),
          trailing: Container(
            width: 10,
            height: 10,
           decoration: BoxDecoration(
             color: Colors.green,
             borderRadius: BorderRadius.circular(10),
           ),
          ),

        ),
      ),
    );
  }
}
