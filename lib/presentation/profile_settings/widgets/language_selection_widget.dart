import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import './settings_item_widget.dart';

class LanguageSelectionWidget extends StatefulWidget {
  final String currentLanguage;
  final ValueChanged<String>? onLanguageChanged;

  const LanguageSelectionWidget({
    super.key,
    required this.currentLanguage,
    this.onLanguageChanged,
  });

  @override
  State<LanguageSelectionWidget> createState() =>
      _LanguageSelectionWidgetState();
}

class _LanguageSelectionWidgetState extends State<LanguageSelectionWidget> {
  final List<Map<String, dynamic>> languages = [
    {
      "code": "en",
      "name": "English",
      "nativeName": "English",
      "flag": "🇺🇸",
    },
    {
      "code": "hi",
      "name": "Hindi",
      "nativeName": "हिन्दी",
      "flag": "🇮🇳",
    },
    {
      "code": "ta",
      "name": "Tamil",
      "nativeName": "தமிழ்",
      "flag": "🇮🇳",
    },
    {
      "code": "te",
      "name": "Telugu",
      "nativeName": "తెలుగు",
      "flag": "🇮🇳",
    },
    {
      "code": "bn",
      "name": "Bengali",
      "nativeName": "বাংলা",
      "flag": "🇮🇳",
    },
    {
      "code": "mr",
      "name": "Marathi",
      "nativeName": "मराठी",
      "flag": "🇮🇳",
    },
    {
      "code": "gu",
      "name": "Gujarati",
      "nativeName": "ગુજરાતી",
      "flag": "🇮🇳",
    },
    {
      "code": "kn",
      "name": "Kannada",
      "nativeName": "ಕನ್ನಡ",
      "flag": "🇮🇳",
    },
  ];

  void _showLanguageSelection(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(6.w)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    "Select Language",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final language = languages[index];
                  final isSelected = widget.currentLanguage == language["code"];

                  return InkWell(
                    onTap: () {
                      widget.onLanguageChanged
                          ?.call(language["code"] as String);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                      child: Row(
                        children: [
                          Text(
                            language["flag"] as String,
                            style: TextStyle(fontSize: 6.w),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  language["name"] as String,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : null,
                                  ),
                                ),
                                if (language["nativeName"] !=
                                    language["name"]) ...[
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    language["nativeName"] as String,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (isSelected)
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: theme.colorScheme.primary,
                              size: 6.w,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    final language = languages.firstWhere(
      (lang) => lang["code"] == code,
      orElse: () => languages.first,
    );
    return language["name"] as String;
  }

  @override
  Widget build(BuildContext context) {
    return SettingsItemWidget(
      title: "Language",
      subtitle: "App display language",
      iconName: 'language',
      type: SettingsItemType.selection,
      selectedValue: _getLanguageName(widget.currentLanguage),
      onTap: () => _showLanguageSelection(context),
    );
  }
}
