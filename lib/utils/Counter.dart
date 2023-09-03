import 'package:flutter/cupertino.dart';

import '../SQLbase/Music.dart';

String globalId='';
String globalName='';
Map<String, Music> globalIds={};

class GlobalInfo extends ChangeNotifier  {
  late String _id;
  late String _name;
  late Map<String ,Music> _ids;

  String get id => _id;
  String get name => _name;
  Map<String ,Music> get ids => _ids;

  set setName(String s) {
    _name = s;
    notifyListeners();
  }

  set setId(String s) {
  _id=s;
  notifyListeners();
}
  set setIds(Map<String ,Music> s) {
    _ids = s;
    notifyListeners();
  }

  Future init() async{
    _id='';
    _name='';
    _ids={};
  }
}