import 'package:flutter/material.dart';

import '../api_client.dart';
import '../endpoints.dart';
import '../model/cast_model.dart';
import '../model/show_model.dart';

class ShowRepository {
  final ApiClient apiClient;

  ShowRepository(this.apiClient);
  Future<List<ShowModel>> getShows(int page) async {

    // debugPrint('page loaded');

    final data = await apiClient.get(Endpoints.getShowList,
      queryParameters: {"page": page.toString()},
    );

    debugPrint("API data $data");

    debugPrint("API data length: ${(data).length}");


    return (data as List)
        .map((json) => ShowModel.fromJson(json))
        .toList();
  }

  // search shows
  Future<List<ShowModel>> searchShows(String query) async {
    final data = await apiClient.get(Endpoints.searchShows,
      queryParameters: {"q": query},
    );


    return (data as List)
        .map((json) => ShowModel.fromJson(json['show']))
        .toList();
  }

  Future<List<CastModel>> getCast(int page) async {
    final data = await apiClient.get(Endpoints.showCast);
    debugPrint("API data $data");
    debugPrint("API data length: ${(data).length}");


    return (data as List)
        .map((json) => CastModel.fromJson(json))
        .toList();
  }

}
