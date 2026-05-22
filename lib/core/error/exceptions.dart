/// Thrown by MapLocalDataSourceImpl when the SQLite database is unavailable.
class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}

/// Thrown when the bundled JSON asset cannot be read or parsed.
class AssetException implements Exception {
  final String message;
  const AssetException(this.message);

  @override
  String toString() => 'AssetException: $message';
}
