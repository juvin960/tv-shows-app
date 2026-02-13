import 'dart:convert';

class ShowModel {
  final int id;
  final String name;
  final String? image;
  final String summary;
  final List<dynamic> genreList;
  final String status;
  final String premiereDate;
  final String time;
  final String network;
  final String ratings;
  final List<dynamic> daysList;
  final String genreNames;

  ShowModel({
    required this.id,
    required this.name,
    this.image,
    required this.summary,
    required this.genreList,
    required this.status,
    required this.premiereDate,
    required this.time,
    required this.network,
    required this.ratings,
    required this.daysList,
    required this.genreNames,
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> networkMap = json['network'] ?? {};

    String networkName = "";

    if (networkMap.containsKey('name')) {
      networkName = networkMap['name'];
    }
    List<dynamic> genreList = json['genres'] ?? [];

    String genres = '';
    var i = 0;
    while (i < genreList.length) {
      if (i == 0) {
        genres = genreList[i].toString();
      } else {
        genres = '$genres ${genreList[i]}';
      }
      i++;
    }

    return ShowModel(
      id: json['id'],
      name: json['name'],
      image: json['image']['original'],
      summary: json['summary'],
      genreList: json['genres'],
      status: json['status'],
      premiereDate: json['premiered'],
      time: json['schedule']['time'],
      daysList: json['schedule']['days'],
      network: networkName,
      ratings: json['rating']['average'].toString(),
      genreNames: genres,
    );
  }

  // Convert a Show into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      "show_id": id,
      "name": name,
      "image": image,
      "summary": summary,
      "genreList": jsonEncode(genreList),
      "status": status,
      "premiereDate": premiereDate,
      "time": time,
      "network": network,
      "ratings": ratings,
      "daysList": jsonEncode(daysList),
      "genreNames": genreNames,
    };
  }

  Map toJson() => {
    "show_id": id,
    "name": name,
    "image": image,
    "summary": summary,
    "genreList": genreList,
    "status": status,
    "premiereDate": premiereDate,
    "time": time,
    "network": network,
    "ratings": ratings,
    "daysList": daysList,
    "genreNames": genreNames,
  };
}
