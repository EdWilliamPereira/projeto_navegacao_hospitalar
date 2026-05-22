import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:hospital_nav/features/map/domain/entities/poi.dart';
import 'package:hospital_nav/features/map/presentation/providers/map_provider.dart';
import 'package:hospital_nav/features/search/presentation/pages/search_page.dart';

import '../../helpers/fake_map_repository.dart';

void main() {
  group('SearchPage', () {
    const fakePois = [
      Poi(
        id: '1',
        name: 'Pharmacy',
        category: 'pharmacy',
        nodeId: 'room_102',
        description: '',
        tags: [],
      ),
    ];

    const fakeRepo = FakeMapRepository(pois: fakePois);

    // Helper function to create a fresh GoRouter for each test
    GoRouter createTestRouter() {
      return GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, __) => const SearchPage()),
          GoRoute(path: '/map', builder: (_, __) => const Scaffold()),
        ],
      );
    }

    testWidgets(
      'shows POI list when query is empty',
      (tester) async {
        final testRouter = createTestRouter();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              mapRepositoryProvider.overrideWithValue(fakeRepo),
            ],
            child: MaterialApp.router(routerConfig: testRouter),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Pharmacy'), findsOneWidget);
        expect(find.text('pharmacy'), findsOneWidget);
      },
    );

    testWidgets(
      'shows "No results found" when search returns empty',
      (tester) async {
        final testRouter = createTestRouter();
        const emptyRepo = FakeMapRepository(pois: []);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              mapRepositoryProvider.overrideWithValue(emptyRepo),
            ],
            child: MaterialApp.router(routerConfig: testRouter),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('No results found.'), findsOneWidget);
      },
    );
  });
}