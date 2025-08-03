import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfflineIndicatorWidget extends StatelessWidget {
  final DateTime? lastUpdated;
  final VoidCallback? onRefresh;

  const OfflineIndicatorWidget({
    Key? key,
    this.lastUpdated,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: Colors.orange.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.wifi_off,
            size: 16.sp,
            color: Colors.orange.shade700,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Offline Mode",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (lastUpdated != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    "Last updated: ${_formatLastUpdated(lastUpdated!)}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.orange.shade600,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onRefresh != null) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: onRefresh,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.orange.shade700,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  Icons.refresh,
                  size: 12.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatLastUpdated(DateTime lastUpdated) {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else {
      return "${difference.inDays} days ago";
    }
  }
} 