import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class NameStep extends StatelessWidget {
  const NameStep({required this.controller, required this.onSubmit, super.key});

  final TextEditingController controller;
  final ValueChanged<String> onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppTextField(
          key: const ValueKey<String>('name-field'),
          controller: controller,
          hint: 'First name',
          onSubmitted: onSubmit,
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          key: const ValueKey<String>('name-next'),
          label: 'Pour the first layer',
          onPressed: () => onSubmit(controller.text),
        ),
      ],
    );
  }
}
