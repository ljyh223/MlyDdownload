import 'dart:convert';

import '../core/crypto.dart';

class getLyric {
  Future<Map<String, String>> getPlaylist(String id,
      {bool translate = true}) async {
    var params = {
      "id": id,
      "tv": "-1",
      "rv": "-1",
      "lv": "-1",
      "kv": "-1",
      'csrf_token': '2bc2e67d3d490fdd844ffa112b5ea73d'
    };

    Map<String, dynamic> resp =
        jsonDecode(await src().wePost("/api/song/lyric?_nmclfl=1", params));
    return {
      "lyric": resp['lrc']['lyric'],
      'tlyric': translate && !resp.containsKey('pureMusic') ? resp["tlyric"]["lyric"] : ""
    };
  }
}
