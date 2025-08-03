import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDialogWidget {
  static void show({
    required BuildContext context,
    required bool isPermanentlyDenied,
    required VoidCallback onOpenSettings,
  }) {
    String message;
    String actionText;
    
    if (isPermanentlyDenied) {
      message = Platform.isIOS 
          ? "Photos permission is permanently denied. Please enable it in Settings to save images."
          : "Storage permission is permanently denied. Please enable it in Settings to save images.";
      actionText = "Open Settings";
    } else {
      message = Platform.isIOS
          ? "Photos permission is required to save images to your photo library."
          : "Storage permission is required to save images to your device.";
      actionText = "Open Settings";
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Required'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message, style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to enable:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      Platform.isIOS
                          ? "1. Tap 'Open Settings'\n2. Tap 'Photos'\n3. Select 'Add Photos Only' or 'All Photos'"
                          : "1. Tap 'Open Settings'\n2. Tap 'Permissions'\n3. Enable 'Storage'",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onOpenSettings();
              },
              child: Text(actionText),
            ),
          ],
        );
      },
    );
  }
} 