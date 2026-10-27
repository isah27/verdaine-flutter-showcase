import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_spacing.dart';
import 'skin_swatch.dart';
import '../../../profile/domain/entities/skin_type.dart';

/// Texture swatches instead of a dropdown: each tile is a smear of colour.
class SkinTypePicker extends StatelessWidget {
  const SkinTypePicker({
    required this.selected,
    required this.onPick,
    super.key,
  });

  final SkinType? selected;
  final ValueChanged<SkinType> onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (final SkinType t in SkinType.values)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: SkinSwatch(
              type: t,
              selected: t == selected,
              onTap: () => onPick(t),
            ),
          ),
      ],
    );
  }
}
