import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:axis_task/src/core/utils/permission_helper.dart';

class ImageSaver {
  static Future<bool> _requestPermissions() async {
    final result = await PermissionHelper.requestImageSavePermissions();
    return result['hasPermission'] as bool;
  }

  static Future<Map<String, dynamic>> checkPermissionStatus() async {
    return await PermissionHelper.checkImageSavePermissionStatus();
  }

  static Future<String?> saveImage(String imageUrl) async {
    try {
      // Request permissions
      bool hasPermission = await _requestPermissions();
      if (!hasPermission) {
        throw Exception('Permission denied');
      }

      // Download the image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }

      // Create a unique filename
      final fileName = "tmdb_${DateTime.now().millisecondsSinceEpoch}.jpg";
      String? filePath;

      if (Platform.isIOS) {
        // Check if running on simulator
        final isSimulator = _isIOSSimulator();
        
        if (isSimulator) {
          // iOS Simulator: Save to app documents directory
          final directory = await getApplicationDocumentsDirectory();
          final picturesDir = Directory('${directory.path}/Pictures');
          if (!await picturesDir.exists()) {
            await picturesDir.create(recursive: true);
          }
          
          final file = File('${picturesDir.path}/$fileName');
          await file.writeAsBytes(response.bodyBytes);
          filePath = file.path;
          
          if (kDebugMode) {
            print('iOS Simulator: Image saved to app documents: $filePath');
            print('Note: This is a simulator limitation. Test on real device for Photos app access.');
          }
        } else {
          // Real iOS Device: Save to gallery using gallery_saver_plus
          final tempDir = await getTemporaryDirectory();
          final tempFile = File('${tempDir.path}/$fileName');
          await tempFile.writeAsBytes(response.bodyBytes);

          final result = await GallerySaver.saveImage(
            tempFile.path,
            albumName: 'TMDB Images',
          );
          
          if (result == true) {
            filePath = 'Gallery/TMDB Images';
            
            // Clean up temporary file
            if (await tempFile.exists()) {
              await tempFile.delete();
            }
          } else {
            throw Exception('Failed to save image to gallery');
          }
        }
      } else if (Platform.isAndroid) {
        // Android: Save to gallery using gallery_saver_plus
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(response.bodyBytes);

        final result = await GallerySaver.saveImage(
          tempFile.path,
          albumName: 'TMDB Images',
        );
        
        if (result == true) {
          filePath = 'Gallery/TMDB Images';
          
          // Clean up temporary file
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        } else {
          throw Exception('Failed to save image to gallery');
        }
      }

      return filePath;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving image: $e');
      }
      rethrow;
    }
  }

  static Future<bool> hasPermissions() async {
    final result = await PermissionHelper.checkImageSavePermissionStatus();
    return result['hasPermission'] as bool;
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }

  // Helper method to detect iOS Simulator
  static bool _isIOSSimulator() {
    return Platform.isIOS && 
           (Platform.environment.containsKey('SIMULATOR_DEVICE_NAME') ||
            Platform.environment.containsKey('SIMULATOR_HOST_HOME') ||
            Platform.environment.containsKey('SIMULATOR_ROOT'));
  }
} 