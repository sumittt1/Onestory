import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../models/models.dart';

class PowerControlCard extends StatelessWidget {
  final String title;
  final PowerStatus status;
  final VoidCallback? onToggle;
  final bool isLoading;
  final Widget? child;
  
  const PowerControlCard({
    super.key,
    required this.title,
    required this.status,
    this.onToggle,
    this.isLoading = false,
    this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    final isOn = status == PowerStatus.on;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  isOn ? Icons.power_settings_new : Icons.power_off,
                  color: isOn ? AppTheme.successColor : AppTheme.textHint,
                  size: 32,
                ),
                const SizedBox(width: AppTheme.spacingMedium),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            if (child != null) ...[
              child!,
              const SizedBox(height: AppTheme.spacingMedium),
            ],
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMedium,
                      vertical: AppTheme.spacingMedium,
                    ),
                    decoration: BoxDecoration(
                      color: isOn 
                          ? AppTheme.successColor.withOpacity(0.1)
                          : AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppTheme.borderRadiusMedium,
                      ),
                      border: Border.all(
                        color: isOn ? AppTheme.successColor : AppTheme.errorColor,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isOn ? Icons.check_circle : Icons.cancel,
                          color: isOn ? AppTheme.successColor : AppTheme.errorColor,
                        ),
                        const SizedBox(width: AppTheme.spacingSmall),
                        Text(
                          isOn ? 'ON' : 'OFF',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isOn ? AppTheme.successColor : AppTheme.errorColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (onToggle != null) ...[
                  const SizedBox(width: AppTheme.spacingMedium),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : onToggle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isOn ? AppTheme.errorColor : AppTheme.successColor,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(isOn ? 'Turn OFF' : 'Turn ON'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
