import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/active_sessions_widget.dart';
import './widgets/language_selection_widget.dart';
import './widgets/notification_preferences_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/verification_status_widget.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedLanguage = "en";
  String _selectedCurrency = "INR";
  final String _selectedTheme = 'system';
  bool _biometricEnabled = true;
  bool _twoFactorEnabled = false;

  Map<String, bool> _notificationPreferences = {
    "orderUpdates": true,
    "lowStock": true,
    "newProducts": false,
    "priceChanges": true,
    "promotions": false,
    "systemUpdates": true,
    "marketing": false,
  };

  // Mock user data
  final Map<String, dynamic> _userData = {
    "businessName": "MedCare Pharmacy",
    "email": "admin@medcarepharmacy.com",
    "accountType": "Pharmacy",
    "avatar":
        "https://images.unsplash.com/photo-1580281658223-9b93f18ae9ae",
    "avatarSemanticLabel":
        "Professional woman in white coat standing in modern pharmacy with medicine shelves in background",
    "phone": "+91 98765 43210",
    "address":
        "123 Health Street, Medical District, Mumbai, Maharashtra 400001",
    "gstNumber": "27ABCDE1234F1Z5",
    "licenseNumber": "MH-MUM-2023-001234",
  };

  final Map<String, dynamic> _verificationData = {
    "isVerified": true,
    "status": "verified",
    "documents": [
      {
        "name": "GST Certificate",
        "status": "approved",
      },
      {
        "name": "Drug License",
        "status": "approved",
      },
      {
        "name": "Business Registration",
        "status": "approved",
      },
    ],
  };

  final Map<String, dynamic> _subscriptionData = {
    "plan": "Professional",
    "status": "active",
    "expiryDate": "2024-12-09",
    "features": [
      "Unlimited Orders",
      "Advanced Analytics",
      "Priority Support",
      "Multi-location Management",
    ],
  };

  final List<Map<String, dynamic>> _activeSessions = [
    {
      "sessionId": "session_001",
      "deviceName": "iPhone 14 Pro",
      "deviceType": "mobile",
      "location": "Mumbai, Maharashtra",
      "lastActive": "Now",
      "isCurrent": true,
    },
    {
      "sessionId": "session_002",
      "deviceName": "MacBook Pro",
      "deviceType": "desktop",
      "location": "Mumbai, Maharashtra",
      "lastActive": "2 hours ago",
      "isCurrent": false,
    },
    {
      "sessionId": "session_003",
      "deviceName": "Chrome Browser",
      "deviceType": "web",
      "location": "Delhi, India",
      "lastActive": "1 day ago",
      "isCurrent": false,
    },
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      "id": "pm_001",
      "type": "UPI",
      "details": "medcare@paytm",
      "isDefault": true,
    },
    {
      "id": "pm_002",
      "type": "Bank Account",
      "details": "**1234 - HDFC Bank",
      "isDefault": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleEditProfile() {
    // Handle profile editing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile editing functionality")),
    );
  }

  void _handleLanguageChange(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  void _handleNotificationPreferencesChange(Map<String, bool> preferences) {
    setState(() {
      _notificationPreferences = preferences;
    });
  }

  void _handleTerminateSession(String sessionId) {
    setState(() {
      _activeSessions
          .removeWhere((session) => session["sessionId"] == sessionId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Session terminated successfully")),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text(
            "Are you sure you want to logout? This will end your current session."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/splash-screen', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Profile Settings",
        variant: CustomAppBarVariant.back,
      ),
      body: Column(
        children: [
          Container(
            color: theme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: "Dashboard"),
                Tab(text: "Profile"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardTab(),
                _buildProfileTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 4),
    );
  }

  Widget _buildDashboardTab() {
    return const Center(
      child: Text("Dashboard content will be implemented"),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileHeaderWidget(
            userData: _userData,
            onEditProfile: _handleEditProfile,
          ),
          SizedBox(height: 2.h),

          // Account Section
          SettingsSectionWidget(
            title: "Account",
            children: [
              SettingsItemWidget(
                title: "Edit Profile",
                subtitle: "Update your personal information",
                iconName: 'person',
                onTap: _handleEditProfile,
              ),
              SettingsItemWidget(
                title: "Business Information",
                subtitle: "Manage business details and documents",
                iconName: 'business',
                onTap: () {
                  // Handle business info
                },
              ),
              SettingsItemWidget(
                title: "Subscription Details",
                subtitle:
                    "${_subscriptionData["plan"]} Plan - Active until ${_subscriptionData["expiryDate"]}",
                iconName: 'card_membership',
                onTap: () {
                  // Handle subscription
                },
              ),
            ],
          ),

          // Verification Status
          VerificationStatusWidget(
            verificationData: _verificationData,
          ),

          // Preferences Section
          SettingsSectionWidget(
            title: "Preferences",
            children: [
              LanguageSelectionWidget(
                currentLanguage: _selectedLanguage,
                onLanguageChanged: _handleLanguageChange,
              ),
              SettingsItemWidget(
                title: "Currency Settings",
                subtitle: "Display currency and regional formats",
                iconName: 'currency_rupee',
                type: SettingsItemType.selection,
                selectedValue: _selectedCurrency,
                onTap: () {
                  // Handle currency selection
                },
              ),
              NotificationPreferencesWidget(
                preferences: _notificationPreferences,
                onPreferencesChanged: _handleNotificationPreferencesChange,
              ),
              SettingsItemWidget(
                title: "Theme Selection",
                subtitle: "Choose your preferred app theme",
                iconName: 'palette',
                type: SettingsItemType.selection,
                selectedValue: _selectedTheme == "system"
                    ? "System Default"
                    : _selectedTheme == "light"
                        ? "Light"
                        : "Dark",
                onTap: () {
                  // Handle theme selection
                },
              ),
            ],
          ),

          // Business Section
          SettingsSectionWidget(
            title: "Business",
            children: [
              SettingsItemWidget(
                title: "Tax Information",
                subtitle: "GST: ${_userData["gstNumber"]}",
                iconName: 'receipt',
                onTap: () {
                  // Handle tax info
                },
              ),
              SettingsItemWidget(
                title: "Payment Methods",
                subtitle: "${_paymentMethods.length} methods configured",
                iconName: 'payment',
                onTap: () {
                  // Handle payment methods
                },
              ),
              SettingsItemWidget(
                title: "Delivery Addresses",
                subtitle: "Manage shipping and billing addresses",
                iconName: 'location_on',
                onTap: () {
                  // Handle addresses
                },
              ),
              SettingsItemWidget(
                title: "Integration Settings",
                subtitle: "Connect with existing POS systems",
                iconName: 'integration_instructions',
                onTap: () {
                  // Handle integrations
                },
              ),
            ],
          ),

          // Security Section
          SettingsSectionWidget(
            title: "Security",
            children: [
              SettingsItemWidget(
                title: "Change Password",
                subtitle: "Update your account password",
                iconName: 'lock',
                onTap: () {
                  // Handle password change
                },
              ),
              SettingsItemWidget(
                title: "Biometric Settings",
                subtitle: "Use fingerprint or face ID for login",
                iconName: 'fingerprint',
                type: SettingsItemType.toggle,
                switchValue: _biometricEnabled,
                onSwitchChanged: (value) {
                  setState(() {
                    _biometricEnabled = value;
                  });
                },
              ),
              SettingsItemWidget(
                title: "Two-Factor Authentication",
                subtitle: "Add an extra layer of security",
                iconName: 'security',
                type: SettingsItemType.toggle,
                switchValue: _twoFactorEnabled,
                onSwitchChanged: (value) {
                  setState(() {
                    _twoFactorEnabled = value;
                  });
                },
              ),
            ],
          ),

          // Active Sessions
          ActiveSessionsWidget(
            sessions: _activeSessions,
            onTerminateSession: _handleTerminateSession,
          ),

          // Support Section
          SettingsSectionWidget(
            title: "Support",
            children: [
              SettingsItemWidget(
                title: "Help Center",
                subtitle: "FAQs and user guides",
                iconName: 'help',
                onTap: () {
                  // Handle help center
                },
              ),
              SettingsItemWidget(
                title: "Contact Support",
                subtitle: "Get help from our support team",
                iconName: 'support_agent',
                onTap: () {
                  // Handle contact support
                },
              ),
              SettingsItemWidget(
                title: "Feedback Form",
                subtitle: "Share your thoughts and suggestions",
                iconName: 'feedback',
                onTap: () {
                  // Handle feedback
                },
              ),
              SettingsItemWidget(
                title: "App Version",
                subtitle: "Version 1.0.0 (Build 100)",
                iconName: 'info',
                type: SettingsItemType.action,
                onTap: () {
                  // Handle version info
                },
              ),
            ],
          ),

          // Logout Section
          Container(
            margin: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'logout',
                      color: Theme.of(context).colorScheme.onError,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "Logout",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onError,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}