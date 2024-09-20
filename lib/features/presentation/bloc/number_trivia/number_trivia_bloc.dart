import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tdd/core/usecases/usecases.dart';
import 'package:tdd/core/utils/input_converter.dart';
import 'package:tdd/features/domain/entities/number_trivia.dart';
import 'package:tdd/features/domain/usecase/get_concrete_number_trivia.dart';
import 'package:tdd/features/domain/usecase/get_random_number_trivia.dart';

import '../../../../core/error/failure.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const serverFailure = 'Server failure';
const cacheFailure = "Cache failure";
const invalidInputFailureMessage =
    "Invalid Input - The number must be a positive integer or zero";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  late final GetRandomNumberTrivia getRandomNumberTrivia;
  late final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final InputConverter inputConverter;
  final TextEditingController textEditingController = TextEditingController();

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        super(NumberTriviaInitialState()) {
    getRandomNumberTrivia = random;
    getConcreteNumberTrivia = concrete;

    /// NumberTriviaEvent
    on<NumberTriviaEvent>((event, emit) {});

    /// GetConcreteNumberTriviaEvent
    on<GetConcreteNumberTriviaEvent>(
      (event, emit) async {
        final inputEither =
            await inputConverter.stringToInt(event.numberString);
        await inputEither.fold(
          (failure) {
            emit(
              NumberTriviaFailureState(
                message: _mapFailureToString(failure),
              ),
            );
          },
          (r) async {
            emit(NumberTriviaLoadingState());
            final failureOrTrivia = await getConcreteNumberTrivia(
              Params(number: r),
            );

            failureOrTrivia.fold(
              (failure) {
                emit(
                  NumberTriviaFailureState(
                    message: _mapFailureToString(failure),
                  ),
                );
              },
              (trivia) {
                emit(
                  NumberTriviaLoadedState(numberTrivia: trivia),
                );
              },
            );
          },
        );
      },
    );

    /// GetRandomNumberTriviaEvent
    on<GetRandomNumberTriviaEvent>(
      (event, emit) async {
        emit(NumberTriviaLoadingState());

        final failureOrTrivia = await getRandomNumberTrivia(
          NoParams(),
        );
        try {
          failureOrTrivia.fold(
            (failure) {
              emit(
                NumberTriviaFailureState(
                  message: _mapFailureToString(failure),
                ),
              );
            },
            (trivia) {
              emit(
                NumberTriviaLoadedState(numberTrivia: trivia),
              );
            },
          );
        } catch (e) {
          print(e);
          emit(NumberTriviaFailureState(message: e.toString()));
        }
      },
    );
  }
}

/// MapFailureToString

String _mapFailureToString(Failure failure) {
  switch (failure.runtimeType) {
    case const (ServerFailure):
      return serverFailure;
    case const (CacheFailure):
      return cacheFailure;
    default:
      return ("Unexpected error");
  }
}
