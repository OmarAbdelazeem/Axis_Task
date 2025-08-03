import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:axis_task/src/core/styles/app_colors.dart';
import 'package:axis_task/src/shared/presentation/pages/background_page.dart';
import 'package:axis_task/src/shared/presentation/widgets/arrow_back_button_widget.dart';

class PhotoViewPage extends StatefulWidget {
  final String path;
  final bool fromNet;

  const PhotoViewPage({Key? key, required this.path, required this.fromNet})
      : super(key: key);

  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundPage(
      bottomSafeArea: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25.h,
          ),
          // App Bar with back button and download button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: ArrowBackButtonWidget(),
                ),
                // Download button (only show for network images)
                if (widget.fromNet)
                  GestureDetector(
                    onTap: _isSaving ? null : _saveImage,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: _isSaving ? Colors.grey : Colors.blue,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: _isSaving
                          ? SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Icon(
                              Icons.download,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 25.h,
          ),
          Expanded(
            child: _buildPhotoView(),
          )
        ],
      ),
    );
  }

  // Save image method
  Future<void> _saveImage() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
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
          _isSaving = false;
        });
        
        _showPermissionDialog(isPermanentlyDenied: isPermanentlyDenied);
        return;
      }

      // Download the image
      final response = await http.get(Uri.parse(widget.path));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }

      String? filePath;
      Directory targetDir;

      if (Platform.isAndroid) {
        // Android: Try to save to Downloads folder first
        Directory? downloadsDir;
        try {
          downloadsDir = Directory('/storage/emulated/0/Download');
          if (!await downloadsDir.exists()) {
            downloadsDir = null;
          }
        } catch (e) {
          downloadsDir = null;
        }

        // Fallback to app's Pictures directory
        final appDir = await getExternalStorageDirectory();
        final picturesDir = Directory('${appDir!.path}/Pictures');
        if (!await picturesDir.exists()) {
          await picturesDir.create(recursive: true);
        }

        targetDir = downloadsDir ?? picturesDir;
      } else if (Platform.isIOS) {
        // iOS: Save to app's documents directory
        final appDir = await getApplicationDocumentsDirectory();
        final picturesDir = Directory('${appDir.path}/Pictures');
        if (!await picturesDir.exists()) {
          await picturesDir.create(recursive: true);
        }
        targetDir = picturesDir;
      } else {
        throw Exception('Unsupported platform');
      }

      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${targetDir.path}/$fileName');

      await file.writeAsBytes(response.bodyBytes);
      filePath = file.path;

      // Show success message
      if (mounted) {
        String locationMessage;
        if (Platform.isAndroid) {
          locationMessage = targetDir.path.contains('Download') 
              ? "Image saved to Downloads folder!" 
              : "Image saved to app's Pictures folder!";
        } else {
          locationMessage = "Image saved to app's Pictures folder!";
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(locationMessage),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // Show permission dialog
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
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: Text(actionText),
            ),
          ],
        );
      },
    );
  }

  // Build photo view from asset or url
  Widget _buildPhotoView() {
    // Path is url from net
    if (widget.fromNet) {
      return Hero(
        tag: widget.path,
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(
            widget.path,
          ),
        ),
      );
    } else {
      // Path is path from asset
      return Hero(
        tag: widget.path,
        child: PhotoView(
          imageProvider: AssetImage(
            widget.path,
          ),
        ),
      );
    }
  }
}
