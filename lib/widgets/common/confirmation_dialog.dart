import 'package:flutter/material.dart';
import '../../app/theme.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String? message;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  
  const ConfirmationDialog({
    super.key,
    required this.title,
    this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDestructive = false,
  });
  
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          if (isDestructive)
            Icon(
              Icons.warning,
              color: AppTheme.errorColor,
            )
          else
            const Icon(Icons.info_outline),
          const SizedBox(width: AppTheme.spacingMedium),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
      content: message != null
          ? Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          : null,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDestructive ? AppTheme.errorColor : null,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
