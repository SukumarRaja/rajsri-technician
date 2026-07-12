import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../jobs/presentation/bloc/job_action_bloc.dart';
import '../../../jobs/presentation/bloc/job_action_state.dart';
import '../../../jobs/presentation/widgets/job_card.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../../../tracking/presentation/bloc/tracking_bloc.dart';
import '../../../tracking/presentation/bloc/tracking_event.dart';
import '../../../tracking/presentation/bloc/tracking_state.dart';
import '../../data/models/dashboard_response.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(FetchDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Dashboard'), actions: []),
      body: BlocListener<JobActionBloc, JobActionState>(
        listener: (context, state) {
          if (state is JobActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            context.read<DashboardBloc>().add(FetchDashboardEvent());
          } else if (state is JobActionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, dashboardState) {
            if (dashboardState is DashboardLoading ||
                dashboardState is DashboardInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (dashboardState is DashboardError) {
              return Center(child: Text(dashboardState.message));
            } else if (dashboardState is DashboardLoaded) {
              final data = dashboardState.data;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, profileState) {
                              String name = 'Technician';
                              if (profileState is ProfileLoaded) {
                                name = profileState.user.name;
                              }
                              return Text(
                                'Hi, $name!',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              );
                            },
                          ),
                        ),
                        BlocBuilder<TrackingBloc, TrackingState>(
                          builder: (context, state) {
                            final isActive = state is TrackingActive;
                            return Switch(
                              value: isActive,
                              activeColor: theme.colorScheme.onPrimary,
                              activeTrackColor: theme.colorScheme.primary,
                              onChanged: (val) {
                                if (val) {
                                  context.read<TrackingBloc>().add(
                                    StartTrackingEvent(),
                                  );
                                } else {
                                  context.read<TrackingBloc>().add(
                                    StopTrackingEvent(),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Here is your overview for today.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildQuickStats(context, data.stats),
                    const SizedBox(height: 32),
                    Text(
                      'Today\'s Summary',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTodaySummaryCard(context, data.stats),
                    const SizedBox(height: 32),
                    Text(
                      'Upcoming Today Jobs',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildUpcomingJobsList(context, data.upcomingJobs),
                  ],
                ),
              );
            }
            return const Center(child: Text('Unknown State'));
          },
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, DashboardStats stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Pending',
                count: '${stats.pending}',
                icon: Icons.pending_actions,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'In Progress',
                count: '${stats.inProgress}',
                icon: Icons.autorenew,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Completed',
                count: '${stats.completed}',
                icon: Icons.check_circle_outline,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'Cancelled',
                count: '${stats.cancelled}',
                icon: Icons.cancel_outlined,
                color: Colors.red.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTodaySummaryCard(BuildContext context, DashboardStats stats) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Jobs Today',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${stats.totalJobs}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.work_history,
              size: 40,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingJobsList(BuildContext context, List<DashboardJob> jobs) {
    if (jobs.isEmpty) {
      return const Center(child: Text("No upcoming jobs."));
    }
    return Column(
      children: jobs.map((job) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: JobCard(
            jobDbId: job.id,
            jobId: job.bookingNumber,
            title: job.serviceName,
            customerName: job.customerName,
            address: job.address ?? 'No address provided',
            time: job.time,
            statusLabel: job.statusLabel,
            status: job.status,
            isDashboard: true,
          ),
        );
      }).toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
