import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_quest/screens/job/details.dart';

class Job extends StatelessWidget {
  final String jobID;
  final String jobTitle;
  final String uploadedBy;
  final String contactName;
  final String contactImage;
  final DateTime date;
  final String type;

  const Job({
    Key? key,
    required this.jobTitle,
    required this.date,
    required this.type,
    required this.jobID,
    required this.uploadedBy,
    required this.contactName,
    required this.contactImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => type == 'taken'
          ? details(
              jobId: jobID,
              isPosted: false,
            )
          : details(
              jobId: jobID,
              isPosted: true,
            ),
          ),
        );
      },
      child: Column(
        children: [
          const SizedBox(height: 6),
          Card(
            color: Colors.grey[200],
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jobTitle,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Company/Name: $contactName',
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.yMMMd().add_jm().format(date),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_quest/screens/job/applicants.dart';
import 'package:job_quest/screens/job/details.dart';

class Job extends StatelessWidget {
  final String jobID;
  final String jobTitle;
  final String uploadedBy;
  final String contactName;
  final String contactImage;
  final DateTime date;
  final String type;

  const Job({
    Key? key,
    required this.jobTitle,
    required this.date,
    required this.type,
    required this.jobID,
    required this.uploadedBy,
    required this.contactName,
    required this.contactImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => (type == 'taken' || false)
                ? details()
                : ApplicantsApp(
                    job_id: jobID,
                  ),
          ),
        );
      },
      child: Column(
        children: [
          const SizedBox(height: 6),
          Card(
            color: Colors.grey[200],
            elevation: 2,
            child: ListTile(
              title: Text(
                jobTitle,
                style: const TextStyle(fontSize: 20),
              ),
              subtitle: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('company/Name: $contactName'),
                      Text(DateFormat.yMMMd().add_jm().format(date)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
*/