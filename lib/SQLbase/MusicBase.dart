import 'dart:math';

class MusicBase{
  late String id;
  late String? name;

  MusicBase(
      this.id,
    {this.name});

  MusicBase.fromJson(dynamic json){
    id = json['id'];
    name = json['name'];
  }

  Map<String,dynamic> toJson(){
    final map = <String,dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
