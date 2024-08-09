import 'package:flutter/material.dart';

class dialogs {
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
    ));
  }
  static void showProgressBar(BuildContext context) {
    showDialog(context: context, builder: (_) => Center(child: const CircularProgressIndicator()));
  }
}
