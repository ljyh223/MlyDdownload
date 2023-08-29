class FileDownloadInfo {
  final String id;
  final String fileName;
  final double progress;
  final bool isComplete;

  FileDownloadInfo(this.id, this.fileName, this.progress, this.isComplete);
}