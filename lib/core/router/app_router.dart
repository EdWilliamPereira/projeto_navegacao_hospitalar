import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/map/presentation/pages/map_page.dart';
import '../../features/navigation/presentation/pages/navigation_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

part 'app_router.g.dart';

/// Global router — exposed as a Riverpod provider so it can be overridden
/// in widget tests without touching GoRouter's static global state.
///
/// go_router ^17: Router is kept alive automatically; no keepAlive annotation needed.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'map',
        builder: (context, state) => const MapPage(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: '/navigation/:destinationId',
        name: 'navigation',
        builder: (context, state) {
          final destinationId = state.pathParameters['destinationId']!;
          return NavigationPage(destinationId: destinationId);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
