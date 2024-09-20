import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd/core/error/failure.dart';
import 'package:tdd/features/domain/entities/number_trivia.dart';

abstract class Usecases<Type, Params> {
  Future<Either<Failure, Type>> call(Params prams);
}

class NoParams extends Equatable{
  @override
  List<Object?> get props => [];
}

class Params extends Equatable{
  final int number;

  Params({required this.number});

  @override
  List<Object?> get props => [number];

}