import 'package:flutter/material.dart';
import 'package:job_quest/screens/components/sidebar.dart';
import 'package:job_quest/screens/job/activity_jobs_posted.dart';
import 'package:job_quest/screens/job/activity_jobs_taken.dart';

class JobsActivity extends StatefulWidget {
  const JobsActivity({super.key});

  @override
  State<JobsActivity> createState() => _JobsActivityState();
}

class _JobsActivityState extends State<JobsActivity> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.orange[100],
          iconTheme: const IconThemeData(
            color: Colors.orange,
          ),
          title: const Padding(
            padding: EdgeInsets.only(left: 180),
            child: Text(
              "JobQuest",
              style: TextStyle(color: Colors.orange),
            ),
          ),
          bottom: const TabBar(
            tabs: [Tab(text: 'Jobs Posted'), Tab(text: 'Jobs Applied')],
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 15),
          ),
        ),
        body: const TabBarView(children: [posted(), Applied()]),
      ),
    );
  }
}
