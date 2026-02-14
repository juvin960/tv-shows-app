import 'package:flutter/material.dart';
import 'package:tv_shows_appp/Features/data/local_database/databas_helper.dart';
import 'package:tv_shows_appp/Features/utils/methods.dart';

import '../api_client.dart';
import '../endpoints.dart';
import '../../model/cast_model.dart';
import '../../model/show_model.dart';

class ShowRepository {
  final ApiClient apiClient;

  ShowRepository(this.apiClient);

  /// get shows
  /// [page] the page where we want to get data from
  Future<List<ShowModel>> getShows(int page) async {
    // call method to check if internet is available
    bool isInternetAvailable = await Methods.checkInternetConnection();

    // if no internet, get data from local database
    if (!isInternetAvailable) {
      return getLocalShows(page: page);
    }

    // fetch data from API
    final data = await apiClient.get(
      Endpoints.getShowList,
      queryParameters: {"page": page.toString()},
    );

    List<ShowModel> showsList = [];

    for (var show in (data as List)) {
      ShowModel showModel = ShowModel.fromJson(show);
      // call db method save the data
      await DatabaseHelper.insertOrUpdateShows(
        show: showModel,
        showId: show["id"] ?? 0,
      );
      showsList.add(showModel);
    }
    return showsList;
    // return (data as List).map((json) => ShowModel.fromJson(json)).toList();
  }

  /// search shows
  /// [query] search query
  Future<List<ShowModel>> searchShows(String query) async {
    // call method to check if internet is available
    bool isInternetAvailable = await Methods.checkInternetConnection();

    // if no internet, search shows from local database
    if (!isInternetAvailable) {
      return searchLocalShows(query: query);
    }

    final data = await apiClient.get(
      Endpoints.searchShows,
      queryParameters: {"q": query},
    );

    return (data as List)
        .map((json) => ShowModel.fromJson(json['show']))
        .toList();
  }

  /// get shows from local database
  /// [page] get data for the specified page
  Future<List<ShowModel>> getLocalShows({required int page}) async {
    // get data from device database
    return await DatabaseHelper.getLocalShows(
      offset: page,
    );
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