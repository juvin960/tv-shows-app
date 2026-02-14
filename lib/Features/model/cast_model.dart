class CastModel {
  final int id;
  final String name;
  final String? image;
  final String character;
  final int? showId;

  CastModel({
    required this.id,
    required this.name,
    required this.character,
    this.image,
    this.showId
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      id: json['person']['id'],
      name: json['person']['name'],
      character: json['character']['name'],
      image: json['person']['image']?['medium'],
    );
  }

  // Convert a Show into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      "cast_id": id,
      "show_id": showId,
      "name": name,
      "image": image,
      "character": character
    };
  }
}