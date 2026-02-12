import 'api_client.dart';
import 'endponts.dart';
import 'model/show_model.dart';

class ShowRepository {
  final ApiClient apiClient;

  ShowRepository(this.apiClient);

  //shows for a specific page
  Future<List<ShowModel>> getShows(int page) async {
    final data = await apiClient.get(Endpoints.getShowList,
      queryParameters: {"page": page.toString()},
    );

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
}
