import 'package:flutter/services.dart';
class WriteMetadata{
  writemetadata(Map<String, String> data) async {
    MethodChannel platformChannel = const MethodChannel('com.example.mysic_down/platform');
    return await platformChannel.invokeMethod('metadataWrite', data);
  }
}
