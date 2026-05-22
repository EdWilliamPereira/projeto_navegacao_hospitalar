import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/map/data/datasources/map_local_datasource.dart';
import 'features/map/presentation/providers/map_provider.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise the database before the widget tree mounts.
  // The instance is then injected via ProviderScope.overrides so that
  // mapLocalDataSourceProvider always returns the pre-warmed instance.
  final dataSource = MapLocalDataSourceImpl();
  await dataSource.initDatabase();

  runApp(
    ProviderScope(
      overrides: [
        mapLocalDataSourceProvider.overrideWithValue(dataSource),
      ],
      child: const HospitalNavApp(),
    ),
  );
}

class HospitalNavApp extends ConsumerWidget {
  const HospitalNavApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final highContrastAsync = ref.watch(highContrastProvider);

    return MaterialApp.router(
      title: 'Hospital Navigation',
      debugShowCheckedModeBanner: false,

      // FR-10: switch between themes based on user preference.
      theme: AppTheme.light,
      darkTheme: AppTheme.highContrast,
      themeMode: highContrastAsync.value == true
          ? ThemeMode.dark
          : ThemeMode.light,

      routerConfig: router,

      // NFR-08: default locale is Brazilian Portuguese.
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
