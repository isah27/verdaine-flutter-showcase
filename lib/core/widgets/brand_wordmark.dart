import 'package:flutter/widgets.dart';

import '../constants/app_strings.dart';
import 'app_text.dart';

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({this.color, this.size, super.key});

  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return AppText(
      AppStrings.brand,
      variant: AppTextVariant.wordmark,
      color: color,
      size: size,
    );
  }
}
