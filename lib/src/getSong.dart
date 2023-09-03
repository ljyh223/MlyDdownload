import 'dart:convert';
import 'dart:core';
import '../SQLbase/MusicBase.dart';
import '../core/crypto.dart';
import '../utils/Counter.dart';

class getSong {
  Future<List<MusicBase>> getPlaylist(String id, {bool ids = false}) async {
    var params = {
      "id": id,
      "n": "100000",
      "s": "8",
      'csrf_token': '2bc2e67d3d490fdd844ffa112b5ea73d'
    };

    Map<String, dynamic> resp =
        jsonDecode(await src().wePost("/api/v6/playlist/detail", params));
    List<dynamic> ids = resp["playlist"]["trackIds"];
    globalName=resp['playlist']['name'];
    return List<MusicBase>.from(ids.map((e) => MusicBase.fromJson({"id":e['id'].toString()})));
  }

  Future<Map<String, dynamic>> getAll_Song(String id,
      {int offset = 0, int limit = 0}) async {

    List<MusicBase> trackIds = await getPlaylist(id);
    // dev.log(trackIds[0].id.toString());
    String _ids;
    if (limit - offset == 0) {
      _ids = trackIds.map((e) => jsonEncode({'id': e.id})).toList().join(',');
    } else {
      _ids = trackIds
          .sublist(offset, offset + limit)
          .map((e) => jsonEncode({'id': e.id}))
          .toList()
          .join(',');
    }
    var data = {"c": "[$_ids]"};
    return jsonDecode(await src().wePost_encypto("/weapi/v3/song/detail", data));
    // return resp;
  }
}
