import 'dart:math';

import 'package:mysic_down/src/down.dart';

class Music{
  late String id;
  late String title;
  late String artist;
  late String album;
  late String name;
  late String picture;

  Music(
      this.id,
      this.title,
      this.artist,
      this.album,
      this.name,
      this.picture,);

  Music.fromJson(dynamic json){
    id = json['id'];
    title = json['title'];
    artist = json['artist'];
    album = json['album'];
    name = json['name'];
    picture = json['picture'];
  }

  Map<String,dynamic> toJson(){
    final map = <String,dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['artist'] = artist;
    map['name'] = name;
    map['album'] = album;
    map['picture'] = picture;

    return map;
  }
}
