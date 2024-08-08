import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_quest/utils/clr.dart';
import 'package:job_quest/utils/global_variables.dart';
import 'package:job_quest/utils/layout.dart';
import 'package:job_quest/utils/txt.dart';
import 'package:job_quest/widgets/job_tile.dart';

class Postedjob extends StatefulWidget {
  const Postedjob({super.key});

  @override
  State<Postedjob> createState() => _PostedjobState();
}

class _PostedjobState extends State<Postedjob> {
  String? jobCategoryFilter;
  Future<Map<String, dynamic>>? userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = getMyData();
  }

  Future<Map<String, dynamic>> getMyData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        return {
          'name': userDoc.get('name'),
          'user_image': userDoc.get('user_image'),
          'address': userDoc.get('address'),
        };
      } else {
        print('User document does not exist. Creating a new one.');
        await createUserDocument();
        return getMyData(); // Recursively call to get the newly created data
      }
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<Map<String, dynamic>>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          //final userData = snapshot.data ?? {};

          return Column(
            children: [
              /*
              // Display user data here if needed
              Padding(
                padding: const EdgeInsets.all(layout.padding),
                child: Text('Welcome, ${userData['name'] ?? 'User'}',
                    style: txt.body2Dark),
              ),
              */

              Expanded(
                flex: 0,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        showJobCategoriesDialog();
                      },
                      icon: const Icon(
                        Icons.filter_list,
                        color: clr.primary,
                        size: layout.iconMedium,
                      ),
                    ),
                    Text(
                      "Filter Jobs based on your choice",
                      style: txt.body2Dark.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                child: jobCategoryFilter != null
                    ? Text(
                        jobCategoryFilter.toString(),
                        style: txt.body2Dark,
                      )
                    : const Text(
                        "Recent Jobs",
                        style: txt.body2Dark,
                      ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('jobPosted')
                      .where('category', isEqualTo: jobCategoryFilter)
                      .where('recruiting', isEqualTo: true)
                      .orderBy('created', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot jobSnapshot) {
                    if (jobSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (jobSnapshot.connectionState ==
                        ConnectionState.active) {
                      if (jobSnapshot.data?.docs.isNotEmpty == true) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 0,
                            bottom: layout.padding,
                            left: layout.padding,
                            right: layout.padding,
                          ),
                          child: ListView.builder(
                            itemCount: jobSnapshot.data?.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return JobTile(
                                jobID: jobSnapshot.data.docs[index]['job_id'],
                                jobTitle: jobSnapshot.data.docs[index]['title'],
                                jobDesc: jobSnapshot.data.docs[index]['desc'],
                                uploadedBy: jobSnapshot.data.docs[index]['id'],
                                contactName: jobSnapshot.data.docs[index]
                                    ['name'],
                                contactImage: jobSnapshot.data.docs[index]
                                    ['user_image'],
                                contactEmail: jobSnapshot.data.docs[index]
                                    ['email'],
                                jobLocation: jobSnapshot.data.docs[index]
                                    ['address'],
                                recruiting: jobSnapshot.data.docs[index]
                                    ['recruiting'],
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
          );
        },
      ),
    );
  }

  void showJobCategoriesDialog() {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: Padding(
            padding: const EdgeInsets.only(
              top: layout.padding,
              bottom: layout.padding,
            ),
            child: Text(
              'Job Categories',
              textAlign: TextAlign.center,
              style: txt.titleLight.copyWith(color: clr.passiveLight),
            ),
          ),
          content: SizedBox(
            width: size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: jobCategories.length,
              itemBuilder: ((context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      jobCategoryFilter = jobCategories[index];
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: index != jobCategories.length - 1
                          ? layout.padding
                          : 0,
                    ),
                    child: Row(children: [
                      Icon(
                        Icons.business,
                        color: clr.passiveLight,
                        size: 25.0,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: layout.padding * 1.25,
                          ),
                          child: Text(
                            jobCategories[index],
                            style: txt.body2Light
                                .copyWith(color: clr.passiveLight),
                          ),
                        ),
                      ),
                    ]),
                  ),
                );
              }),
            ),
          ),
          actions: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              InkWell(
                onTap: () {
                  setState(() {
                    jobCategoryFilter = null;
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: layout.padding,
                    bottom: layout.padding * 2,
                  ),
                  child: Row(children: [
                    Icon(
                      Icons.clear_all,
                      color: clr.passiveLight,
                      size: layout.iconSmall,
                    ),
                    const Text(
                      ' Clear Filter',
                      style: txt.body1Light,
                    ),
                  ]),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                InkWell(
                  onTap: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: layout.padding,
                      bottom: layout.padding * 2,
                    ),
                    child: Row(children: [
                      Icon(
                        Icons.close,
                        color: clr.passiveLight,
                        size: layout.iconSmall,
                      ),
                      const Text(
                        ' Close',
                        style: txt.button,
                      ),
                    ]),
                  ),
                ),
              ]),
            ]),
          ],
        );
      },
    );
  }

  Future<void> createUserDocument() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName ?? 'New User',
          'email': user.email ?? '',
          'user_image': user.photoURL ?? '',
          'address': '',
          'created': FieldValue.serverTimestamp(),
        });
        print('User document created successfully');
      } else {
        print('No user is currently signed in');
      }
    } catch (e) {
      print('Error creating user document: $e');
    }
  }
}
