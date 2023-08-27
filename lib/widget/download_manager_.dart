import 'dart:async';

// StreamController<List<String>> progressStreamController = StreamController<List<String>>();
// Stream<List<String>> get progressStream => progressStreamController.stream;


// 创建多个流，每个流用于一个文件的下载进度
StreamController<Map<String, FileDownloadInfo>> fileStreamController = StreamController<Map<String, FileDownloadInfo>>();
Stream<Map<String, FileDownloadInfo>> get fileProgressStream => fileStreamController.stream;
void disposeProgressController() {
  fileStreamController.close();
}


class FileDownloadInfo {
  final String id;
  final String fileName;
  final double progress;
  final bool isComplete;

  FileDownloadInfo(this.id, this.fileName, this.progress, this.isComplete);
}