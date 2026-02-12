

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tv_shows_appp/Features/data/model/show_model.dart';

import '../../data/repository.dart';

class ShowViewModel extends ChangeNotifier{
  final ShowRepository repository;

  ShowViewModel({required this.repository});


  List<ShowModel> _shows = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  String? _errorMessage;

  int _currentPage = 0;
  Timer? _debounce;


  List<ShowModel> get shows => _shows;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  Future<void> loadShows() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentPage = 0;
      _hasMore = true;

      _shows = await repository.getShows(_currentPage);
      _currentPage++;
    } catch (e) {
      _errorMessage = "Failed to load shows";
    }

    _isLoading = false;
    notifyListeners();
  }

}