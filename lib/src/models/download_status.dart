/// Represents the current status of a download.
enum DownloadStatus {
  /// The file has not been downloaded yet.
  notDownloaded,

  /// The download is being initiated and metadata is being fetched.
  fetchingDownload,

  /// The file is currently being downloaded.
  downloading,

  /// The file has been successfully downloaded.
  downloaded,
}