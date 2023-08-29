import 'dart:convert';
import 'core/downMain.dart';

import 'package:flutter/material.dart';
import 'package:mysic_down/core/crypto.dart';
import 'package:mysic_down/utils/Counter.dart';
import 'package:mysic_down/widget/MusicItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widget/setting.dart';
import 'widget/InputDialog.dart';
import 'dart:developer' as dev;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'widget/MusicList.dart';
import 'widget/utils.dart';
import 'SQLbase/Music.dart';
import 'SQLbase/database.dart';
import 'src/down.dart';
import 'utils/specialStr.dart';
void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M ly Down',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'M ly Down'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool welcome = true;
  late String id;
  late Widget _dynamicWidgets = const Text("welcome to");
  late Map<String, Music> ids = {};

  _getToggleChild() async {

    if (welcome) {
      setState(() {
        _dynamicWidgets = const Text("welcome to");
      });
    } else {
      ids = {};
      dev.log("PlayListId is $id,,$id");
      setState(() {
        _dynamicWidgets = MusicList(id, ids);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _dynamicWidgets,
      ),
      floatingActionButton: SpeedDial(children: [
        //获取歌单
        SpeedDialChild(
            child: const Icon(Icons.play_arrow),
            backgroundColor: Colors.green,
            // get
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: getPlayList ),
        //收藏歌单
        SpeedDialChild(
          child: const Icon(Icons.star_border),
          backgroundColor: Colors.orange,

          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: collectPlayList ,
        ),
        //下载按钮
        SpeedDialChild(
          child: const Icon(Icons.download),
          backgroundColor: Colors.blueAccent,
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: DownloadOnClick,
        ),
      ], child: const Icon(Icons.add)),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.5,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              // drawer的头部控件
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: UnconstrainedBox(
                // 解除父级的大小限制
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(
                    'https://p2.music.126.net/rsL8HuJiFgXDmCv7U9-32Q==/109951164659404322.jpg',
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("设置"),
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const setting()));
              },
            ),
          ],
        ),
      ),
    );
  }
  DownloadOnClick() async{

    if (await MusicDao.getInstance().isTableExits(id)) {

      List<String> myid = (await MusicDao.getInstance().queryAll(id))
          .map((e) => e.id)
          .toList();
      List<String> allId = ids.values.map((e) => e.id).toList();
      List<String> complementId =
      allId.where((element) => !myid.contains(element)).toList();
      // dev.log('开始下载${complementId.toString()}');
      if (complementId.isEmpty) {
        WidgetUtils.showToast("无需下载更新", Colors.orange);
        return;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var saveFilepath = prefs.getString("path") ?? "";
      if(saveFilepath ==""){
        WidgetUtils.showToast("请在设置中填写好保存路径", Colors.red);
        return;
      }
      String cookie = prefs.getString("cookie") ?? "";
      if (cookie==""){
        WidgetUtils.showToast("请在设置中填写好cookie", Colors.red);
        return;
      }
      WidgetUtils.showToast("下载已开始，共计${complementId.length}", Colors.blue);
      var args = {
        'cookie': cookie,
        'ids': complementId.map((e) => int.parse(e)).toList(),
        'level': 'lossless',
        'url': '/api/song/enhance/player/url/v1'
      };
      var resp = jsonDecode(await src().ePost_encrypto(
          'https://interface.music.163.com/eapi/song/enhance/player/url/v1',
          args));
      // dev.log(jsonEncode(resp));

      List<downFile> respJson=[];
      for (var e in List.from(resp['data'])){
        var tempFilename='$saveFilepath/${specialStr.re(GloadName)}/${("${specialStr.re(ids[e['id'].toString()]?.name ?? "")}.${e['type'] ?? "null"}")}';
        respJson.add(downFile(e['id'].toString(), e['url'] ?? "null",
            tempFilename,e['type'].toString().toLowerCase()));

      }

      List<ListItem> downIds = [];
      ids.forEach((key, value) {
        downIds.add(MessageItem(value.title, 'Artist: ${value.artist}', key));
      });
      creatDownloadInfos();

      await DownloadFiles(respJson,id,ids);
    } else {
      WidgetUtils.showToast("请先收藏歌单哦", Colors.orange);
    }
  }
  getPlayList() async {
    String inputText = await showDialog(
      context: context,
      builder: (BuildContext context) => const InputDialog(
          title: Text("give me your id"), hintText: "id"),
    ) ?? "";
    if (inputText !="") {
      welcome = false;
      id=inputText;
      GloadId=inputText;
      _getToggleChild();

    }
  }
  collectPlayList()async {
    //收藏入数据库
    if (!await MusicDao.getInstance().isTableExits(id)) {
      await MusicDao.getInstance().creatDB(id);
      WidgetUtils.showToast("收藏成功", Colors.green);

    } else {
      WidgetUtils.showToast("已经收藏洛", Colors.orange);
    }
  }

}
