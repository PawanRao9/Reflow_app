import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LanguageSelectorWidget extends StatefulWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const LanguageSelectorWidget({
    Key? key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  State<LanguageSelectorWidget> createState() => _LanguageSelectorWidgetState();
}

class _LanguageSelectorWidgetState extends State<LanguageSelectorWidget> {
  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिंदी'},
    {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்'},
    {'code': 'te', 'name': 'Telugu', 'native': 'తెలుగు'},
    {'code': 'bn', 'name': 'Bengali', 'native': 'বাংলা'},
    {'code': 'mr', 'name': 'Marathi', 'native': 'मराठी'},
  ];

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Select Language',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 2.h),
              ...languages
                  .map((language) => ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        leading: Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: widget.selectedLanguage == language['code']
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: widget.selectedLanguage == language['code']
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 16,
                                )
                              : null,
                        ),
                        title: Text(
                          language['native']!,
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            fontWeight:
                                widget.selectedLanguage == language['code']
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          language['name']!,
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        onTap: () {
                          widget.onLanguageChanged(language['code']!);
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  String _getLanguageName(String code) {
    final language = languages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => languages.first,
    );
    return language['native']!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showLanguageSelector,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'language',
              color: AppTheme.lightTheme.primaryColor,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              _getLanguageName(widget.selectedLanguage),
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.primaryColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
