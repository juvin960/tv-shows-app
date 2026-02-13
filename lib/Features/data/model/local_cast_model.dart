class LocalCastModel {
  final int? id;
  final String cast;
  final int showId;
  final int castId;

  const LocalCastModel({
    this.id,
    required this.cast,
    required this.showId,
    required this.castId,
  });

  // Convert a Show into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {'id': id, 'show': cast, "show_id": showId, "cast_id": castId};
  }
}
