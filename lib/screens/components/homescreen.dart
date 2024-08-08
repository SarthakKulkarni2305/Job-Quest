import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_quest/screens/components/search_screen.dart';
import 'package:job_quest/screens/components/sidebar.dart';
import 'package:job_quest/screens/job/activity.dart';
import 'package:job_quest/screens/job/job_post.dart';
import 'package:job_quest/screens/job/posted_jobs.dart';
import 'package:job_quest/screens/user_profile/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigationPage(
        title: "JobQuest",
      ),
    );
  }
}

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key, required this.title});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
  final String title;
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  late int currentIndex;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  void changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _uid = user!.uid;
    return Scaffold(
      body: <Widget>[
        const HomePage(),
        const Search(),
        const JobsActivity(),
        ProfilePage(userID: _uid),
      ][currentIndex],
      floatingActionButton: currentIndex == 0 || currentIndex == 1
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF00BFA5),
              shape: CircleBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Upload(userID: _uid)),
                );
              },
              child: const Icon(
                Icons.add_rounded,
                size: 35,
                color: Colors.white,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        //useLegacyColorScheme: false,
        backgroundColor: const Color(0xFF1E1E1E),
        currentIndex: currentIndex,
        onTap: changePage,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
            activeIcon: Icon(Icons.home, color: Color(0xFF00BFA5)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.white),
            label: 'Search',
            activeIcon: Icon(Icons.search, color: Color(0xFF00BFA5)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work, color: Colors.white),
            label: 'Activity',
            activeIcon: Icon(Icons.work, color: Color(0xFF00BFA5)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            label: 'Profile',
            activeIcon: Icon(Icons.person, color: Color(0xFF00BFA5)),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(
          color: Color(0xFF00BFA5),
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 180),
          child: Text(
            "JobQuest",
            style: TextStyle(color: Color(0xFF00BFA5)),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // Padding(
            //   padding: EdgeInsets.only(left: 15, top: 10),
            //   child: Align(
            //     alignment: Alignment.center,
            //     child: Text(
            //       "Explore Secure and Swift",
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 25,
            //         color: Color(0xFF00BFA5),
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(left: 15, bottom: 15),
            //   child: Align(
            //     alignment: Alignment.center,
            //     child: Text(
            //       "Employment !!",
            //       style: TextStyle(
            //         color: Color(0xFF00BFA5),
            //         fontWeight: FontWeight.w900,
            //         fontSize: 35,
            //       ),
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            // ),
            SizedBox(height: 10),
            Postedjob(),
          ],
        ),
      ),
    );
  }
}
