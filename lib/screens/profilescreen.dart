/*import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talkito1/widgets/chatcard.dart';
*/

import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talkito1/helper/dialog.dart';
import 'package:talkito1/jsonmodel/chatuser.dart';
/*import 'package:cloud_firestore/cloud_firestore.dart';*/
import 'package:talkito1/screens/auth/loginscreen.dart';
import '../apis/api.dart';
import '../main.dart';
/*import '../widgets/chatcard.dart';*/

class profilescreens extends StatefulWidget {
  final chatusres user;
  const profilescreens({super.key, required this.user});

  @override
  State<profilescreens> createState() => _profilescreensState();
}

class _profilescreensState extends State<profilescreens> {
  final _formkey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Profile Page'),
            actions: [
              // IconButton(onPressed: () {}, icon: const Icon(Icons.edit),highlightColor: const Color(0XFF76ABAE),),
              /* Tooltip(
                message: 'Edit',
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  highlightColor: const Color(0XFF76ABAE),
                ),
              ),*/
              Tooltip(
                message: 'Save',
                child: IconButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      Apis.userupdateinfo();
                      dialogs.showSnackBar(context, "Succesfully Updated");
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(
                    Icons.save,
                    size: 30,
                  ),
                  highlightColor: const Color(0XFF76ABAE),
                ),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20),
            child: FloatingActionButton.extended(
              onPressed: () async {
                dialogs.showProgressBar(context);
                await Apis.auth.signOut().then((onValue) async {
                  await GoogleSignIn().signOut().then((onValue) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const loginscreens()));
                  });
                });
              },
              icon: const Icon(Icons.logout_outlined),
              label: const Text("Logout"),
              backgroundColor: const Color(0XFF76ABAE),
            ),
          ),
          body: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container( // Add Container with constraints
                height: mq.height * 0.4, // Example height constraint
                width: mq.width * 0.4,
                    child: Stack(children: [
                      _image != null
                          ? ClipRRect(
                              // borderRadius: BorderRadius.circular(mq.height * 0.1),
                              child: Center(
                                child: Image.file(
                                  File(_image!),
                                  width: mq.width * 0.40,
                                  height: mq.height * 0.40,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Positioned(
                              right: 85,
                              bottom: 65,
                              child: Tooltip(
                                message: 'Edit',
                                child: MaterialButton(
                                  onPressed: () {
                                    _showbottomsheet();
                                  },
                                  child: const Icon(Icons.edit),
                                  color: const Color(0XFF76ABAE),
                                  shape: const CircleBorder(),
                                ),
                              ),
                            ),
                    ]),),
                  ),
                  SizedBox(
                    height: mq.height * 0,
                  ),
                  Text(
                    widget.user.email,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.001,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onSaved: (val) => Apis.me?.name = val ?? "",
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Requried Field",
                      initialValue: widget.user.name,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          hintText: "eg. jhon doe",
                          label: Text('Name')),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  void _showbottomsheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            shrinkWrap: true,
            children: [
              Text(
                "Pick Profile Picture",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
              ),
              SizedBox(
                height: mq.height * .03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera ,  imageQuality: 80);
                        if (image != null) {
                          print(Text("hello"));
                          setState(() {
                            _image = image.path;
                          });
                          Apis.updateprofileimage(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: Color(0XFF76ABAE),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      child: Image.asset('images/camera.png')),
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery , imageQuality: 80);
                        if (image != null) {
                          print(Text("hello"));
                          setState(() {
                            _image = image.path;
                          });
                          Apis.updateprofileimage(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: Color(0XFF76ABAE),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      child: Image.asset('images/image-gallery.png'))
                ],
              )
            ],
          );
        });
  }
}
