import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/widgets/app_text.dart';
import 'dock_item.dart';

/// Floating two-tab dock with a dew drop that slides under the active tab.
class DewDock extends StatelessWidget {
  const DewDock({
    required this.index,
    required this.onSelect,
    required this.night,
    super.key,
  });

  final int index;
  final ValueChanged<int> onSelect;
  final bool night;

  static const List<DockItem> items = <DockItem>[
    DockItem('Ritual', Icons.wb_twilight_rounded),
    DockItem('Texture Lab', Icons.water_drop_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final Color bg = night ? AppColors.plumRaised : AppColors.ink;
    final Color on = night ? AppColors.plum : AppColors.ink;
    final Color off = AppColors.moonMilk.withValues(alpha: .7);
    return Container(
      height: AppSizes.dockHeight,
      width: 300,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.pill,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.ink.withValues(alpha: .25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          AnimatedAlign(
            duration: AppDurations.medium,
            curve: Curves.easeOutBack,
            alignment: index == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: .5,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: night ? AppColors.honey : AppColors.milk,
                  borderRadius: AppRadii.pill,
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              for (int i = 0; i < items.length; i++)
                Expanded(
                  child: GestureDetector(
                    key: ValueKey<String>('dock-$i'),
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onSelect(i),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          items[i].icon,
                          size: 18,
                          color: i == index ? on : off,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: AppText(
                            items[i].label,
                            variant: AppTextVariant.label,
                            maxLines: 1,
                            color: i == index ? on : off,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
