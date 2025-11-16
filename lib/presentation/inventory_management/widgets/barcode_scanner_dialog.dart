import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BarcodeScannerDialog extends StatefulWidget {
  final Function(String) onBarcodeScanned;

  const BarcodeScannerDialog({
    Key? key,
    required this.onBarcodeScanned,
  }) : super(key: key);

  @override
  State<BarcodeScannerDialog> createState() => _BarcodeScannerDialogState();
}

class _BarcodeScannerDialogState extends State<BarcodeScannerDialog> {
  MobileScannerController? _controller;
  bool _isInitialized = false;
  bool _hasPermission = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeScanner();
  }

  Future<void> _initializeScanner() async {
    try {
      if (kIsWeb) {
        setState(() {
          _hasPermission = true;
          _isInitialized = true;
        });
        _controller = MobileScannerController();
      } else {
        final permission = await Permission.camera.request();
        if (permission.isGranted) {
          setState(() => _hasPermission = true);
          _controller = MobileScannerController();
          setState(() => _isInitialized = true);
        } else {
          setState(() {
            _errorMessage = 'Camera permission is required to scan barcodes';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize camera: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 85.w,
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Scan Barcode',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildScannerContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerContent() {
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'error',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 12.w,
              ),
              SizedBox(height: 2.h),
              Text(
                _errorMessage,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_hasPermission || !_isInitialized || _controller == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(height: 2.h),
            Text(
              'Initializing camera...',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: (BarcodeCapture capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                  widget.onBarcodeScanned(barcodes.first.rawValue!);
                  Navigator.pop(context);
                }
              },
            ),
            Center(
              child: Container(
                width: 60.w,
                height: 30.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Positioned(
              bottom: 4.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Position barcode within the frame',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
