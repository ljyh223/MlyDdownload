import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysic_down/widget/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;
import '../utils/getPermissions.dart';
import 'InputDialog.dart';
class setting extends StatefulWidget{
  const setting({super.key});

  @override
  State<StatefulWidget> createState() =>_setting();

}

class _setting extends State<setting>{
  String _path="";
  bool _title=true;
  bool _lyric=true;
  bool _artist=true;
  bool _album = true;
  bool _picture=true;
  bool _tlyric=true;
  bool _tlyric_enabled=true;

  @override
  void initState() {
    super.initState();
    // 在界面初始化时从SharedPreferences中读取开关的状态
    _loadSwitchValue();
  }
  void _loadSwitchValue() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _title = prefs.getBool('title') ?? true; // 如果没有值，默认为true
      _artist = prefs.getBool('artist') ?? true;
      _picture = prefs.getBool('picture') ?? true;
      _lyric = prefs.getBool('lyric') ?? true;
      _tlyric = prefs.getBool('tlyric') ?? true;
      _album =  prefs.getBool("album") ?? true;

      _path= prefs.getString("path") ?? "";
    });
    dev.log(_title.toString());
    dev.log(_artist.toString());
    dev.log(_picture.toString());
    dev.log(_lyric.toString());
    dev.log(_path);
  }

  void _saveSwitchValue(String key,bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
  void _savePathValue(String key,String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body:Container(
        child: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('元数据'),
              tiles: <SettingsTile>[
                SettingsTile.switchTile(
                  onToggle: (value) {
                    setState(() {
                      _artist=value;
                      _saveSwitchValue("artist",value);
                    });
                  },
                  initialValue: _artist,
                  title: const Text('artist'),
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    setState(() {
                      _title=value;
                      _saveSwitchValue("title",value);
                    });
                  },
                  initialValue: _title,
                  title: const Text('title'),
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    setState(() {
                      _album=value;
                      _saveSwitchValue("album",value);
                    });
                  },
                  initialValue: _album,
                  title: const Text('album'),
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    setState(() {
                      _picture=value;
                      _saveSwitchValue("picture",value);
                    });
                  },
                  initialValue: _picture,
                  title: const Text('picture'),
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    setState(() {
                      _lyric=value;
                      _tlyric_enabled=value;
                      _saveSwitchValue("lyric",value);
                    });
                  },
                  initialValue: _lyric,
                  title: const Text('lyric'),
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    setState(() {
                      _tlyric=value;
                      _saveSwitchValue("tlyric",value);
                    });
                  },
                  initialValue: _tlyric,
                  enabled: _tlyric_enabled,
                  title: const Text('translate lyric'),
                )
              ],
            ),
            SettingsSection(
              title: const Text("Path"),
              tiles: <SettingsTile>[
                SettingsTile(
                  title: const Text("Save path"),
                  value: Text(_path),
                  onPressed: (context) async{
                    getPermissions();
                    Permission permission = Permission.manageExternalStorage;
                    PermissionStatus status = await permission.status;

                    if(status.isGranted){

                    }
                    else if (status.isDenied) {
                      dev.log('被拒');
                      WidgetUtils.showToast("请同意外部文件访问权限", Colors.red);
                      return;
                    } else if (status.isPermanentlyDenied) {
                      dev.log('永拒');
                      WidgetUtils.showToast("请同意外部文件访问权限", Colors.red);
                      return;
                    }

                    String _p=await openAndSelectDirectory();
                    if (_p!=""){
                      _savePathValue("path", _p);
                    }
                    setState(() {
                      _path=_p;
                    });
                  },
                )
              ],
            ),
            SettingsSection(
                title: const Text("User"),
                tiles: <SettingsTile>[
                  SettingsTile(
                    title: const Text ("Cookie"),
                    leading: const Icon(Icons.cookie),
                    trailing: const Icon(Icons.edit),
                    onPressed: (context) async {
                      String inputText = await showDialog(
                        context: context,
                        builder: (BuildContext context) => const InputDialog(title: Text("geve me your Cookie"),hintText:"Cookie",max: 1000),
                      );
                      if (inputText!=""){
                        _savePathValue("cookie", inputText);
                      }
                    }
                  ),
                ]
            )

          ],
        ),
      ),
    );
  }
  Future<String> openAndSelectDirectory() async {
    try {
      // 使用file_picker选择目录
      String? directoryPath = await FilePicker.platform.getDirectoryPath();
      if (directoryPath != null) {
        return directoryPath;
      } else {
        dev.log('cancel');
        return "";
      }
    } catch (e) {
      dev.log("error");
      return "";
    }
  }
}