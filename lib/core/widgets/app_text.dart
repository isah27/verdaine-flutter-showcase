import 'package:flutter/widgets.dart';

import '../theme/app_typography.dart';

enum AppTextVariant {
  display,
  title,
  italic,
  body,
  label,
  caption,
  overline,
  wordmark,
}

/// The only way screens render text, so the type scale stays in one place.
class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    this.variant = AppTextVariant.body,
    this.color,
    this.align,
    this.maxLines,
    this.size,
    super.key,
  });

  final String text;
  final AppTextVariant variant;
  final Color? color;
  final TextAlign? align;
  final int? maxLines;
  final double? size;

  TextStyle get _style => switch (variant) {
    AppTextVariant.display => AppTypography.display,
    AppTextVariant.title => AppTypography.title,
    AppTextVariant.italic => AppTypography.italic,
    AppTextVariant.body => AppTypography.body,
    AppTextVariant.label => AppTypography.label,
    AppTextVariant.caption => AppTypography.caption,
    AppTextVariant.overline => AppTypography.overline,
    AppTextVariant.wordmark => AppTypography.wordmark,
  };

  @override
  Widget build(BuildContext context) {
    final TextStyle style = (color == null && size == null)
        ? _style
        : _style.copyWith(color: color, fontSize: size);
    return Text(
      text,
      style: style,
      textAlign: align,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
    );
  }
}
