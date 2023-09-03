import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
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


class ShowAlertDialog extends StatefulWidget {
  const ShowAlertDialog( this.title,this.content, {super.key});

  final String title; // Text('New nickname'.tr)
  final Widget content;

  @override
  State<ShowAlertDialog> createState() => _ShowAlertDialog(title: title,content: content);
}

class _ShowAlertDialog extends State<ShowAlertDialog> {

  final String title; // Text('New nickname'.tr)
  final Widget content;
  _ShowAlertDialog({required this.title, required this.content});


  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title:  Text(title, style:  const TextStyle(fontSize: 17.0)),
      content: content,
      actions: [
        ElevatedButton(
          child:  const Text('cancel'),
          onPressed: (){
            Navigator.pop(context,false);
          },
        ),
        ElevatedButton(
          child:  const Text('ok'),
          onPressed: (){
            Navigator.pop(context, true);
          },
        )
      ],
    );

  }
}