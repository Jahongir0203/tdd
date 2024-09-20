import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd/core/network/network_info.dart';
import 'package:tdd/core/utils/input_converter.dart';
import 'package:tdd/features/data/datasource/number_trivia_local_data_source.dart';
import 'package:tdd/features/data/datasource/number_trivia_remote_data_source.dart';
import 'package:tdd/features/data/repository/number_trivia_repository_impl.dart';
import 'package:tdd/features/domain/entities/number_trivia.dart';
import 'package:tdd/features/domain/repository/number_trivia_repository.dart';
import 'package:tdd/features/presentation/bloc/number_trivia/number_trivia_bloc.dart';
        import 'package:http/http.dart' as http;
import 'features/domain/usecase/get_concrete_number_trivia.dart';
import 'features/domain/usecase/get_random_number_trivia.dart';

final sl = GetIt.instance;

Future<void> init() async{
  /// Feature
  sl.registerFactory(
    () => NumberTriviaBloc(
        concrete: sl.call(), random: sl(), inputConverter: sl()),
  );
  // Use case
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository

  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
        remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()),
  );

  // Data source

  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  /// Core
  sl.registerLazySingleton(
    () => InputConverter(),
  );

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  /// External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences,);

  sl.registerLazySingleton(() => http.Client(),);
  sl.registerLazySingleton(() =>InternetConnectionChecker() ,) ;
}
