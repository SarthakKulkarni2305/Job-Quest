import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_quest/config/user_state.dart';
import 'package:job_quest/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: ((context, snapshot) {
        //snapshot = data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.black,
              primarySwatch: Colors.blue,
            ),
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          print('Error initializing Firebase: ${snapshot.error}');
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.black,
              primarySwatch: Colors.blue,
            ),
            home: Scaffold(
              body: Center(
                  child: Text(
                'An error has been occured',
                style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              )),
            ),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Job Quest',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: Colors.blue,
            ),
            home: const UserState(),
            //home: const HomePage(),
          );
        }
      }),
    );
  }
}
