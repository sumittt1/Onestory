import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../models/models.dart';

class StatusBadge extends StatelessWidget {
  final PowerStatus? powerStatus;
  final OnlineStatus? onlineStatus;
  final UserRole? role;
  final bool? isActive;
  final bool? isEnabled;
  
  const StatusBadge({
    super.key,
    this.powerStatus,
    this.onlineStatus,
    this.role,
    this.isActive,
    this.isEnabled,
  });
  
  @override
  Widget build(BuildContext context) {
    if (powerStatus != null) {
      return _buildPowerBadge();
    } else if (onlineStatus != null) {
      return _buildOnlineBadge();
    } else if (role != null) {
      return _buildRoleBadge();
    } else if (isActive != null) {
      return _buildActiveBadge();
    } else if (isEnabled != null) {
      return _buildEnabledBadge();
    }
    
    return const SizedBox.shrink();
  }
  
  Widget _buildPowerBadge() {
    final isOn = powerStatus == PowerStatus.on;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSmall,
        vertical: AppTheme.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: isOn 
            ? AppTheme.successColor.withOpacity(0.1)
            : AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
        border: Border.all(
          color: isOn ? AppTheme.successColor : AppTheme.errorColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOn ? AppTheme.successColor : AppTheme.errorColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppTheme.spacingXSmall),
          Text(
            isOn ? 'ON' : 'OFF',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOnlineBadge() {
    final isOnline = onlineStatus == OnlineStatus.online;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSmall,
        vertical: AppTheme.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: isOnline 
            ? AppTheme.successColor.withOpacity(0.1)
            : AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
        border: Border.all(
          color: isOnline ? AppTheme.successColor : AppTheme.errorColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline ? Icons.wifi : Icons.wifi_off,
            size: 12,
            color: isOnline ? AppTheme.successColor : AppTheme.errorColor,
          ),
          const SizedBox(width: AppTheme.spacingXSmall),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRoleBadge() {
    String label;
    Color color;
    
    switch (role!) {
      case UserRole.admin:
        label = 'Admin';
        color = AppTheme.errorColor;
        break;
      case UserRole.faculty:
        label = 'Faculty';
        color = AppTheme.primaryColor;
        break;
      case UserRole.staff:
        label = 'Staff';
        color = AppTheme.infoColor;
        break;
      case UserRole.student:
        label = 'Student';
        color = AppTheme.successColor;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSmall,
        vertical: AppTheme.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
  
  Widget _buildActiveBadge() {
    final active = isActive ?? true;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSmall,
        vertical: AppTheme.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: active 
            ? AppTheme.successColor.withOpacity(0.1)
            : AppTheme.textHint.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
        border: Border.all(
          color: active ? AppTheme.successColor : AppTheme.textHint,
          width: 1,
        ),
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: active ? AppTheme.successColor : AppTheme.textHint,
        ),
      ),
    );
  }
  
  Widget _buildEnabledBadge() {
    final enabled = isEnabled ?? true;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSmall,
        vertical: AppTheme.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: enabled 
            ? AppTheme.successColor.withOpacity(0.1)
            : AppTheme.textHint.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
        border: Border.all(
          color: enabled ? AppTheme.successColor : AppTheme.textHint,
          width: 1,
        ),
      ),
      child: Text(
        enabled ? 'Enabled' : 'Disabled',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: enabled ? AppTheme.successColor : AppTheme.textHint,
        ),
      ),
    );
  }
}
