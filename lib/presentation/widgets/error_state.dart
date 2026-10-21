import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import 'empty_state.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.error_outline,
      title: AppStrings.somethingWentWrong,
      message: message,
      actionLabel: AppStrings.retry,
      onAction: onRetry,
    );
  }
}