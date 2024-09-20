import 'package:dartz/dartz.dart';
import 'package:tdd/core/error/failure.dart';
import 'package:tdd/core/usecases/usecases.dart';
import 'package:tdd/features/domain/entities/number_trivia.dart';
import 'package:tdd/features/domain/repository/number_trivia_repository.dart';

class GetRandomNumberTrivia implements Usecases<NumberTrivia, NoParams> {
  final NumberTriviaRepository numberTriviaRepository;

  GetRandomNumberTrivia(this.numberTriviaRepository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams prams) async {
    return await numberTriviaRepository.getRandomNumberTrivia();
  }
}
