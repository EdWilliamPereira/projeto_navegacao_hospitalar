import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hospital_nav/core/error/failures.dart';
import 'package:hospital_nav/features/map/domain/entities/edge.dart';
import 'package:hospital_nav/features/map/domain/entities/node.dart';
import 'package:hospital_nav/features/map/domain/repositories/map_repository.dart';
import 'package:hospital_nav/features/map/domain/usecases/calculate_route.dart';

class MockMapRepository extends Mock implements MapRepository {}

void main() {
  late MockMapRepository mockRepo;
  late CalculateRoute useCase;

  // A simple three-node graph: a ─── b ─── c
  //                                   └─────── c (stair shortcut)
  const nodes = [
    Node(id: 'a', name: 'A', floor: 0, x: 0, y: 0, type: NodeType.juncao),
    Node(id: 'b', name: 'B', floor: 0, x: 1, y: 0, type: NodeType.elevador),
    Node(id: 'c', name: 'C', floor: 0, x: 2, y: 0, type: NodeType.quarto),
  ];

  const edges = [
    Edge(origin: 'a', destination: 'b', distance: 10, accessible: true),
    Edge(origin: 'b', destination: 'c', distance: 10, accessible: true),
    // Stair-only shortcut — shorter but inaccessible.
    Edge(origin: 'a', destination: 'c', distance: 5, accessible: false),
  ];

  setUp(() {
    mockRepo = MockMapRepository();
    useCase = CalculateRoute(mockRepo);

    // Default happy-path stubs.
    when(() => mockRepo.getNodes()).thenAnswer((_) async => right(nodes));
    when(() => mockRepo.getEdges()).thenAnswer((_) async => right(edges));
  });

  group('CalculateRoute', () {
    test(
      'call avoidStairs=true returns accessible path a→b→c',
      () async {
        final result = await useCase(
          const CalculateRouteParams(
            originNodeId: 'a',
            destinationNodeId: 'c',
            avoidStairs: true,
          ),
        );

        expect(result.isRight(), true);
        final route = result.getRight().toNullable()!;
        expect(route.nodes.map((n) => n.id).toList(), ['a', 'b', 'c']);
        expect(route.isFullyAccessible, true);
        expect(route.totalDistance, 20.0);
      },
    );

    test(
      'call avoidStairs=false returns shortest path a→c via stair shortcut',
      () async {
        final result = await useCase(
          const CalculateRouteParams(
            originNodeId: 'a',
            destinationNodeId: 'c',
            avoidStairs: false,
          ),
        );

        expect(result.isRight(), true);
        final route = result.getRight().toNullable()!;
        // Dijkstra picks the shorter direct edge (distance 5) over a→b→c (distance 20).
        expect(route.nodes.map((n) => n.id).toList(), ['a', 'c']);
        expect(route.isFullyAccessible, false);
        expect(route.totalDistance, 5.0);
      },
    );

    test(
      'call avoidStairs=true returns RouteNotFoundFailure when no accessible path exists',
      () async {
        when(() => mockRepo.getEdges()).thenAnswer(
          (_) async => right(const [
            Edge(origin: 'a', destination: 'c', distance: 5, accessible: false),
          ]),
        );

        final result = await useCase(
          const CalculateRouteParams(
            originNodeId: 'a',
            destinationNodeId: 'c',
            avoidStairs: true,
          ),
        );

        expect(result.isLeft(), true);
        expect(
          result.getLeft().toNullable(),
          isA<RouteNotFoundFailure>(),
        );
      },
    );

    test(
      'call returns GraphFailure when origin node does not exist',
      () async {
        final result = await useCase(
          const CalculateRouteParams(
            originNodeId: 'z', // Does not exist in [nodes]
            destinationNodeId: 'c',
            avoidStairs: false,
          ),
        );

        expect(result.isLeft(), true);
        expect(result.getLeft().toNullable(), isA<GraphFailure>());
      },
    );
  });
}