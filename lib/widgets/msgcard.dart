import 'package:flutter/material.dart';
import 'package:talkito1/apis/api.dart';
import 'package:talkito1/jsonmodel/messege.dart';

import '../main.dart';

class msgcards extends StatefulWidget {
  const msgcards({super.key, required this.messeges});
  final Messeges messeges;

  @override
  State<msgcards> createState() => _msgcardsState();
}

class _msgcardsState extends State<msgcards> {
  @override
  Widget build(BuildContext context) {
    return Apis.user.uid == widget.messeges.fromid ? _greenmsg() : _bluemsg();
  }

  //sender messeges
  Widget _bluemsg() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width* .04,vertical: mq.height *.01
            ),
            decoration: BoxDecoration(
                color: const Color(0XFFCAF4FF),
              border: Border.all(color: const Color(0xff7C00FE)),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
              )
            ),
            child: Text(widget.messeges.msg,style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              letterSpacing: 1
            ),),
          ),
        ),
        Padding(padding: EdgeInsets.only(right : mq.width * .04),
        child: Text(
          widget.messeges.sent,style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
        ),
        )
      ],
    );
  }

  // our messeges
  Widget _greenmsg() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Row(
          children: [
            SizedBox(width : mq.width * .04),
            const Icon(Icons.done_all_rounded,color: Colors.lightBlueAccent,),
            const SizedBox(width: 3,),
            Text(
              widget.messeges.read,style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width* .04,vertical: mq.height *.01
            ),
            decoration: BoxDecoration(
                color: const Color(0XFFB4E380),
                border: Border.all(color: const Color(0xff1E5128)),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)
                )
            ),
            child: Text(widget.messeges.msg,style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                letterSpacing: 1
            ),),
          ),
        ),
      ],
    );
  }
}
