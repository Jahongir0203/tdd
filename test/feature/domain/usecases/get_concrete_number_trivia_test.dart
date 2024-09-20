import 'package:dartz/dartz.dart';
import 'package:tdd/core/usecases/usecases.dart';
import 'package:tdd/features/domain/entities/number_trivia.dart';
import 'package:tdd/features/domain/repository/number_trivia_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd/features/domain/usecase/get_concrete_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });
  const testNumber = 1;
  const testNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia for the number from the repository', () async {
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(1))
        .thenAnswer((_) async => const Right(testNumberTrivia));
    final result = await usecase(Params(number: testNumber));
    expect(result, const Right(testNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
