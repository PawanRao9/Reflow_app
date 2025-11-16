import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class LanguageSelectorWidget extends StatefulWidget {
  final String? selectedLanguage;
  final ValueChanged<String>? onLanguageChanged;

  const LanguageSelectorWidget({
    Key? key,
    this.selectedLanguage,
    this.onLanguageChanged,
  }) : super(key: key);

  @override
  State<LanguageSelectorWidget> createState() => _LanguageSelectorWidgetState();
}

class _LanguageSelectorWidgetState extends State<LanguageSelectorWidget> {
  late String _selectedLanguage;

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'hi', 'name': 'हिंदी', 'flag': '🇮🇳'},
    {'code': 'mr', 'name': 'मराठी', 'flag': '🇮🇳'},
    {'code': 'gu', 'name': 'ગુજરાતી', 'flag': '🇮🇳'},
    {'code': 'ta', 'name': 'தமிழ்', 'flag': '🇮🇳'},
    {'code': 'te', 'name': 'తెలుగు', 'flag': '🇮🇳'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage ?? 'en';
  }

  String _getLocalizedLanguageName(String code) {
    final localizations = AppLocalizations.of(context);
    switch (code) {
      case 'en':
        return localizations.english;
      case 'hi':
        return localizations.hindi;
      case 'mr':
        return localizations.marathi;
      case 'gu':
        return localizations.gujarati;
      case 'ta':
        return localizations.tamil;
      case 'te':
        return localizations.telugu;
      default:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'language',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Flexible(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                isExpanded: true,
                items: _languages.map((language) {
                  return DropdownMenuItem<String>(
                    value: language['code'],
                    child: Row(
                      children: [
                        Text(
                          language['flag']!,
                          style: const TextStyle(fontSize: 18),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          _getLocalizedLanguageName(language['code']!),
                          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                    widget.onLanguageChanged?.call(value);
                  }
                },
                icon: CustomIconWidget(
                  iconName: 'arrow_drop_down',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
