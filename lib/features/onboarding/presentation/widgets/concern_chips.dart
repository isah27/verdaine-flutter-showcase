import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../profile/domain/entities/skin_concern.dart';

class ConcernChips extends StatelessWidget {
  const ConcernChips({
    required this.selected,
    required this.onToggle,
    required this.onConfirm,
    super.key,
  });

  final Set<SkinConcern> selected;
  final ValueChanged<SkinConcern> onToggle;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: <Widget>[
            for (final SkinConcern c in SkinConcern.values)
              AppButton(
                key: ValueKey<String>('concern-${c.name}'),
                label: c.label,
                variant: AppButtonVariant.chip,
                expanded: false,
                swatch: c.color,
                selected: selected.contains(c),
                onPressed: () => onToggle(c),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          key: const ValueKey<String>('concerns-next'),
          label: selected.isEmpty ? 'Pick at least one' : 'Pour it in',
          onPressed: selected.isEmpty ? null : onConfirm,
        ),
      ],
    );
  }
}
