import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DBManager{
  final int _version = 4;//版本号
  final String _databaseName = 'Music.db';//数据库名称

  static const String id = 'id';//primary key
  static const String name = 'name';//电影海报


  static DBManager? _instance;
  static DBManager getInstance() => _instance ??= DBManager();

  static Database? _database;
  Future<Database> get getDatabase async => _database ??= await _initSQl();

  ///初始化数据库
  Future<Database> _initSQl() async{
    var dbPath = await getDatabasesPath();
    var path = join(dbPath,_databaseName);
    return await openDatabase(path,version: _version,onCreate: _onCreate);
  }

  ///创建表
  Future _onCreate(Database db,int version) async{

  }
}
