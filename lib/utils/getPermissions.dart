

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as dev;

Future<bool> getPermissions() async {
  bool gotPermissions = false;

  var androidInfo = await DeviceInfoPlugin().androidInfo;
  var release = androidInfo.version.release; // Version number, example: Android 12
  var sdkInt = androidInfo.version.sdkInt; // SDK, example: 31
  var manufacturer = androidInfo.manufacturer;
  var model = androidInfo.model;

  dev.log('Android $release (SDK $sdkInt), $manufacturer $model');

    var storage = await Permission.storage.status;

    if (storage != PermissionStatus.granted) {
      await Permission.storage.request();
    }

    if (sdkInt >= 30) {
      var storageExternal = await Permission.manageExternalStorage.status;

      if (storageExternal != PermissionStatus.granted) {
        await Permission.manageExternalStorage.request();
      }

      storageExternal = await Permission.manageExternalStorage.status;

      if (storageExternal == PermissionStatus.granted
          && storage == PermissionStatus.granted) {
        gotPermissions = true;
      }
    } else {
      // (SDK < 30)
      storage = await Permission.storage.status;

      if (storage == PermissionStatus.granted) {
        gotPermissions = true;
      }
    }


  return gotPermissions;
}