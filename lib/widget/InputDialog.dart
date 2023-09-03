//组件文件
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputDialog extends StatefulWidget {
  const InputDialog({Key? key, this.hintText = "id", this.title, this.max = 12}) : super(key: key);

  final Widget? title; // Text('New nickname'.tr)
  final String? hintText;
  final int? max;

  @override
  State<InputDialog> createState() => _InputDialogState(title: title, hintText: this.hintText, max: this.max);
}

class _InputDialogState extends State<InputDialog> {
  final TextEditingController _textEditingController = TextEditingController();

  final Widget? title; // Text('New nickname'.tr)
  final String? hintText;
  final int? max;
  _InputDialogState({required this.title, required this.hintText,required this.max});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: TextField(
          controller: _textEditingController,
          maxLength:max,
          decoration: InputDecoration(hintText: hintText),
          autofocus: true
      ),
      actions: [
        ElevatedButton(
          style:ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.green)),
          onPressed: () {
            Navigator.pop(context,_textEditingController.text);
          },
          child: const Text('ok',style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style:ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.transparent),elevation:MaterialStateProperty.all(0)),
          onPressed: () {
            Navigator.pop(context,"");
          },
          child: const Text('cancel',style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}