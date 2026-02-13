import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tv_shows_appp/Features/data/local_database/databas_helper.dart';
import 'package:tv_shows_appp/Features/data/model/local_show_model.dart';
import 'package:tv_shows_appp/Features/utils/methods.dart';

import '../api_client.dart';
import '../endpoints.dart';
import '../model/cast_model.dart';
import '../model/show_model.dart';

class ShowRepository {
  final ApiClient apiClient;

  ShowRepository(this.apiClient);

  Future<List<ShowModel>> getShows(int page) async {
    bool isInternetAvailable = await Methods.checkInternetConnection();
    // debugPrint('page loaded');

    if (!isInternetAvailable) {
      return getLocalShows(page: page);
    }

    final data = await apiClient.get(
      Endpoints.getShowList,
      queryParameters: {"page": page.toString()},
    );

    debugPrint("API data $data");

    debugPrint("API data length: ${(data).length}");
    List<ShowModel> showsList = [];


    for (var show in (data as List)) {
      ShowModel showModel = ShowModel.fromJson(show);
      // call db method save the data
      debugPrint("show id is ${show["id"] }");
      await DatabaseHelper.insertOrUpdateShows(show: showModel, showId: show["id"] ?? 0);
      showsList.add(showModel);
    }
    return showsList;
    // return (data as List).map((json) => ShowModel.fromJson(json)).toList();
  }

  // search shows
  Future<List<ShowModel>> searchShows(String query) async {
    final data = await apiClient.get(
      Endpoints.searchShows,
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

    return (data as List).map((json) => CastModel.fromJson(json)).toList();
  }

  // Future<void> getAndStoreAllShows() async {
  //   final data = await apiClient.get(Endpoints.getShowList);
  //
  //   debugPrint("All shows data $data");
  //
  //   debugPrint("All shows data length: ${(data).length}");
  //
  //
  //   // store each show to the local database
  //   var i = 1;
  //   for (var show in data) {
  //     // call db method save the data
  //     await DatabaseHelper.insertOrUpdateShows(show: show, showId: show["id"] ?? 0);
  //     i++;
  //   }
  // }

  Future<List<ShowModel>> getLocalShows({required int page}) async {
    // call db method save the data
    List<ShowModel> showsList = await DatabaseHelper.getLocalShows(
      offset: page,
    );

    //
    // debugPrint("All local shows data $showsList");
    //
    // debugPrint("All local shows data length: ${(showsList).length}");
    //
    // List<ShowModel> showModelsList = [];
    //
    // for (var localShow in showsList) {
    //   Map<String, dynamic> showMap = jsonDecode(localShow.show);
    //   ShowModel showModel =  ShowModel.fromJson(showMap);
    //   debugPrint("show mode ${showModel.image}");
    //
    //   showModelsList.add(showModel);
    // }

    // var list = (showsList)
    //     .map((localShowModel) => () {
    //       Map<String, dynamic> showMap = jsonDecode(localShowModel.show);
    //
    //       return ShowModel.fromJson(showMap);
    // })
    //     .toList();
    return showsList;
  }

  /// searches for shows from local database when offline with
  /// search parameter [query]
  Future<List<ShowModel>> searchLocalShows(String query) async {
    final data = await apiClient.get(
      Endpoints.searchShows,
      queryParameters: {"q": query},
    );

    return (data as List)
        .map((json) => ShowModel.fromJson(json['show']))
        .toList();
  }
}
