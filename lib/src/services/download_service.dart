import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

/// A service class providing utility methods for file management.
class DownloadService {
  /// Gets the full file path for a given filename in the app's documents directory.
  static Future<String> getFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  /// Checks if a file with the given filename exists.
  static Future<bool> fileExists(String fileName) async {
    try {
      final filePath = await getFilePath(fileName);
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      debugPrint('Error checking file existence: $e');
      return false;
    }
  }

  /// Opens a file with the given filename using the system's default application.
  static Future<OpenResult> openFile(String fileName) async {
    final filePath = await getFilePath(fileName);
    return await OpenFile.open(filePath);
  }

  /// Deletes a file with the given filename if it exists.
  static Future<void> deleteFile(String fileName) async {
    try {
      final filePath = await getFilePath(fileName);
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error deleting file: $e');
    }
  }
}