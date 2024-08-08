/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_quest/screens/components/sidebar.dart';
import 'package:job_quest/screens/job/jobs_card.dart';
import 'package:job_quest/utils/colors.dart';
import 'package:job_quest/utils/layout.dart';
import 'package:job_quest/utils/txt.dart';

class Search extends StatefulWidget {
  static const routename = "search";

  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _auth = FirebaseAuth.instance;
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    final uid = user!.uid;

    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 30.0, top: 40),
              child: Text(
                "Search For A Job",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchTerm = value;
                  });
                },
                style: TextStyle(color: yellow),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Flutter development",
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Color.fromRGBO(245, 186, 65, 1),
                  suffixIcon: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.all(22),
                    ),
                    onPressed: () {},
                    child: const Icon(Icons.search),
                  ),
                  suffixIconColor: yellow,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('jobPosted')
                    .orderBy('created', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    if (snapshot.data?.docs.isNotEmpty == true) {
                      var filteredDocs = snapshot.data.docs
                          .where((doc) =>
                              doc['title']
                                  .toString()
                                  .toLowerCase()
                                  .contains(_searchTerm.toLowerCase()) ||
                              doc['name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(_searchTerm.toLowerCase()))
                          .toList();

                      if (filteredDocs.isEmpty) {
                        return Center(
                          child: Text(
                            "No results found",
                            style: txt.error,
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 0,
                          bottom: layout.padding,
                          left: layout.padding,
                          right: layout.padding,
                        ),
                        child: ListView.builder(
                          itemCount: filteredDocs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Job(
                              jobID: filteredDocs[index]['job_id'],
                              contactName: filteredDocs[index]['name'],
                              contactImage: filteredDocs[index]['user_image'],
                              jobTitle: filteredDocs[index]['title'],
                              uploadedBy: filteredDocs[index]['id'],
                              date: filteredDocs[index]['created'].toDate(),
                              type: filteredDocs[index]['id'] == uid
                                  ? 'posted'
                                  : 'taken',
                            );
                          },
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(layout.padding * 6),
                        child: Center(
                          child: Image.asset('assets/images/empty.png'),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: Text(
                        'FATAL ERROR',
                        style: txt.error,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_quest/screens/components/sidebar.dart';
import 'package:job_quest/screens/job/job_details.dart';
import 'package:job_quest/utils/colors.dart';
import 'package:job_quest/utils/layout.dart';
import 'package:job_quest/utils/txt.dart';

class Search extends StatefulWidget {
  static const routename = "search";

  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _auth = FirebaseAuth.instance;
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 30.0, top: 40),
              child: Text(
                "Search For A Job",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchTerm = value;
                  });
                },
                style: TextStyle(color: yellow),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Enter job title or company name",
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Color.fromRGBO(245, 186, 65, 1),
                  suffixIcon: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.all(22),
                    ),
                    onPressed: () {},
                    child: const Icon(Icons.search),
                  ),
                  suffixIconColor: yellow,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: _searchTerm.isEmpty
                  ? Center(
                      child: Text(
                        "Enter a search term to find jobs",
                        style: txt.fieldDark,
                      ),
                    )
                  : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('jobPosted')
                          .orderBy('created', descending: true)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.data?.docs.isNotEmpty == true) {
                            var filteredDocs = snapshot.data.docs
                                .where((doc) =>
                                    doc['title']
                                        .toString()
                                        .toLowerCase()
                                        .contains(_searchTerm.toLowerCase()) ||
                                    doc['name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(_searchTerm.toLowerCase()))
                                .toList();

                            if (filteredDocs.isEmpty) {
                              return Center(
                                child: Text(
                                  "No results found",
                                  style: txt.error,
                                ),
                              );
                            }

                            return ListView.builder(
                              itemCount: filteredDocs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: ListTile(
                                    title: Text(
                                      filteredDocs[index]['title'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Text(
                                      filteredDocs[index]['name'],
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              JobDetailsScreen(
                                            id: filteredDocs[index]['id'],
                                            job_id: filteredDocs[index]['job_id'],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(layout.padding * 6),
                              child: Center(
                                child: Image.asset('assets/images/empty.png'),
                              ),
                            );
                          }
                        } else {
                          return Center(
                            child: Text(
                              'FATAL ERROR',
                              style: txt.error,
                            ),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
