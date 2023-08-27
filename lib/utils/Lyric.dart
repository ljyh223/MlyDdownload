
import 'package:mysic_down/src/getLyric.dart';
class Lyric{
  mergedLyric(String id,bool translation) async{


    var lyric=await getLyric().getPlaylist(id,translate: translation);
    return _mergedLyric(lyric);
  }
  _mergedLyric(Map<String ,String> lyric){
    if(lyric['tlyric']!.isEmpty) return lyric['lyric'];

    var lyric0=lyric['lyric'];
    var tlyric=lyric['tlyric'];
    var tlyricMap={};
    var merged="";
    for (var line in tlyric!.split('\n')){
      var parts=line.split(']');
      if (parts[0].isEmpty) continue;
      var time=parts[0].substring(1,parts[0].length);
      var text=parts[1];
      tlyricMap[time]=text;
    }

    for (var line in lyric0!.split('\n')){
      var parts=line.split(']');
      if (parts[0].isEmpty) continue;
      var time=parts[0].substring(1,parts[0].length);
      var text=parts[1];
      if (tlyricMap.containsKey(time)){
        merged+="[$time]$text\n[$time]${tlyricMap[time]}\n";
      }else{
        merged+="[$time]$text\n";
      }
    }
    return merged;


  }
}