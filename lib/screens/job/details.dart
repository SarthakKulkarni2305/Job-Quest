import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'applicants.dart';

class details extends StatefulWidget {
  final String jobId;
  final bool isPosted;

  const details({Key? key, required this.jobId, required this.isPosted}) : super(key: key);

  @override
  _detailsState createState() => _detailsState();
}

class _detailsState extends State<details> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPosted ? 'Posted Job details' : 'Applied Job details'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('jobPosted').doc(widget.jobId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Job not found'));
          }

          var jobData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobData['title'] ?? 'No Title',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildInfoRow('Company', jobData['name'] ?? 'Unknown'),
                _buildInfoRow('Location', jobData['address'] ?? 'Not specified'),
                _buildInfoRow('Email', jobData['email'] ?? 'Not provided'),
                _buildInfoRow('Posted Date', _formatDate(jobData['created'])),
                _buildInfoRow('Deadline', _formatDate(jobData['deadline_timestamp'])),
                _buildInfoRow('Applicants', '${jobData['applicants'] ?? 0}'),
                _buildInfoRow('Recruitment Status', jobData['recruiting'] ? 'Open' : 'Closed'),
                SizedBox(height: 16),
                Text(
                  'Job Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(jobData['desc'] ?? 'No description provided'),
                SizedBox(height: 16),
                if (widget.isPosted)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            child: Text('Edit Job'),
                            onPressed: () => _editJob(jobData),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          ),
                          ElevatedButton(
                            child: Text('Delete Job'),
                            onPressed: () => _deleteJob(),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        child: Text('View Applicants'),
                        onPressed: () => _viewApplicants(),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      ),
                    ],
                  ),
                if (!widget.isPosted)
                  Center(
                    child: ElevatedButton(
                      child: Text('Withdraw Application'),
                      onPressed: () => _withdrawApplication(),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Not set';
    if (timestamp is Timestamp) {
      return DateFormat('MMM d, yyyy').format(timestamp.toDate());
    }
    return 'Invalid date';
  }

  void _editJob(Map<String, dynamic> jobData) {
    // Implement job editing logic
    print('Editing job: ${jobData['title']}');
  }

  void _deleteJob() async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this job?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      try {
        await _firestore.collection('jobPosted').doc(widget.jobId).delete();
        Navigator.of(context).pop();
      } catch (e) {
        print('Error deleting job: $e');
        // Show error message to user
      }
    }
  }

  void _viewApplicants() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Applicants(jobId: widget.jobId),
      ),
    );
  }

  void _withdrawApplication() async {
    bool confirmWithdraw = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Withdrawal'),
        content: Text('Are you sure you want to withdraw your application?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Withdraw'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmWithdraw == true) {
      try {
        String userId = _auth.currentUser!.uid;
        await _firestore.collection('users').doc(userId).update({
          'appliedJobs': FieldValue.arrayRemove([widget.jobId])
        });
        Navigator.of(context).pop();
      } catch (e) {
        print('Error withdrawing application: $e');
        // Show error message to user
      }
    }
  }
}



/*
import 'package:flutter/material.dart';

class details extends StatelessWidget {
  const details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('details'),
      ),
      //body: Center(child: Text('details')),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class details extends StatefulWidget {
  final String jobId;
  final bool isPosted; // true if from Jobs Posted, false if from Jobs Applied

  const details({Key? key, required this.jobId, required this.isPosted})
      : super(key: key);

  @override
  _detailsState createState() => _detailsState();
}

class _detailsState extends State<details> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isPosted ? 'Posted Job details' : 'Applied Job details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('jobPosted').doc(widget.jobId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Job not found'));
          }

          var jobData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobData['title'] ?? 'No Title',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildInfoRow('Company', jobData['name'] ?? 'Unknown'),
                _buildInfoRow(
                    'Location', jobData['address'] ?? 'Not specified'),
                _buildInfoRow('Email', jobData['email'] ?? 'Not provided'),
                _buildInfoRow('Posted Date', _formatDate(jobData['created'])),
                _buildInfoRow(
                    'Deadline', _formatDate(jobData['deadline_timestamp'])),
                _buildInfoRow('Applicants', '${jobData['applicants'] ?? 0}'),
                _buildInfoRow('Recruitment Status',
                    jobData['recruiting'] ? 'Open' : 'Closed'),
                SizedBox(height: 16),
                Text(
                  'Job Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(jobData['desc'] ?? 'No description provided'),
                SizedBox(height: 16),
                if (widget.isPosted)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text('Edit Job'),
                        onPressed: () => _editJob(jobData),
                      ),
                      ElevatedButton(
                        child: Text('Delete Job'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () => _deleteJob(),
                      ),
                    ],
                  ),
                if (!widget.isPosted)
                  Center(
                    child: ElevatedButton(
                      child: Text('Withdraw Application'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange),
                      onPressed: () => _withdrawApplication(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Not set';
    if (timestamp is Timestamp) {
      return DateFormat('MMM d, yyyy').format(timestamp.toDate());
    }
    return 'Invalid date';
  }

  void _editJob(Map<String, dynamic> jobData) {
    // Implement job editing logic
    // This could navigate to an edit job screen
    print('Editing job: ${jobData['title']}');
  }

  void _deleteJob() async {
    // Show confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this job?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      try {
        await _firestore.collection('jobPosted').doc(widget.jobId).delete();
        Navigator.of(context).pop(); // Return to previous screen
      } catch (e) {
        print('Error deleting job: $e');
        // Show error message to user
      }
    }
  }

  void _withdrawApplication() async {
    // Show confirmation dialog
    bool confirmWithdraw = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Withdrawal'),
        content: Text('Are you sure you want to withdraw your application?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Withdraw'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmWithdraw == true) {
      try {
        String userId = _auth.currentUser!.uid;
        await _firestore.collection('users').doc(userId).update({
          'appliedJobs': FieldValue.arrayRemove([widget.jobId])
        });
        Navigator.of(context).pop(); // Return to previous screen
      } catch (e) {
        print('Error withdrawing application: $e');
        // Show error message to user
      }
    }
  }
}
*/