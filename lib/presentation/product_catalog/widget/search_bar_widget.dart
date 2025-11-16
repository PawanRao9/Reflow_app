import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;
  final VoidCallback onFilterTap;
  final VoidCallback? onVoiceSearch;

  const SearchBarWidget({
    Key? key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onFilterTap,
    this.onVoiceSearch,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _searchController;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: widget.onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),
                  // Voice Search Button
                  GestureDetector(
                    onTap: _isListening ? null : _startVoiceSearch,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: CustomIconWidget(
                        iconName: _isListening ? 'mic' : 'mic_none',
                        color: _isListening
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                  // Barcode Scanner Button
                  GestureDetector(
                    onTap: _openBarcodeScanner,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: CustomIconWidget(
                        iconName: 'qr_code_scanner',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Filter Button
          GestureDetector(
            onTap: widget.onFilterTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: 'tune',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startVoiceSearch() {
    setState(() {
      _isListening = true;
    });

    // Simulate voice search functionality
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isListening = false;
        });
        // Mock voice search result
        const mockResult = "menstrual cup";
        _searchController.text = mockResult;
        widget.onSearchChanged(mockResult);
      }
    });

    widget.onVoiceSearch?.call();
  }

  Future<void> _openBarcodeScanner() async {
    // Request camera permission
    final permission = await Permission.camera.request();
    if (!permission.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required for barcode scanning'),
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    // Open barcode scanner
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _BarcodeScannerScreen(
          onBarcodeDetected: (String barcode) {
            _searchController.text = barcode;
            widget.onSearchChanged(barcode);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class _BarcodeScannerScreen extends StatefulWidget {
  final Function(String) onBarcodeDetected;

  const _BarcodeScannerScreen({
    Key? key,
    required this.onBarcodeDetected,
  }) : super(key: key);

  @override
  State<_BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<_BarcodeScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isDetected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'close',
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Scan Barcode',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (!_isDetected && capture.barcodes.isNotEmpty) {
                _isDetected = true;
                final String code = capture.barcodes.first.rawValue ?? '';
                if (code.isNotEmpty) {
                  widget.onBarcodeDetected(code);
                }
              }
            },
          ),
          // Overlay with scanning area
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: 16,
                borderLength: 30,
                borderWidth: 4,
                cutOutSize: 60.w,
              ),
            ),
          ),
          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Text(
                'Position the barcode within the frame to scan',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

class QrScannerOverlayShape extends ShapeBorder {
  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    double? cutOutSize,
  }) : cutOutSize = cutOutSize ?? 250;

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top + borderRadius)
        ..quadraticBezierTo(
            rect.left, rect.top, rect.left + borderRadius, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.top);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
  final width = rect.width;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final mCutOutWidth = cutOutSize;
    final mCutOutHeight = cutOutSize;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + (width - mCutOutWidth) / 2 + borderOffset,
      rect.top + (height - mCutOutHeight) / 2 + borderOffset,
      mCutOutWidth - borderOffset * 2,
      mCutOutHeight - borderOffset * 2,
    );

    canvas
      ..saveLayer(rect, backgroundPaint)
      ..drawRect(rect, backgroundPaint)
      ..drawRRect(
          RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
          boxPaint)
      ..restore();

    // Draw corner borders
    final path = Path()
      ..moveTo(cutOutRect.left - borderOffset, cutOutRect.top + borderLength)
      ..lineTo(cutOutRect.left - borderOffset, cutOutRect.top + borderRadius)
      ..quadraticBezierTo(
          cutOutRect.left - borderOffset,
          cutOutRect.top - borderOffset,
          cutOutRect.left + borderRadius,
          cutOutRect.top - borderOffset)
      ..lineTo(cutOutRect.left + borderLength, cutOutRect.top - borderOffset);

    canvas.drawPath(path, borderPaint);

    // Top right corner
    final path2 = Path()
      ..moveTo(cutOutRect.right - borderLength, cutOutRect.top - borderOffset)
      ..lineTo(cutOutRect.right - borderRadius, cutOutRect.top - borderOffset)
      ..quadraticBezierTo(
          cutOutRect.right + borderOffset,
          cutOutRect.top - borderOffset,
          cutOutRect.right + borderOffset,
          cutOutRect.top + borderRadius)
      ..lineTo(cutOutRect.right + borderOffset, cutOutRect.top + borderLength);

    canvas.drawPath(path2, borderPaint);

    // Bottom right corner
    final path3 = Path()
      ..moveTo(
          cutOutRect.right + borderOffset, cutOutRect.bottom - borderLength)
      ..lineTo(
          cutOutRect.right + borderOffset, cutOutRect.bottom - borderRadius)
      ..quadraticBezierTo(
          cutOutRect.right + borderOffset,
          cutOutRect.bottom + borderOffset,
          cutOutRect.right - borderRadius,
          cutOutRect.bottom + borderOffset)
      ..lineTo(
          cutOutRect.right - borderLength, cutOutRect.bottom + borderOffset);

    canvas.drawPath(path3, borderPaint);

    // Bottom left corner
    final path4 = Path()
      ..moveTo(cutOutRect.left + borderLength, cutOutRect.bottom + borderOffset)
      ..lineTo(cutOutRect.left + borderRadius, cutOutRect.bottom + borderOffset)
      ..quadraticBezierTo(
          cutOutRect.left - borderOffset,
          cutOutRect.bottom + borderOffset,
          cutOutRect.left - borderOffset,
          cutOutRect.bottom - borderRadius)
      ..lineTo(
          cutOutRect.left - borderOffset, cutOutRect.bottom - borderLength);

    canvas.drawPath(path4, borderPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
