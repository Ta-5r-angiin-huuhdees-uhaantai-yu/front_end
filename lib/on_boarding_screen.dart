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
      "title": "Тархиа хөгжүүлцгээе",
      "subtitle": "Та 5-р ангийн хүүхдээс ухаантай юу!",
      "image": "🧠"
    },
    {
      "title": "Өндөр оноо авах боломж",
      "subtitle": "Та асуултанд хариулж оноогоо цуглуулан бусадтай өрсөлдөөрэй",
      "image": "📊"
    },
    {
      "title": "Хүссэн үедээ тоглоорой",
      "subtitle": "1 - 5-р ангийн хүүхдүүдийн үздэг хичээлийн талаар та хэр мэдэх вэ?",
      "image": "⏰"
    }
  ];

  final List<int> pointTiers = [50, 100, 250, 500, 750, 1000, 1500, 2500, 5000, 10000];

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
                    if (index == 1) ...[
                      SizedBox(height: 30),
                      Text("Онооны шатлал", style: TextStyle(fontSize: 20, color: Colors.orangeAccent)),
                      SizedBox(height: 10),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(pointTiers.length, (i) {
                          return Chip(
                            label: Text(
                              "${i + 1}-р асуулт: ${pointTiers[i]}",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.orange,
                          );
                        }),
                      ),
                    ]
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
