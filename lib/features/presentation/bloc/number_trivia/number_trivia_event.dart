part of 'number_trivia_bloc.dart';

sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetConcreteNumberTriviaEvent extends NumberTriviaEvent {
  final String numberString;

  const GetConcreteNumberTriviaEvent({required this.numberString});

  @override
  List<Object?> get props => [numberString];
}

class GetRandomNumberTriviaEvent extends NumberTriviaEvent {
  @override
  List<Object?> get props => [];
}


