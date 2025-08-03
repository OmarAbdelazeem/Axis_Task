import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  /// Request platform-specific permissions for saving images
  static Future<Map<String, dynamic>> requestImageSavePermissions() async {
    bool hasPermission = false;
    bool isPermanentlyDenied = false;

    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();
      
      hasPermission = statuses[Permission.storage] == PermissionStatus.granted ||
                     statuses[Permission.manageExternalStorage] == PermissionStatus.granted;
      
      var storageStatus = await Permission.storage.status;
      var manageStorageStatus = await Permission.manageExternalStorage.status;
      isPermanentlyDenied = storageStatus.isPermanentlyDenied || manageStorageStatus.isPermanentlyDenied;
    } else if (Platform.isIOS) {
      var photosStatus = await Permission.photosAddOnly.request();
      hasPermission = photosStatus.isGranted;
      isPermanentlyDenied = photosStatus.isPermanentlyDenied;
    }

    return {
      'hasPermission': hasPermission,
      'isPermanentlyDenied': isPermanentlyDenied,
    };
  }

  /// Check current permission status without requesting
  static Future<Map<String, dynamic>> checkImageSavePermissionStatus() async {
    if (Platform.isAndroid) {
      var storageStatus = await Permission.storage.status;
      var manageStorageStatus = await Permission.manageExternalStorage.status;
      
      return {
        'hasPermission': storageStatus.isGranted || manageStorageStatus.isGranted,
        'isPermanentlyDenied': storageStatus.isPermanentlyDenied || manageStorageStatus.isPermanentlyDenied,
        'storageStatus': storageStatus,
        'manageStorageStatus': manageStorageStatus,
      };
    } else if (Platform.isIOS) {
      var photosStatus = await Permission.photosAddOnly.status;
      
      return {
        'hasPermission': photosStatus.isGranted,
        'isPermanentlyDenied': photosStatus.isPermanentlyDenied,
        'photosStatus': photosStatus,
      };
    }
    
    return {
      'hasPermission': false,
      'isPermanentlyDenied': false,
    };
  }
} 