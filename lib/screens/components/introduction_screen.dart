import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:job_quest/screens/components/welcome_screen.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  Widget _buildImage(String assetName, [double width = 300]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 18.0, color: Colors.white70);
    const titleStyle = TextStyle(
        fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.white);

    const pageDecoration = PageDecoration(
      titleTextStyle: titleStyle,
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Color(0xFF1E1E1E),
      imagePadding: EdgeInsets.only(top: 24.0),
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Color(0xFF1E1E1E),
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _buildImage('logo1.png', 80),
          ),
        ),
      ),
      globalFooter: Container(
        width: double.infinity,
        height: 60,
        color: Color(0xFF1E1E1E),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00BFA5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Start your Hiring Journey!',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Step into a world of career prospects",
          body: "Discover endless opportunities waiting for you",
          image: _buildImage('job_offer.jpg'),
          decoration: pageDecoration,
          reverse: true,
        ),
        PageViewModel(
          title: "Unlock Endless Career Opportunities",
          body: "Stay Ahead with the Latest Job Openings",
          image: _buildImage('new_jobs.jpg'),
          decoration: pageDecoration,
          reverse: true,
        ),
        PageViewModel(
          title: "Your Go-To for Current Job Vacancies",
          body: "Find the perfect job match for your skills and aspirations",
          image: _buildImage('hiring.png'),
          decoration: pageDecoration,
          reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      back: const Icon(Icons.arrow_back, color: Color(0xFF00BFA5)),
      skip: const Text('Skip',
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF00BFA5))),
      next: const Icon(Icons.arrow_forward, color: Color(0xFF00BFA5)),
      done: const Text('Done',
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF00BFA5))),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.white24,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        activeColor: Color(0xFF00BFA5),
        spacing: EdgeInsets.symmetric(horizontal: 3.0),
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: Colors.black87.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      isProgressTap: true,
      showNextButton: true,
      animationDuration: 400,
    );
  }
}
