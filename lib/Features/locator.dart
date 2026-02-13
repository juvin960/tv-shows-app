import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:tv_shows_appp/Features/data/repositories/show_repository.dart';
import 'package:tv_shows_appp/Features/presentation/view_model/show_view_model.dart';

import 'data/api_client.dart';
import 'data/endpoints.dart';


final sl = GetIt.instance;

void setupLocator() {

  // Register ApiClient
  sl.registerLazySingleton(() => ApiClient(client: http.Client(),
    baseUrl: Endpoints.baseUrl,
  ));

  // Register Repository
  sl.registerLazySingleton(() => ShowRepository(sl<ApiClient>()));

  // Register ViewModel
  sl.registerFactory(() => ShowViewModel(repository: sl<ShowRepository>()));
}
