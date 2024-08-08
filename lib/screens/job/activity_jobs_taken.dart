import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_quest/screens/job/jobs_card.dart';
import 'package:job_quest/utils/layout.dart';
import 'package:job_quest/utils/txt.dart';

class Applied extends StatefulWidget {
  const Applied({Key? key}) : super(key: key);

  @override
  State<Applied> createState() => _AppliedState();
}

class _AppliedState extends State<Applied> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    final uid = user!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Center(child: Text('No data available', style: txt.error));
        }

        List<String> appliedJobs =
            List<String>.from(userSnapshot.data!.get('appliedJobs') ?? []);

        /////////////
        if (appliedJobs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(layout.padding * 6),
            child: Center(
              child: Image.asset('assets/images/empty.png'),
            ),
          );
        }
        ///////////////

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('jobPosted')
              .where(FieldPath.documentId, whereIn: appliedJobs)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}', style: txt.error));
            }

            if (snapshot.data!.docs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(layout.padding * 6),
                child: Center(
                  child: Image.asset('assets/images/empty.png'),
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
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var jobData = snapshot.data!.docs[index];
                  return Job(
                    jobID: jobData['job_id'],
                    contactName: jobData['name'],
                    contactImage: jobData['user_image'],
                    jobTitle: jobData['title'],
                    uploadedBy: jobData['id'],
                    date: jobData['created'].toDate(),
                    type: 'taken',
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_quest/screens/job/jobs_card.dart';
import 'package:job_quest/utils/layout.dart';
import 'package:job_quest/utils/txt.dart';

class Applied extends StatefulWidget {
  const Applied({super.key});

  @override
  State<Applied> createState() => _AppliedState();
}

class _AppliedState extends State<Applied> {
  final _auth = FirebaseAuth.instance;
  String? nameForApplied;
  String? userImageForApplied;
  String? addressForApplied;

  void getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      nameForApplied = userDoc.get('name');
      userImageForApplied = userDoc.get('user_image');
      addressForApplied = userDoc.get('address');
    });
  }

  @override
  void initState() {
    super.initState();
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    final uid = user!.uid;
    return Container(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('jobApplications')
            .where('applicantId', isEqualTo: uid)
            .orderBy('appliedDate', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.docs.isNotEmpty == true) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  bottom: layout.padding,
                  left: layout.padding,
                  right: layout.padding,
                ),
                child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Job(
                        jobID: snapshot.data.docs[index]['jobId'],
                        contactName: snapshot.data.docs[index]['employerName'],
                        contactImage: snapshot.data.docs[index]['employerImage'],
                        jobTitle: snapshot.data.docs[index]['jobTitle'],
                        uploadedBy: snapshot.data.docs[index]['employerId'],
                        date: snapshot.data.docs[index]['appliedDate'].toDate(),
                        type: 'applied',
                      );
                    }),
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
    );
  }
}
*/


/*
import 'package:flutter/material.dart';

class taken extends StatefulWidget {
  const taken({super.key});

  @override
  State<taken> createState() => _takenState();
}

class _takenState extends State<taken> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*
        Job(
          position: 'Graphics Designer',
          companyName: 'RDX',
          date: DateTime(2013, 2, 1),
          type: 'taken',
        ),
        Job(
          position: 'Flutter Developer',
          companyName: 'ABC',
          date: DateTime(2013, 2, 1),
          type: 'taken',
        ),
        Job(
          position: 'Web Designer',
          companyName: 'AAU',
          date: DateTime(2013, 2, 1),
          type: 'taken',
        ),
        */
      ],
    );
  }
}
*/