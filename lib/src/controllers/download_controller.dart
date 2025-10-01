
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/download_status.dart';

/// Abstract base class for download controllers.
abstract class DownloadController implements ChangeNotifier {
  /// The current download status.
  DownloadStatus get downloadStatus;

  /// The download progress as a value between 0.0 and 1.0.
  double get progress;

  /// The name of the file being downloaded.
  String get fileName;

  /// Starts the download process.
  void startDownload();

  /// Stops/cancels the current download.
  void stopDownload();

  /// Opens the downloaded file.
  void openDownload();

  /// Checks if the file already exists on disk.
  Future<void> checkFileExists();
}

/// Real implementation of [DownloadController] that handles actual file downloads.
class RealDownloadController extends DownloadController with ChangeNotifier {
  /// Creates a new [RealDownloadController].
  RealDownloadController({
    required this.fileName,
    required this.downloadUrl,
    DownloadStatus initialStatus = DownloadStatus.notDownloaded,
    double initialProgress = 0.0,
    required VoidCallback onOpenDownload,
  })  : _downloadStatus = initialStatus,
        _progress = initialProgress,
        _onOpenDownload = onOpenDownload;

  @override
  final String fileName;

  /// The URL to download the file from.
  final String downloadUrl;

  DownloadStatus _downloadStatus;
  @override
  DownloadStatus get downloadStatus => _downloadStatus;

  double _progress;
  @override
  double get progress => _progress;

  final VoidCallback _onOpenDownload;

  bool _isDownloading = false;
  http.Client? _httpClient;

  @override
  Future<void> checkFileExists() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        _downloadStatus = DownloadStatus.downloaded;
        _progress = 1.0;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error checking file existence: $e');
    }
  }

  @override
  void startDownload() {
    if (_downloadStatus == DownloadStatus.notDownloaded) {
      _doRealDownload();
    }
  }

  @override
  void stopDownload() {
    if (_isDownloading) {
      _isDownloading = false;
      _httpClient?.close();
      _downloadStatus = DownloadStatus.notDownloaded;
      _progress = 0.0;
      notifyListeners();
    }
  }

  @override
  void openDownload() {
    if (_downloadStatus == DownloadStatus.downloaded) {
      _onOpenDownload();
    }
  }

  Future<void> _doRealDownload() async {
    _isDownloading = true;
    _downloadStatus = DownloadStatus.fetchingDownload;
    notifyListeners();

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      _httpClient = http.Client();

      _downloadStatus = DownloadStatus.downloading;
      notifyListeners();

      final request = http.Request('GET', Uri.parse(downloadUrl));
      final response = await _httpClient!.send(request);

      if (response.statusCode == 200) {
        final contentLength = response.contentLength ?? 0;
        var downloadedBytes = 0;

        final bytes = <int>[];

        await for (var chunk in response.stream) {
          if (!_isDownloading) {
            _httpClient?.close();
            return;
          }

          bytes.addAll(chunk);
          downloadedBytes += chunk.length;

          if (contentLength > 0) {
            _progress = downloadedBytes / contentLength;
            notifyListeners();
          }
        }

        await file.writeAsBytes(bytes);
        debugPrint('File downloaded and saved: $filePath');

        if (!_isDownloading) {
          return;
        }

        _downloadStatus = DownloadStatus.downloaded;
        _progress = 1.0;
        _isDownloading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to download: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Download error: $e');
      _downloadStatus = DownloadStatus.notDownloaded;
      _progress = 0.0;
      _isDownloading = false;
      notifyListeners();
    } finally {
      _httpClient?.close();
    }
  }

  @override
  void dispose() {
    _httpClient?.close();
    super.dispose();
  }
}