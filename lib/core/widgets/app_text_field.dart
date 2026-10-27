import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Shared text input with the brand's soft pill styling.
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.controller,
    required this.hint,
    this.onSubmitted,
    this.onChanged,
    this.autofocus = false,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder border = OutlineInputBorder(
      borderRadius: AppRadii.pill,
      borderSide: BorderSide(color: AppColors.hairline),
    );
    return TextField(
      controller: controller,
      autofocus: autofocus,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.done,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      style: AppTypography.title.copyWith(fontSize: 24),
      cursorColor: AppColors.clay,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.title.copyWith(
          fontSize: 24,
          color: AppColors.hairline,
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.clay, width: 1.4),
        ),
      ),
    );
  }
}
