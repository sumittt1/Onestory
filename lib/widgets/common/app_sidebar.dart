import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/responsive/breakpoints.dart';

class AppSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  
  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });
  
  static const List<SidebarItem> items = [
    SidebarItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
    ),
    SidebarItem(
      icon: Icons.meeting_room_outlined,
      selectedIcon: Icons.meeting_room,
      label: 'Classrooms',
    ),
    SidebarItem(
      icon: Icons.business_outlined,
      selectedIcon: Icons.business,
      label: 'Buildings',
    ),
    SidebarItem(
      icon: Icons.bolt_outlined,
      selectedIcon: Icons.bolt,
      label: 'Energy Usage',
    ),
    SidebarItem(
      icon: Icons.schedule_outlined,
      selectedIcon: Icons.schedule,
      label: 'Schedules',
    ),
    SidebarItem(
      icon: Icons.people_outlined,
      selectedIcon: Icons.people,
      label: 'Users',
    ),
    SidebarItem(
      icon: Icons.history_outlined,
      selectedIcon: Icons.history,
      label: 'Activity Logs',
    ),
    SidebarItem(
      icon: Icons.notifications_outlined,
      selectedIcon: Icons.notifications,
      label: 'Notifications',
    ),
    SidebarItem(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
    ),
  ];
  
  @override
  Widget build(BuildContext context) {
    if (Breakpoints.isMobile(context)) {
      return const SizedBox.shrink();
    }
    
    return Container(
      width: AppTheme.sidebarWidth,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          right: BorderSide(color: AppTheme.borderColor),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSmall),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedIndex == index;
                
                return _SidebarTile(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => onItemSelected(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                ),
                child: const Icon(
                  Icons.power,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OneStory',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Text(
                      'Energy Management',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SidebarItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  
  const SidebarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class _SidebarTile extends StatelessWidget {
  final SidebarItem item;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _SidebarTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingSmall,
          vertical: AppTheme.spacingXSmall,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMedium,
          vertical: AppTheme.spacingMedium,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? item.selectedIcon : item.icon,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(width: AppTheme.spacingMedium),
            Expanded(
              child: Text(
                item.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
