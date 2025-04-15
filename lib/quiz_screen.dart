import 'package:bd_frontend/bloc/answer_bloc.dart';
import 'package:bd_frontend/bloc/choose_question_bloc.dart';
import 'package:bd_frontend/model/choose_question_response.dart';
import 'package:bd_frontend/widgets/full_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'model/api_service.dart';
import 'model/variables.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> userAnswers = [];
  List<QuestionItem> questionList = [];
  int currentQuestion = 0;
  int? selectedAnswer;
  bool isAnswered = false;
  bool gameOver = false;
  int earnedMoney = 0;
  bool correct = true;

  final ApiService apiService = ApiService(); // Instantiate ApiService

  void checkAnswer(int index) {
    if (isAnswered) return;

    final q = questionList[currentQuestion];

    userAnswers.add({
      'questionId': q.id,
      'selectedIndex': index,
    });

    setState(() {
      selectedAnswer = index;
      isAnswered = true;
    });
  }

  void nextQuestion() {
    setState(() {
      currentQuestion++;
      isAnswered = false;
      selectedAnswer = null;
      correct = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AnswerBloc, AnswerState>(
          listener: _answerBlocListener,
        ),
        BlocListener<ChooseQuestionBloc, ChooseQuestionState>(
          listener: _blocListener,
        ),
      ],
      child: BlocBuilder<ChooseQuestionBloc, ChooseQuestionState>(
        builder: _blocBuilder,
      ),
    );
  }

  void _answerBlocListener(BuildContext context, AnswerState state) {
    fullLoader(state is AnswerLoading);

    if (state is AnswerSuccess) {
      print('rrrrrrrrrrr${state.answeredCount}');
      print('rrrrrrrrr${state.correct}');
      setState(() {
        isAnswered = true;
        earnedMoney = state.answeredCount ?? 0;
        correct = state.correct ?? false;
      });

      // if (!correct || gameOver) {
      //   Future.microtask(() {
      //     Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(
      //         builder: (_) => ResultScreen(
      //           earnedMoney: earnedMoney,
      //           isWinner: false,
      //         ),
      //       ),
      //     );
      //   });
      // }
    }
  }

  void _blocListener(BuildContext context, ChooseQuestionState state) async {
    fullLoader(state is ChooseQuestionLoading);
    if (state is ChooseQuestionSuccess) {
      setState(() {
        questionList = state.data ?? [];
      });
      print('kjhgfdsa${questionList}kjhgfdsa');
    } else if (state is ChooseQuestionFailure) {
      print('jjjjjjjjjjjjjj');
    }
  }

  Widget _blocBuilder(BuildContext context, ChooseQuestionState state) {
    if (questionList.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    final q = questionList[currentQuestion];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Question ${currentQuestion + 1}/10"),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: Text("${currentQuestion + 1}/10")),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              q.questionText,
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ...List.generate(q.options.length, (i) {
              Color borderColor = Colors.grey;
              IconData? icon;

              if (isAnswered) {
                if (i == q.correctAnswerIndex) {
                  borderColor = Colors.cyan;
                  icon = Icons.check_circle_outline;
                } else if (i == selectedAnswer) {
                  borderColor = Colors.red;
                  icon = Icons.cancel_outlined;
                }
              }

              return GestureDetector(
                onTap: () => checkAnswer(i),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          q.options[i],
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      if (icon != null) Icon(icon, color: borderColor),
                    ],
                  ),
                ),
              );
            }),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                if (isAnswered) {
                  if (currentQuestion < questionList.length - 1) {
                    // go to next question
                    nextQuestion();
                  } else if (currentQuestion == questionList.length - 1) {
                    // Submit answers for the last question;
                    print('fffffffffffffff${userAnswers}');
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => ResultScreen(
                          userAnswers: userAnswers,
                        ),
                      ),
                    );
                    print('objefewfweefwect');
                  }
                }
              },
              child: Text(currentQuestion < questionList.length - 1 ? "Next" : "Submit"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> userAnswers;

  const ResultScreen({required this.userAnswers});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnswerBloc()..add(BulkAnswersSubmitted(userAnswers)),
      child: BlocBuilder<AnswerBloc, AnswerState>(
        builder: (context, state) {
          if (state is AnswerLoading) {
            return _loading();
          } else if (state is BulkAnswerSuccess) {
            return _resultView(context, state.earnedMoney ?? 0, state.correctCount == 10);
          } else if (state is AnswerFailure) {
            return _errorView(state.error);
          }
          return _loading();
        },
      ),
    );
  }

  Widget _loading() => Scaffold(
    backgroundColor: Colors.black,
    body: Center(child: CircularProgressIndicator(color: Colors.white)),
  );

  Widget _errorView(String? message) => Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Text("Алдаа гарлаа: $message", style: TextStyle(color: Colors.red)),
    ),
  );

  Widget _resultView(BuildContext context, int earnedMoney, bool isWinner) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(title: Text("Game Over"), backgroundColor: Colors.black),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            earnedMoney == 10000
                ? "👑 Та 5-р ангийн хүүхдээс илүү ухаантай гэдгээ баталлаа! 10000 оноо авсанд баяр хүргэе! 🧠✨"
                : isWinner
                ? "🎉 Баяр хүргэе! Та бүх асуултанд зөв хариулж чадлаа!\nТа $earnedMoney оноо авлаа😁"
                : "Та $earnedMoney оноо авлаа. Та 5-р ангийн хүүхдээс ухаан муутай гэдгээ хүлээн зөвшөөрнө биз дээ😃",
            style: TextStyle(fontSize: 24, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
            child: Text(isWinner ? "Баярлалаа😊" : "Зөвшөөрч байна😅"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          )
        ],
      ),
    ),
  );
}