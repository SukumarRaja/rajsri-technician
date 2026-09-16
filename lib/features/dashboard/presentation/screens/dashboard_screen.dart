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
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardBloc>().add(FetchDashboardEvent());
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12.0),
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
                      const SizedBox(height: 4),
                      Text(
                        'Here is your overview for today.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSummaryCardsRow(context, data.stats),
                      const SizedBox(height: 24),
                      Text(
                        'Job Statistics',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildJobQuickStats(context, data.stats),
                      const SizedBox(height: 24),
                      Text(
                        'AMC Statistics',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildAmcQuickStats(context, data.stats),
                      const SizedBox(height: 28),
                      Text(
                        'Upcoming Jobs',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildUpcomingJobsList(context, data.upcomingJobs),
                      const SizedBox(height: 28),
                      Text(
                        'Upcoming AMC Visits',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildUpcomingAmcVisitsList(context, data.upcomingAmcVisits),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: Text('Unknown State'));
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCardsRow(BuildContext context, DashboardStats stats) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Total Jobs',
            count: '${stats.totalJobs}',
            icon: Icons.work_history_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: 'Total AMC',
            count: '${stats.totalAmc}',
            icon: Icons.verified_user_outlined,
            color: Colors.teal.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildJobQuickStats(BuildContext context, DashboardStats stats) {
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

  Widget _buildAmcQuickStats(BuildContext context, DashboardStats stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'AMC Assigned',
                count: '${stats.amcAssigned}',
                icon: Icons.assignment_ind_outlined,
                color: Colors.indigo.shade600,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'AMC Pending',
                count: '${stats.amcPending}',
                icon: Icons.schedule_outlined,
                color: Colors.amber.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'AMC Completed',
                count: '${stats.amcCompleted}',
                icon: Icons.task_alt,
                color: Colors.teal.shade700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'AMC Missed',
                count: '${stats.amcMissed}',
                icon: Icons.error_outline,
                color: Colors.redAccent.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUpcomingJobsList(BuildContext context, List<DashboardJob> jobs) {
    if (jobs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: Text("No upcoming jobs.")),
      );
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
            date: job.scheduledDate,
            statusLabel: job.statusLabel,
            status: job.status,
            isDashboard: true,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUpcomingAmcVisitsList(
      BuildContext context, List<DashboardAmcVisit> amcVisits) {
    if (amcVisits.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: Text("No upcoming AMC visits.")),
      );
    }
    return Column(
      children: amcVisits.map((visit) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _AmcVisitCard(visit: visit),
        );
      }).toList(),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: color),
          ),
        ],
      ),
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
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
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

class _AmcVisitCard extends StatelessWidget {
  final DashboardAmcVisit visit;

  const _AmcVisitCard({required this.visit});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dateStr = visit.scheduledDate ?? '';
    final timeStr = visit.scheduledTime ?? '';
    final dateTimeText = [dateStr, timeStr].where((s) => s.isNotEmpty).join(' • ');

    return Container(
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
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield_outlined, size: 18, color: Colors.teal),
                    const SizedBox(width: 6),
                    Text(
                      '${visit.planName} Plan',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    visit.statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visit.companyName,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (dateTimeText.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.event,
                        size: 16,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateTimeText,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
                if (visit.address != null && visit.address!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          visit.address!,
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
