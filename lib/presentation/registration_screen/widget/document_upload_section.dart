import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentUploadSection extends StatelessWidget {
  final List<XFile> uploadedDocuments;
  final Function(List<XFile>) onDocumentsChanged;
  final String selectedBusinessType;

  const DocumentUploadSection({
    Key? key,
    required this.uploadedDocuments,
    required this.onDocumentsChanged,
    required this.selectedBusinessType,
  }) : super(key: key);

  String _getRequiredDocumentText() {
    switch (selectedBusinessType) {
      case 'pharmacy':
        return 'Upload Pharmacy License';
      case 'distributor':
        return 'Upload Distribution License';
      case 'shg':
        return 'Upload SHG Registration Certificate';
      default:
        return 'Upload Business License';
    }
  }

  Future<void> _showImageSourceDialog(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Select Image Source',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  context,
                  'Camera',
                  'camera_alt',
                  () => _pickImage(context, ImageSource.camera),
                ),
                _buildSourceOption(
                  context,
                  'Gallery',
                  'photo_library',
                  () => _pickImage(context, ImageSource.gallery),
                ),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption(
    BuildContext context,
    String title,
    String iconName,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 35.w,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 32,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    Navigator.pop(context);

    try {
      // Request permission
      bool hasPermission = false;
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        hasPermission = status.isGranted;
      } else {
        hasPermission = true; // Gallery doesn't need explicit permission
      }

      if (!hasPermission) {
        _showPermissionDialog(context);
        return;
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80, // Compress for low-bandwidth areas
      );

      if (image != null) {
        final updatedDocuments = List<XFile>.from(uploadedDocuments)
          ..add(image);
        onDocumentsChanged(updatedDocuments);
      }
    } catch (e) {
      _showErrorDialog(context, 'Failed to pick image. Please try again.');
    }
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text(
            'Camera permission is required to capture documents. Please enable it in settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _removeDocument(int index) {
    final updatedDocuments = List<XFile>.from(uploadedDocuments)
      ..removeAt(index);
    onDocumentsChanged(updatedDocuments);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Document Verification',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          _getRequiredDocumentText(),
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),

        // Upload Button
        InkWell(
          onTap: () => _showImageSourceDialog(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: 'cloud_upload',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 32,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Upload Document',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Tap to capture or select from gallery',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Uploaded Documents List
        if (uploadedDocuments.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Text(
            'Uploaded Documents (${uploadedDocuments.length})',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: uploadedDocuments.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final document = uploadedDocuments[index];
              return Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'description',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document.name,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Document ${index + 1}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _removeDocument(index),
                      icon: CustomIconWidget(
                        iconName: 'delete',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
