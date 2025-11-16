import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_export.dart';

/// Custom app bar variants for different screen types in healthcare B2B application
enum CustomAppBarVariant {
  /// Standard app bar with title and optional actions
  standard,

  /// App bar with search functionality
  search,

  /// App bar with back button and title
  back,

  /// App bar with profile and notifications
  profile,

  /// Minimal app bar with just logo/title
  minimal,
}

/// Custom app bar that provides consistent navigation and branding
/// across the healthcare B2B application with professional styling
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onNotificationPressed;
  final TextEditingController? searchController;
  final String? searchHint;
  final bool showNotificationBadge;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  const CustomAppBar({
    super.key,
    this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.onBackPressed,
    this.onSearchPressed,
    this.onProfilePressed,
    this.onNotificationPressed,
    this.searchController,
    this.searchHint = 'Search medicines, suppliers...',
    this.showNotificationBadge = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _handleBackNavigation(BuildContext context) {
    if (onBackPressed != null) {
      onBackPressed!();
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _handleProfileNavigation(BuildContext context) {
    if (onProfilePressed != null) {
      onProfilePressed!();
    } else {
      Navigator.pushNamed(context, '/profile-settings');
    }
  }

  Widget _buildLeading(BuildContext context) {
    switch (variant) {
      case CustomAppBarVariant.back:
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handleBackNavigation(context),
          tooltip: AppLocalizations.of(context).back,
        );
      case CustomAppBarVariant.profile:
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: AppLocalizations.of(context).menu,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.search:
        return Container(
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withAlpha(26),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withAlpha(77),
            ),
          ),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: searchHint,
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurfaceVariant.withAlpha(179),
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 14,
            ),
          ),
        );
      case CustomAppBarVariant.minimal:
        return Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.medical_services,
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title ?? AppLocalizations.of(context).medSupply,
              style: theme.appBarTheme.titleTextStyle?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      default:
        return Text(
          title ?? AppLocalizations.of(context).medSupply,
          style: theme.appBarTheme.titleTextStyle,
        );
    }
  }

  List<Widget> _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> actionWidgets = [];

    switch (variant) {
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.back:
        if (actions != null) {
          actionWidgets.addAll(actions!);
        } else {
          actionWidgets.addAll([
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: onSearchPressed,
              tooltip: AppLocalizations.of(context).searchMedicines,
            ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: onNotificationPressed,
                  tooltip: AppLocalizations.of(context).notifications,
                ),
                if (showNotificationBadge)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ]);
        }
        break;
      case CustomAppBarVariant.search:
        actionWidgets.addAll([
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter action
            },
            tooltip: AppLocalizations.of(context).filter,
          ),
        ]);
        break;
      case CustomAppBarVariant.profile:
        actionWidgets.addAll([
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: onNotificationPressed,
                tooltip: AppLocalizations.of(context).notifications,
              ),
              if (showNotificationBadge)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => _handleProfileNavigation(context),
            tooltip: AppLocalizations.of(context).profile,
          ),
        ]);
        break;
      case CustomAppBarVariant.minimal:
        if (actions != null) {
          actionWidgets.addAll(actions!);
        }
        break;
    }

    return actionWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: _buildTitle(context),
      leading: _buildLeading(context),
      actions: _buildActions(context),
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation ?? theme.appBarTheme.elevation,
      shadowColor: theme.appBarTheme.shadowColor,
      surfaceTintColor: theme.appBarTheme.surfaceTintColor,
      centerTitle: variant == CustomAppBarVariant.minimal ? false : true,
      titleSpacing: variant == CustomAppBarVariant.minimal ? 0 : null,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: theme.brightness,
      ),
    );
  }
}
