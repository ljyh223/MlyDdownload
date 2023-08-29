
import 'dart:async';

var downloadCount=StreamController<int>();


class downFile{
  late String id;
  late String url;
  late String filename;
  late String type;


  downFile(
      this.id,
      this.url,
      this.filename,
      this.type);

  downFile.fromJson(dynamic json){
    url = json['url'];
    filename = json['name'];
    id = json['id'];
    type = json['type'];
  }

  Map<String,dynamic> toJson(){
    final map = <String,dynamic>{};
    map['url'] = url;
    map['name'] = filename;
    map['id'] = id;
    map['type'] = type;
    return map;
  }
}



class FileDownloadInfo {
  late String id;
  late String fileName;
  late double progress;
  late bool isComplete;

  FileDownloadInfo(this.id, this.fileName, this.progress, this.isComplete);



  // FileDownloadInfo.fromJson(dynamic json){
  //   id = json['id'];
  //   fileName = json['fileName'];
  //   progress = json['progress'];
  //   isComplete = json['isComplete'];
  // }
}