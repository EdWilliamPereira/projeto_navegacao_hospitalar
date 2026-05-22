/// A Point of Interest that users can search for and navigate to.
class Poi {
  final String id;
  final String name;
  final String category;
  final String nodeId; // The graph node this POI is anchored to
  final String description;
  final List<String> tags;

  const Poi({
    required this.id,
    required this.name,
    required this.category,
    required this.nodeId,
    required this.description,
    required this.tags,
  });
}
