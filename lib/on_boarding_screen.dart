import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Boost Your Brain",
      "subtitle": "Fun quizzes to challenge your mind and learn fast!",
      "image": "🧠"
    },
    {
      "title": "Track Progress",
      "subtitle": "Earn points, unlock levels, and see how you improve.",
      "image": "📊"
    },
    {
      "title": "Play Anytime",
      "subtitle": "Pick from subjects like Math, History, Chemistry and more.",
      "image": "⏰"
    }
  ];

  void nextPage() {
    if (currentPage == 2) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void skip() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(onboardingData[index]["image"]!, style: TextStyle(fontSize: 80)),
                    SizedBox(height: 30),
                    Text(
                      onboardingData[index]["title"]!,
                      style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      onboardingData[index]["subtitle"]!,
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            right: 20,
            top: 40,
            child: TextButton(
              onPressed: skip,
              child: Text("Skip", style: TextStyle(color: Colors.white70)),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: ElevatedButton(
              onPressed: nextPage,
              child: Text(currentPage == 2 ? "Start" : "Next"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
