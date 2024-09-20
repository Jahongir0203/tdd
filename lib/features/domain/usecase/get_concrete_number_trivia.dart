import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tdd/core/error/failure.dart';
import 'package:tdd/core/usecases/usecases.dart';
import 'package:tdd/features/domain/entities/number_trivia.dart';
import 'package:tdd/features/domain/repository/number_trivia_repository.dart';

class GetConcreteNumberTrivia extends Usecases<NumberTrivia,Params> {
  final NumberTriviaRepository numberTriviaRepository;

  GetConcreteNumberTrivia(this.numberTriviaRepository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async =>
      await numberTriviaRepository.getConcreteNumberTrivia(params.number);
}

