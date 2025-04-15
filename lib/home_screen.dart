import 'package:bd_frontend/bloc/lesson_all_bloc.dart';
import 'package:bd_frontend/bloc/user_info_bloc.dart';
import 'package:bd_frontend/quiz_screen.dart';
import 'package:bd_frontend/widgets/full_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:io';

import 'bloc/answer_bloc.dart';
import 'bloc/choose_question_bloc.dart';
import 'model/api_service.dart';
import 'model/lesson_all_response.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<LessonItem> lessonList = [];
  String loginName = 'User';
  int rank = 0;
  int totalPoints = 0;
  String profileImage =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
  String? _pickedImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserInfoBloc>(
          create: (context) => UserInfoBloc(ApiService())..add(FetchUserInfo()),
        ),
        BlocProvider<LessonAllBloc>(
          create: (context) => LessonAllBloc(ApiService())..add(FetchLessonInfo()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<UserInfoBloc, UserInfoState>(
            listener: _blocListener,
          ),
          BlocListener<LessonAllBloc, LessonAllState>(
            listener: _lessonBlocListener,
          ),
        ],
        child: BlocBuilder<UserInfoBloc, UserInfoState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _lessonBlocListener(BuildContext context, LessonAllState state) async {
    fullLoader(state is LessonAllLoading);
    if (state is LessonAllSuccess) {
      setState(() {
        lessonList = state.data ?? [];
      });
    } else if (state is LessonAllFailure) {
    }
  }

  void _blocListener(BuildContext context, UserInfoState state) async {
    fullLoader(state is UserInfoLoading);
    if (state is UserInfoSuccess) {
      setState(() {
        loginName = state.loginName ?? 'User';
        totalPoints = state.totalPoints ?? 0;
        rank = state.rank ?? 0;
        profileImage = state.profileImage ?? '';
      });
    } else if (state is UserInfoFailure) {
    }
  }

  Widget _blocBuilder(BuildContext context, UserInfoState state) {
    final imageToDisplay = _pickedImage ?? profileImage;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Сайн уу, $loginName",
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                      Text("Өнөөдрийг үр бүтээлтэй өнгөрүүлцгээе",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: imageToDisplay.startsWith('http')
                          ? NetworkImage(imageToDisplay)
                          : FileImage(File(imageToDisplay)) as ImageProvider,
                      child: profileImage.isEmpty ? Icon(Icons.person) : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Ranking & Points
              Row(
                children: [
                  buildInfoCard(
                    "Ranking",
                    "$rank",
                    Icons.emoji_events,
                    () {
                      Navigator.pushNamed(context, '/leaderboard');
                    },
                  ),
                  SizedBox(width: 12),
                  buildInfoCard(
                    "Оноо",
                    "$totalPoints",
                    Icons.monetization_on,
                    () {},
                  ),
                ],
              ),

              SizedBox(height: 20),
              Text("Та 5-р ангийн хүүхдээс ухаантай юу",
                  style: TextStyle(fontSize: 20, color: Colors.white)),

              SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  itemCount: lessonList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    final lesson = lessonList[index];
                    return buildCategoryCard(
                      lesson.lesson,
                      lesson.questionCount,
                      getLessonIcon(lesson.lesson),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 160,
        height: 48,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<AnswerBloc>(
                      create: (_) => AnswerBloc(),
                    ),
                    BlocProvider<ChooseQuestionBloc>(
                      create: (_) => ChooseQuestionBloc(ApiService())..add(FetchLessonAllInfo()),
                    ),
                  ],
                  child: QuizScreen(),
                ),
              ),
            );
          },
          backgroundColor: Colors.grey[700],
          label: Text(
            "Эхлэх",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 6,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  IconData getLessonIcon(String lessonName) {
    switch (lessonName) {
      case "Монгол хэл":
        return Icons.menu_book;
      case "Дуу хөгжим":
        return Icons.music_note;
      case "Хүн орчин":
        return Icons.public;
      case "Дүрслэх урлаг":
        return Icons.brush;
      case "Хүн байгаль":
        return Icons.nature;
      case "Биеийн тамир":
        return Icons.sports_basketball;
      case "Мэдээллийн технологи":
        return Icons.computer;
      case "Технологи":
        return Icons.devices;
      case "Математик":
        return Icons.calculate;
      case "Иргэний боловсрол":
        return Icons.person;
      default:
        return Icons.book;
    }
  }

  Widget buildInfoCard(
      String title, String value, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.yellow),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.white70)),
                  Text(value,
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryCard(String title, int count, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.orangeAccent),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text("$count асуулт", style: TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}
