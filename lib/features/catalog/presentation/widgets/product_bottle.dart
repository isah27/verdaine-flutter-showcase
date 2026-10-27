import 'package:flutter/widgets.dart';

import '../../domain/entities/product.dart';
import 'bottle_painter.dart';

/// Static painted bottle for a product, cached in its own layer.
class ProductBottle extends StatelessWidget {
  const ProductBottle({required this.product, this.size = 56, super.key});

  final Product product;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(size * .7, size),
        painter: BottlePainter(
          shape: product.bottle,
          layers: <Color>[product.liquid],
        ),
      ),
    );
  }
}
