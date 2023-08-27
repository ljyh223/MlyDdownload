import 'dart:async';


import 'package:flutter/material.dart';
import '../src/getSong.dart';
import '../SQLbase/Music.dart';
import 'MusicItem.dart';
import 'dart:developer' as dev;
import '../utils/Counter.dart';
class MusicList extends StatefulWidget {
  MusicList(this.id, this.ids);

  final String id;
  final Map<String, Music> ids;


  @override
  State<MusicList> createState() => _MusicList(id, ids: ids);
}

class _MusicList extends State<MusicList> {
  final String id;
  final Map<String, Music> ids;

  _MusicList(this.id, {required this.ids});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Map<String, dynamic>>(
        future: getSong().getAll_Song(Goladeid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // 请求已结束
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // 请求失败，显示错误
              return Text("Error: ${snapshot.error}");
            } else {
              // 请求成功，显示数据
              var value = snapshot.data;
              var items =
              List<ListItem>.from(List.from(value['songs']).map((e) {
                //此处name为filename
                String artist = getName(
                    List.from(e["ar"]).map((r) => r['name']).toList());
                ids.addAll({
                  e["id"].toString(): Music(
                      e["id"].toString(),
                      e['name'],
                      artist,
                      e['al']['name'],
                      '$artist - ${e['name']}',
                      e['al']['picUrl'])
                });
                return MessageItem("${e["name"]}", 'Artist: ${List.from(e["ar"])
                    .map((r) => r['name'])
                    .toList()}',e['id'].toString());
              }));

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  int itemNumber = index + 1;
                  return ListTile(
                    title: item.buildTitle(context),
                    leading: Text('$itemNumber'),
                    subtitle: item.buildSubtitle(context),
                    trailing: const Icon(
                      Icons.check, color: Colors.green,),
                  );
                },
              );
            }
          } else {
            // 请求未结束，显示loading
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
  getName(List<dynamic> artists){
    String artist;
    if(artists.length<=3){
      artist=artists.join(' ');
    }else{
      artist=artists.sublist(0,3).join(' ');
    }
    return artist;
  }
}

// ListView.builder(
// // Let the ListView know how many items it needs to build.
// itemCount: items.length,
// // Provide a builder function. This is where the magic happens.
// // Convert each item into a widget based on the type of item it is.
// itemBuilder: (context, index) {
// final item = items[index];
// int itemNumber = index + 1;
// return ListTile(
// title: item.buildTitle(context),
// leading: Text('$itemNumber'),
// subtitle: item.buildSubtitle(context),
// trailing: const Icon(Icons.check,color: Colors.green,),
// );
// },
// ),
