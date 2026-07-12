import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../core/network/dio_client.dart';
import '../core/network/interceptors/auth_interceptor.dart';
import '../core/network/bloc/network_bloc.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';

import '../features/jobs/data/datasources/jobs_remote_datasource.dart';
import '../features/jobs/data/repositories/jobs_repository_impl.dart';
import '../features/jobs/domain/repositories/jobs_repository.dart';
import '../features/jobs/presentation/bloc/job_action_bloc.dart';
import '../features/jobs/presentation/bloc/jobs_bloc.dart';

import '../core/services/location_service.dart';
import '../features/tracking/data/datasources/tracking_remote_datasource.dart';
import '../features/tracking/data/repositories/tracking_repository_impl.dart';
import '../features/tracking/domain/repositories/tracking_repository.dart';
import '../features/tracking/presentation/bloc/tracking_bloc.dart';
import '../features/profile/presentation/bloc/settings_cubit.dart';
import '../features/profile/presentation/bloc/service_history_bloc.dart';
import '../features/profile/data/datasources/profile_remote_datasource.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';
import '../core/services/app_update_manager.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());

  // Core
  sl.registerLazySingleton(
    () => AuthInterceptor(
      sharedPreferences: sl(),
      onUnauthorized: () {
        sl<AuthBloc>().add(LogoutEvent());
      },
    ),
  );
  sl.registerLazySingleton(() => DioClient(authInterceptor: sl()));
  sl.registerLazySingleton(() => NetworkBloc(sl()));

  // Features - Auth
  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl<DioClient>().dio),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // BLoC
  sl.registerLazySingleton(() => AuthBloc(authRepository: sl()));

  // Features - Jobs
  sl.registerLazySingleton<JobsRemoteDataSource>(
    () => JobsRemoteDataSource(sl<DioClient>().dio),
  );

  sl.registerLazySingleton<JobsRepository>(
    () => JobsRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => JobActionBloc(repository: sl()));
  sl.registerFactory(() => JobsBloc(repository: sl()));

  // Features - Tracking
  sl.registerLazySingleton(() => LocationService());

  sl.registerLazySingleton<TrackingRemoteDataSource>(
    () => TrackingRemoteDataSource(sl<DioClient>().dio),
  );

  sl.registerLazySingleton<TrackingRepository>(
    () => TrackingRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(
    () => TrackingBloc(
      repository: sl(),
      locationService: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Features - Dashboard
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSource(sl<DioClient>().dio),
  );

  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => DashboardBloc(repository: sl()));

  // Features - Profile/Settings
  sl.registerFactory(() => SettingsCubit(prefs: sl()));
  sl.registerFactory(() => ServiceHistoryBloc(repository: sl()));

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(sl<DioClient>().dio),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => ProfileBloc(repository: sl()));

  // Services
  sl.registerLazySingleton(() => AppUpdateManager(dioClient: sl()));
}
