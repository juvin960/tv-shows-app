class CastModel {
  final String name;
  final String? image;
  final String character;

  CastModel({
    required this.name,
    required this.character,
    this.image,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      name: json['person']['name'],
      character: json['character']['name'],
      image: json['person']['image']?['medium'],
    );
  }
}
