import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/catalog/data/repositories/local_product_repository.dart';
import 'features/catalog/domain/repositories/product_repository.dart';
import 'features/profile/presentation/controllers/profile_controller.dart';

/// Root: app-wide providers, theme and routes.
class VerdaineApp extends StatelessWidget {
  const VerdaineApp({
    this.repository = const LocalProductRepository(),
    super.key,
  });

  final ProductRepository repository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <InheritedProvider<Object>>[
        Provider<ProductRepository>.value(value: repository),
        ChangeNotifierProvider<ProfileController>(
          create: (_) => ProfileController(),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.brand,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.onboarding,
        onGenerateRoute: AppRouter.onGenerate,
      ),
    );
  }
}
