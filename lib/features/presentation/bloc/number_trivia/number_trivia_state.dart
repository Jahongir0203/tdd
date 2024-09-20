part of 'number_trivia_bloc.dart';

sealed class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

final class NumberTriviaInitialState extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class NumberTriviaLoadingState extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class NumberTriviaLoadedState extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  const NumberTriviaLoadedState({required this.numberTrivia});

  @override
  List<Object?> get props => [numberTrivia];
}

class NumberTriviaFailureState extends NumberTriviaState {
  final String message;

  const NumberTriviaFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}
