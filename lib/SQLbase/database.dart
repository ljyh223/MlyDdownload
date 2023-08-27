import 'init.dart';
import 'MusicBase.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as dev;
class MusicDao{

  static MusicDao? _instance;
  static MusicDao getInstance() => _instance ??= MusicDao();

  ///插入数据
  Future<int> insert(String songListId, MusicBase bean) async{
    Database db = await DBManager.getInstance().getDatabase;
    return await db.insert("Music_$songListId", bean.toJson());
  }

  // 修改数据
  // Future<int> update(String songListId, String id) async{
  //   Database db = await DBManager.getInstance().getDatabase;
  //   await db.update(table, values);
  // }
  ///查询表是否存在
  Future<bool> isTableExits(String songListId) async {
    //内建表sqlite_master
    var sql ="SELECT * FROM sqlite_master WHERE TYPE = 'table' AND NAME = 'Music_$songListId'";
    Database db = await DBManager.getInstance().getDatabase;
    var res=await db.rawQuery(sql);
    var returnRes = res!=null && res.length > 0;
    return returnRes;
  }

  ///删除数据
  Future<int> delete(String songListId, String id) async{
    Database db = await DBManager.getInstance().getDatabase;
    return await db.delete("Music_$songListId",where:'${DBManager.id} = ?',whereArgs:[id]);
  }

  ///删除全部数据
  Future<int> deleteAll(String songListId) async{
    Database db = await DBManager.getInstance().getDatabase;
    return await db.delete("Music_$songListId");
  }

  ///查询数据
  Future<List<MusicBase>> query(String songListId, String id) async {
    Database db = await DBManager.getInstance().getDatabase;
    var result = await db.query("Music_$songListId", where: '${DBManager.id} = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return result.map((e) => MusicBase.fromJson(e)).toList();
    } else {
      return [];
    }
  }
  //查询所有
  Future<List<MusicBase>> queryAll(String songListId) async {
    Database db = await DBManager.getInstance().getDatabase;
    var result = await db.query("Music_$songListId");
    if (result.isNotEmpty) {
      return result.map((e) => MusicBase.fromJson(e)).toList();
    } else {
      return [];
    }
  }

//  根据doubanId查询判断是否存在
  Future<bool> isExist(String songListId, String id) async {
    Database db = await DBManager.getInstance().getDatabase;
    var result = await db.query("Music_$songListId", where: '${DBManager.id} = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> creatDB(String songListId) async {
    Database db = await DBManager.getInstance().getDatabase;
    await db.execute('''
      CREATE TABLE Music_$songListId(
      id TEXT PRIMARY KEY,
      name TEXT)
      ''');

  }
}
