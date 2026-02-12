class ShowModel {
  final int id;
  final String name;
  final String? image;
  final String summery;


  ShowModel( {
    required this.id,
    required this.name,
    this.image,
    required this.summery,
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    return ShowModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      summery: json['summery'],
    );
  }
}
