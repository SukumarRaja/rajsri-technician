import 'package:flutter/material.dart';
import '../widgets/job_card.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Jobs'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            tabs: [
              Tab(text: 'Today'),
              Tab(text: 'Upcoming'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _JobsList(type: 'today'),
            _JobsList(type: 'upcoming'),
          ],
        ),
      ),
    );
  }
}

class _JobsList extends StatelessWidget {
  final String type;
  
  const _JobsList({required this.type});

  @override
  Widget build(BuildContext context) {
    final bool isToday = type == 'today';
    
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: isToday ? 3 : 2,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (isToday) {
          return JobCard(
            jobId: '#JOB-104${index + 2}',
            title: index == 0 ? 'AC Maintenance & Repair' : 'Plumbing Inspection',
            customerName: 'Customer ${index + 1}',
            address: '${100 + index} Main Street, NY',
            time: '${10 + index}:00 AM',
            status: index == 0 ? 'In Progress' : 'Assigned',
          );
        } else {
          return JobCard(
            jobId: '#JOB-105${index + 2}',
            title: 'Washing Machine Repair',
            customerName: 'Upcoming Client ${index + 1}',
            address: '${400 + index} Elm Street, NY',
            time: 'Tomm, 02:30 PM',
            status: 'Pending',
          );
        }
      },
    );
  }
}
