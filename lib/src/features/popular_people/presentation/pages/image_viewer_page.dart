import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:axis_task/src/shared/presentation/pages/background_page.dart';
import 'package:axis_task/src/shared/presentation/widgets/custom_app_bar_widget.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:axis_task/src/core/styles/app_colors.dart';
import 'package:axis_task/src/core/utils/image_saver.dart';

class ImageViewerPage extends StatefulWidget {
  final String imageUrl;
  final String? personName;

  const ImageViewerPage({
    Key? key,
    required this.imageUrl,
    this.personName,
  }) : super(key: key);

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  bool isSaving = false;
  bool isSaved = false;

  // Key for scaffold to open drawer
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BackgroundPage(
      scaffoldKey: _key,
      withDrawer: false,
      child: Column(
        children: [
          // Custom App Bar
          CustomAppBarWidget(
            title: Text(
              widget.personName ?? "Image Viewer",
              style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(
                onPressed: isSaving ? null : _saveImage,
                icon: isSaving
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : Icon(
                        isSaved ? Icons.check : Icons.download,
                        size: 20,
                        color: isSaved ? Colors.green : Colors.black,
                      ),
              ),
            ],
          ),
          // Image Viewer
          Expanded(
            child: PhotoView(
              imageProvider: NetworkImage(widget.imageUrl),
              loadingBuilder: (context, event) => Center(
                child: CircularProgressIndicator(
                  value: event?.expectedTotalBytes != null
                      ? event!.cumulativeBytesLoaded / event!.expectedTotalBytes!
                      : null,
                ),
              ),
              errorBuilder: (context, error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 50.sp,
                      color: Colors.red,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Failed to load image",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              initialScale: PhotoViewComputedScale.contained,
              heroAttributes: PhotoViewHeroAttributes(tag: widget.imageUrl),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveImage() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      // Request permissions first
      bool hasPermission = false;
      bool isPermanentlyDenied = false;
      
      if (Platform.isAndroid) {
        // Request Android permissions
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
          Permission.manageExternalStorage,
        ].request();

        hasPermission = statuses[Permission.storage] == PermissionStatus.granted ||
                       statuses[Permission.manageExternalStorage] == PermissionStatus.granted;
        
        // Check if permanently denied
        var storageStatus = await Permission.storage.status;
        var manageStorageStatus = await Permission.manageExternalStorage.status;
        isPermanentlyDenied = storageStatus.isPermanentlyDenied || manageStorageStatus.isPermanentlyDenied;
        
      } else if (Platform.isIOS) {
        // Request iOS permissions - use photosAddOnly for saving to gallery
        var photosStatus = await Permission.photosAddOnly.request();
        hasPermission = photosStatus.isGranted;
        isPermanentlyDenied = photosStatus.isPermanentlyDenied;
      }

      if (!hasPermission) {
        setState(() {
          isSaving = false;
        });
        
        _showPermissionDialog(isPermanentlyDenied: isPermanentlyDenied);
        return;
      }

      final filePath = await ImageSaver.saveImage(widget.imageUrl);
      
      setState(() {
        isSaved = true;
        isSaving = false;
      });

      // Show success message
      String locationMessage = "Image saved successfully!";
      if (filePath != null) {
        if (Platform.isAndroid) {
          if (filePath.contains('/storage/emulated/0/Download')) {
            locationMessage = "Image saved to Downloads folder!";
          } else {
            locationMessage = "Image saved to app's Pictures folder!";
          }
        } else if (Platform.isIOS) {
          locationMessage = "Image saved to Photo Library!";
        }
      }
      _showSnackBar(locationMessage);
    } catch (e) {
      setState(() {
        isSaving = false;
      });
      
      if (e.toString().contains('Permission denied')) {
        _showPermissionDialog();
      } else {
        _showSnackBar("Failed to save image: ${e.toString()}");
      }
    }
  }

  void _showPermissionDialog({bool isPermanentlyDenied = false}) {
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
              onPressed: () async {
                Navigator.of(context).pop();
                await ImageSaver.openSettings();
              },
              child: Text(actionText),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
} 