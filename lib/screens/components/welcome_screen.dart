import 'package:flutter/material.dart';
import 'package:job_quest/screens/user_credentials/login_screen.dart';
import 'package:job_quest/screens/user_credentials/signup_screen.dart';
import 'package:job_quest/widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF74EBD5), // Example new gradient color
              Color(0xFFACB6E5), // Example new gradient color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(
              height: 230,
              child: Image(
                image: AssetImage('assets/images/logo1.png'),
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 150),
            CustomButton(
              buttonText: 'Login',
              buttonColor: Colors.blueAccent, // Updated button color
              textColor: Colors.white, // Updated text color
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
            ),
            CustomButton(
              buttonText: 'Register',
              buttonColor: Colors.lightBlueAccent, // Updated button color
              textColor: Colors.white, // Updated text color
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignUpScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Welcome To Your Hiring Journey !!',
                style: TextStyle(
                  color: Colors.deepPurple, // Updated text color
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
