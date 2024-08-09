import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:talkito1/jsonmodel/chatuser.dart';
import 'package:talkito1/jsonmodel/messege.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static chatusres? me;

  static User get user => auth.currentUser!;

  static Future<bool> userexists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<void> createuser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final cuser = chatusres(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: " hey i am fuckin happy",
        createdAt: time,
        isOnline: false,
        id: user.uid,
        lastActive: time,
        pushToken: "",
        email: user.email.toString());
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(cuser.toJson());
  }

  static Future<Stream<QuerySnapshot<Map>>> getalluser() async {
    return firestore
        .collection("users")
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> selfinfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) async {
      if (!user.exists) {
        me = chatusres.fromJson(user.data()!);
      } else {
        await createuser().then((onValue) => selfinfo());
      }
    });
  }

  static Future<void> userupdateinfo() async {
    return await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'name': me!.name});
  }

  static Future<void> updateprofileimage(File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('images/${user.uid}.$ext');
    ref.putFile(file, SettableMetadata(contentType: 'images/$ext')).then((p0) {
      //log('Data Transfer : ${p0.bytesTransferred / 1000} kb');
      print(Text('image updated'));
    });
    me?.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'image': me!.image});
  }

  static String getconversationid(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '{$id}_${user.uid}';

  static Stream<QuerySnapshot<Map>> getallmessages(chatusres user) {
    return firestore
        .collection('chats/${getconversationid(user.id)}/messages')
        .snapshots();
  }

  static Future<void> sendmessages(chatusres chuser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Messeges messeges = Messeges(
        fromid: chuser.id,
        msg: msg,
        read: '',
        sent: time,
        toid: chuser.id,
        type: '');
    final ref = firestore
        .collection('chats/${getconversationid(chuser.id)}/messages}')
        .snapshots();
    await ref.any(messeges.toJson() as bool Function(QuerySnapshot<Map<String, dynamic>> element));
   // await ref.doc(time).set(messeges.toJson());
  }
  /*
  error: The getter '(' isn't defined for the type 'Stream<QuerySnapshot<Map<String, dynamic>>>'.
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  }*/
}
