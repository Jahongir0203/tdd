import 'dart:convert';

import 'package:tdd/features/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

import '../../../core/error/exceptions.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getNumberFromRemote("http://numbersapi.com/$number");
  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getNumberFromRemote("http://numbersapi.com/random");

  Future<NumberTriviaModel> _getNumberFromRemote(String url) async {
    var response = await client.get(
      Uri.parse(url),
      headers: {"Content-type": "application/json"},
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
