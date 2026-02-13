class LocalShowModel {
  final int? id;
  final int showId;
  final String show;

  const LocalShowModel({this.id, required this.show, required this.showId});

  // Convert a Show into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {'show': show, 'show_id': showId};
  }

}
