import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tv_shows_appp/Features/data/model/show_model.dart';

import '../../data/model/cast_model.dart';
import '../../data/repositories/show_repository.dart';

class ShowViewModel extends ChangeNotifier {
  final ShowRepository repository;

  ShowViewModel({required this.repository});

  List<ShowModel> _shows = [];
  List<CastModel> _cast = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  String? _errorMessage;

  int _currentPage = 0;
  Timer? _debounce;

  List<ShowModel> get shows => _shows;
  List<CastModel> get cast => _cast;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  Future<void> loadShows() async {
    try {
      debugPrint('Page loading started');

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentPage = 0;
      _hasMore = true;

      _shows = await repository.getShows(_currentPage);

      debugPrint(" Shows loaded: ${_shows.length}");
      _currentPage++;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isFetchingMore) return;

    debugPrint('Loaded more');
    _isFetchingMore = true;
    notifyListeners();

    try {
      final data = await repository.getShows(_currentPage);

      if (data.isEmpty) {
        _hasMore = false;
      } else {
        _shows.addAll(data);
        _currentPage++;
      }
    } catch (_) {
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  void search(String query) {
    // Cancels previous timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      // Handles empty query early
      if (query.trim().isEmpty) {
        _shows = [];
        _errorMessage = null;
        _hasMore = false;
        notifyListeners();
        return;
      }

      try {
        _isLoading = true;
        _errorMessage = null;
        notifyListeners();

        // Fetches shows from repository
        _shows = await repository.searchShows(query);
        _hasMore = false;

        // If no results set a message
        if (_shows.isEmpty) {
          _errorMessage = "No results found ";
        }
      } catch (_) {
        _errorMessage = "Search failed";
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> loadCast(int showId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _cast = await repository.getCast(showId);
    } catch (e) {
      _cast = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
