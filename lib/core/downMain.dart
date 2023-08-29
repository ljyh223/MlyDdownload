
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

import '../SQLbase/Music.dart';
import '../SQLbase/MusicBase.dart';
import '../SQLbase/database.dart';
import '../src/down.dart';
import '../utils/Lyric.dart';
import '../utils/WriteMetadata.dart';
import '../widget/utils.dart';
DownloadFiles(List<downFile> files,String id ,Map<String, Music> ids) async {

  Permission permission = Permission.manageExternalStorage;
  PermissionStatus status = await permission.status;

  if(status.isGranted){
    dev.log("ok");
  }
  else if (status.isDenied) {
    dev.log('被拒');
    WidgetUtils.showToast("请手动同意外部文件访问权限", Colors.red);
    return;
  } else if (status.isPermanentlyDenied) {
    dev.log('永拒');
    WidgetUtils.showToast("请同意外部文件访问权限", Colors.red);
    return;
  }


  var count=0;
  var allCurrentProgress = List.generate(files.length, (index) => 0.0);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  for (var i = 0; i < files.length; i++) {
    if (files[i].filename == "") return;
    //部分音乐无法下载
    if (files[i].url == "null"){
      allCurrentProgress[i] = -1;
      downloadInfos[i].sink.add(allCurrentProgress);
      continue;
    }
    Dio dio = Dio();

    File f=File(files[i].filename);

    if(await f.exists()){
      dev.log('file exiata true');
      f.delete();
    }
    await dio.download(files[i].url, files[i].filename,
        onReceiveProgress: (received, total) {
          double currentProgress = -1.0;

          if (total != -1) {
            currentProgress = received / total;
            currentProgress = double.parse(currentProgress.toStringAsFixed(2));

            allCurrentProgress[i] = currentProgress;
            downloadInfos[i].sink.add(allCurrentProgress);
          }
        });
    count+=1;
    closeDownloadInfos(i);

    var enLyric = prefs.getBool('lytic') ?? true;
    var enTlyric = prefs.getBool('lytic') ?? true;
    var lyric = '';
    if (enLyric) {
      lyric = await Lyric().mergedLyric(files[i].id, enTlyric);
    }
    var data = {
      'url':files[i].url,
      'file_path': files[i].filename,
      'type': files[i].type,
      //对于空字符，kotlin那边会处理
      'lyric': lyric,
      'artist': prefs.getBool('artist') ?? true ? ids[files[i].id]!.artist : "",
      'title': prefs.getBool('title') ?? true ? ids[files[i].id]!.title : "",
      'album': prefs.getBool('album') ?? true ? ids[files[i].id]!.album : "",
      'pic_url': prefs.getBool('picture') ?? true ? ids[files[i].id]!.picture : "https://p2.music.126.net/rsL8HuJiFgXDmCv7U9-32Q==/109951164659404322.jpg"
    };
    // dev.log(jsonEncode(data));
    MusicDao.getInstance().insert(id, MusicBase(files[i].id,name: files[i].filename.split('/').last));
    dev.log("${files[i].filename}--->${(await WriteMetadata().writemetadata(data)).toString()}");
  }
  WidgetUtils.showToast("下载完成,共计$count", Colors.green);
}
