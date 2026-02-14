import 'package:flutter/material.dart';
import 'package:tv_shows_appp/Features/data/local_database/databas_helper.dart';
import 'package:tv_shows_appp/Features/utils/methods.dart';

import '../api_client.dart';
import '../endpoints.dart';
import '../../model/cast_model.dart';
import '../../model/show_model.dart';

class CastRepository {
  final ApiClient apiClient;

  CastRepository(this.apiClient);


  /// get show cast by show ID [showId]
  Future<List<CastModel>> getCast(int showId) async {
    // call method to check if internet is available
    bool isInternetAvailable = await Methods.checkInternetConnection();

    // if no internet, get data from local database
    if (!isInternetAvailable) {
      return getLocalCast(showId: showId);
    }

    // get data from API
    final data = await apiClient.get("${Endpoints.showCast}/$showId/cast");
    List<CastModel> castList = [];

    for (var cast in (data as List)) {
      int castId = cast['person']['id'];

      CastModel castModel = CastModel(
        id: castId,
        name: cast['person']['name'],
        character: cast['character']['name'],
        image: cast['person']['image']?['medium'],
        showId: showId,
      );
      // call database method save the data locally for offline usage
      await DatabaseHelper.insertOrUpdateCast(
          cast: castModel,
          showId: showId,
          castId: castId
      );
      castList.add(castModel);
    }

    return castList;
  }


  /// searches for shows from local database when offline with
  /// search parameter [query]
  Future<List<ShowModel>> searchLocalShows({required String query}) async {
    return await DatabaseHelper.searchLocalShows(searchTerm: query);
  }

  /// gets cast from local database by show ID [showId]
  Future<List<CastModel>> getLocalCast({required int showId}) async {
    return await DatabaseHelper.getLocalCast(showId: showId);
  }

}