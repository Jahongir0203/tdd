import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd/features/presentation/bloc/number_trivia/number_trivia_bloc.dart';

import '../../../injection_container.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberTriviaBloc bloc = sl<NumberTriviaBloc>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade800,
        title: const Text(
          "Number Trivia",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocProvider(
        create: (context) => sl<NumberTriviaBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                bloc: bloc,
                builder: (context, state) {
                  if (state is NumberTriviaInitialState) {
                    return const MessageDisplay(message: "Start searching");
                  }

                  if (state is NumberTriviaFailureState) {
                    return MessageDisplay(message: state.message);
                  }

                  if (state is NumberTriviaLoadingState) {
                    return const LoadingDisplay();
                  }
                  if (state is NumberTriviaLoadedState) {
                    return NumberTriviaDisplay(
                        numberTrivia: state.numberTrivia);
                  }

                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: TextFormField(
                  controller: bloc.textEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Input a number",
                    hintStyle: const TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  buildCustomButton("Search", () {
                    if (bloc.textEditingController.text.isNotEmpty) {
                      bloc.add(
                        GetConcreteNumberTriviaEvent(
                            numberString: bloc.textEditingController.text),
                      );
                      bloc.textEditingController.clear();
                    }
                  }),
                  const SizedBox(
                    width: 10,
                  ),
                  buildCustomButton("Get random trivia", () {
                    bloc.add(GetRandomNumberTriviaEvent());
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildCustomButton(String text, Function onPressed) {
    return Expanded(
      child: Material(
        child: InkWell(
          onTap: () {
            onPressed();
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: text == "Search"
                  ? Colors.green.shade800
                  : Colors.grey.shade300,
              border: Border.all(
                color: text == "Search" ? Colors.green.shade800 : Colors.white,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: text == "Search" ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
