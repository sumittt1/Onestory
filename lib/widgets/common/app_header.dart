import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/responsive/breakpoints.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final VoidCallback? onMenuTap;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  
  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.onMenuTap,
    this.showBackButton = false,
    this.onBackPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppTheme.headerHeight,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor),
        ),
      ),
      child: Row(
        children: [
          if (Breakpoints.isMobile(context))
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onMenuTap,
              tooltip: 'Menu',
            )
          else if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed,
              tooltip: 'Back',
            )
          else
            const SizedBox(width: AppTheme.spacingMedium),
          const SizedBox(width: AppTheme.spacingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (actions != null) ...[
            const SizedBox(width: AppTheme.spacingSmall),
            ...actions!,
          ],
          const SizedBox(width: AppTheme.spacingMedium),
        ],
      ),
    );
  }
}
