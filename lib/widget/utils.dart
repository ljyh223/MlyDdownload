import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class WidgetUtils {
  static showToast(String text, Color c) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: c,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}
