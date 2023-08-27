import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'encrypt_ext.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'dart:developer' as dev;

// import 'package:pointycastle/asymmetric/api.dart';
import 'dart:math';

class weapi {
  static Uint8List rand() {
    var base62 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    return Uint8List.fromList(List.generate(16, (int index) {
      return base62.codeUnitAt(Random().nextInt(62));
    }));
  }

  static String rsaEncrypt(List<int> content) {
    var key = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDgtQn2JZ34ZC28NWYpAUd98iZ37BUrX/aKzmFbt7clFSs6sXqHauqKWqdtLkF2KexO40H1YTX8z2lSgBBOAxLsvaklV8k4cBFK9snQXE9/DDaFt6Rr7iVZMldczhC0JNgTz+SHXT6CBHuX3e9SdB1Ua44oncaTWz7OBGLbCiK45wIDAQAB\n-----END PUBLIC KEY-----";

    final parser = RSAKeyParser();

    return Encrypter(RSAExt(publicKey: parser.parse(key) as RSAPublicKey))
        .encryptBytes(content)
        .base16;
  }

  static String aesEncrypt(String content, Key _key) {
    final iv = IV.fromUtf8('0102030405060708');

    final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    return encrypter
        .encrypt(content, iv: iv)
        .base64;
  }

  static crypto(String o) {
    Uint8List secretKey = rand();
    var key = "0CoJUm6Qyw8W8jud";
    var params = aesEncrypt(aesEncrypt(o, Key.fromUtf8(key)), Key(secretKey));
    var encSecKey = rsaEncrypt(List.from(secretKey.reversed));
    return {"params": params, "encSecKey": encSecKey};
  }

}
String currentTimeMillis({int w=10}) {
  var time=DateTime.now().millisecondsSinceEpoch.toString();
  if (w==10) time=time.substring(0,time.length-3);
  return time;
}


class eapi {

  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  static String aesEncrypt(String content) {
    final key = Key.fromUtf8('e82ckenh8dichen8');
    final encrypt = Encrypter(AES(key, mode: AESMode.ecb));
    final iv = IV.fromSecureRandom(0);
    return encrypt
        .encrypt(content,iv: iv)
        .base16
        .toUpperCase();
  }

  static crypto(String url, Map<String, dynamic> args,Map<String ,dynamic> header) {

    var data = {
      "ids": args['ids'].toString(),
      "level": "lossless",
      "encodeType":"flac",
      "header": header
    };
    var body = jsonEncode(data);
    var message = "nobody${args['url']}use${body}md5forencrypt";
    var messageMD5 = generateMd5(message);
    var params = '${args['url']}-36cd479b6b5-$body-36cd479b6b5-$messageMD5';
    return aesEncrypt(params);
  }
}

class src {
  String HOST = "https://music.163.com";

  wePost_encypto(String url, Map<String, dynamic> args) async {
    var body = weapi.crypto(jsonEncode(args));
    var result = await http.post(
        Uri.parse('$HOST$url'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
          "cookie": "NMTID=00O2XZp-a9gJy-Xkk3ht32Ipki1l18AAAGHh3oyHQ;os=adnroid;__csrf=2bc2e67d3d490fdd844ffa112b5ea73d",
          "User-Agent": 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36',
          'referer': HOST
        },
        body: "params=${Uri.encodeQueryComponent(
            body["params"])}&encSecKey=${Uri.encodeQueryComponent(
            body['encSecKey'])}"
    );
    // dev.log(jsonDecode(result.body)['getPlaylist']['trackIds'].toString());
    // dev.log(result.body);
    return result.body;
  }

  wePost(String url, Map<String, dynamic> args) async {
    var result = await http.post(
        Uri.parse('$HOST$url'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
          "cookie": "NMTID=00O2XZp-a9gJy-Xkk3ht32Ipki1l18AAAGHh3oyHQ;os=adnroid;__csrf=2bc2e67d3d490fdd844ffa112b5ea73d",
          "User-Agent": 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36',
          'referer': HOST
        },
        body: Uri(queryParameters: args).query
    );

    return result.body;
  }

  ///args
  ///cookie: user cookie
  ///ids: id list<int>
  ///level: standard, exhigh, lossless, hires, jyeffect(高清环绕声), sky(沉浸环绕声), jymaster(超清母带)
  ///url: url path, replace eapi use api : /api/song/enhance/player/url/v1
  ///{"cookie":"xxx", "ids": [123,456], "level": "lossless", "url"； “/api/song/enhance/player/url/v1”}
  ePost_encrypto(String url, Map<String ,dynamic> args) async {
    var buildver=currentTimeMillis(w: 10);
    var requestId="${currentTimeMillis()}_0${(Random().nextDouble() * 1000)
        .toInt()
        .toString()}";
    var header= {
      "appver": "8.10.05",
      "versioncode": "140",
      "buildver": buildver,
      "resolution": "1920x1080",
      "__csrf": "",
      "os": "android",
      "requestId": requestId,
      "MUSIC_U": args['cookie']
    };
    var message=eapi.crypto(url, args, header);
    var data={'params':message};
    var allHeader={
      'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
      "User-Agent": 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36',
      'cookie': 'osver=; deviceId=; appver=8.10.05; versioncode=140; mobilename=; buildver=$buildver; resolution=1920x1080; __csrf=; os=android; channel=; requestId=$requestId; MUSIC_U=${args['cookie']};NMTID=00O2XZp-a9gJy-Xkk3ht32Ipki1l18AAAGHh3oyHQ;os=adnroid;__csrf=2bc2e67d3d490fdd844ffa112b5ea73d',
      'referer': HOST
    };
    var result = await http.post(
        Uri.parse(url),
        headers: Map.from(header)..addAll(allHeader),
        body: Uri(queryParameters: data).query
    );
    return result.body;
  }

}