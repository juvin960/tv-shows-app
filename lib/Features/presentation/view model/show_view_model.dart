import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tv_shows_appp/Features/data/model/show_model.dart';
import '../../data/repositories/show_repository.dart';

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
      debugPrint('Page loading started');

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentPage = 0;
      _hasMore = true;

      _shows = await repository.getShows(_currentPage);

      debugPrint(" Shows loaded: ${_shows.length}");
      _currentPage++;
    }  finally{
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
    } catch (_) {}
    finally{
      _isFetchingMore = false;
      notifyListeners();
    }


  }


  void search(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {

      try {
        _isLoading = true;
        notifyListeners();

        _shows = await repository.searchShows(query);
        _hasMore = false;
      } catch (_) {
        _errorMessage = "Search failed";
      }

      _isLoading = false;
      notifyListeners();
    });
  }

}