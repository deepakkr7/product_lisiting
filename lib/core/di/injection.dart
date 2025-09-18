// core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/network_service.dart';
import '../../core/storage/storage_service.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/home_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/get_wish_list.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/verify_user.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_banners.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/search_products.dart';
import '../../domain/usecases/toggle_wishlist.dart';
import '../../presentation/bloc/auth_bloc.dart';
import '../../presentation/bloc/home_bloc.dart';
import '../../presentation/bloc/profile_bloc.dart';
import '../../presentation/bloc/wishlist_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(
        () => AuthBloc(
      verifyUser: sl(),
      loginRegister: sl(),
      getCurrentUser: sl(),
      logout: sl(),
    ),
  );

  sl.registerFactory(
        () => HomeBloc(
      getProducts: sl(),
      getBanners: sl(),
      getUserProfile: sl(),
      searchProducts: sl(),
      toggleWishlist: sl(),
    ),
  );

  sl.registerFactory(
        () => WishlistBloc(
      getWishlist: sl(),
      toggleWishlist: sl(),
    ),
  );

  sl.registerFactory(
        () => ProfileBloc(
      getUserProfile: sl(),
    ),
  );

  // Auth Use cases
  sl.registerLazySingleton(() => VerifyUser(sl()));
  sl.registerLazySingleton(() => LoginRegister(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  // Home Use cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetBanners(sl()));
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => SearchProductsUseCase(sl()));
  sl.registerLazySingleton(() => ToggleWishlist(sl()));

  //wishlist use cases
  sl.registerLazySingleton(() => GetWishlist(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(networkService: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(storageService: sl()),
  );

  sl.registerLazySingleton<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(networkService: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkService>(
        () => NetworkServiceImpl(
      client: sl(),
      storageService: sl(),
    ),
  );

  sl.registerLazySingleton<StorageService>(
        () => StorageServiceImpl(sharedPreferences: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
