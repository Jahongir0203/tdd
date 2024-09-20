import 'package:dartz/dartz.dart';
import 'package:tdd/core/error/exceptions.dart';

import 'package:tdd/core/error/failure.dart';
import 'package:tdd/core/network/network_info.dart';
import 'package:tdd/features/data/datasource/number_trivia_local_data_source.dart';
import 'package:tdd/features/data/datasource/number_trivia_remote_data_source.dart';
import 'package:tdd/features/data/models/number_trivia_model.dart';

import 'package:tdd/features/domain/entities/number_trivia.dart';

import '../../domain/repository/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      Future<NumberTriviaModel> Function() getRandomOrConcrete) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getRandomOrConcrete();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServiceFailure());
      }
    } else {
      try {
        final localeTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localeTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
