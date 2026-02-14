import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tv_shows_appp/Features/model/show_model.dart';

import '../../model/cast_model.dart';
import '../../data/repositories/cast_repository.dart';
import '../../data/repositories/show_repository.dart';

class ShowViewModel extends ChangeNotifier {
  final ShowRepository showRepository;
  final CastRepository castRepository;

// dependency injection
  ShowViewModel( {required this.showRepository ,required this.castRepository});



  List<ShowModel> _shows = [];
  List<CastModel> _cast = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  String? _errorMessage;

  int _currentPage = 0;
  Timer? _debounce;

  // public getters
  List<ShowModel> get shows => _shows;
  List<CastModel> get cast => _cast;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  // Initial load of TV shows (used on first screen load or refresh)
  Future<void> loadShows() async {
    try {
      // Set loading state to true so UI can show a loader
      // Clear any previous error message
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Reset pagination to the first page
      _currentPage = 0;

      // Assume there are more pages available at the start
      _hasMore = true;
      _shows = await showRepository.getShows(_currentPage);

      // Move to the next page for future pagination calls
      _currentPage++;
    } finally {

      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isFetchingMore) return;


    _isFetchingMore = true;
    notifyListeners();

    try {
      final data = await showRepository.getShows(_currentPage);

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
        _shows = await showRepository.searchShows(query);
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
// Initially load cast
  Future<void> loadCast(int showId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _cast = await castRepository.getCast(showId);
    } catch (e) {
      _cast = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
