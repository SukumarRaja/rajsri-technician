import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection_container.dart';
import '../bloc/jobs_bloc.dart';
import '../bloc/jobs_event.dart';
import '../bloc/jobs_state.dart';
import '../widgets/job_card.dart';
import '../../data/models/job_model.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatus;
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(BuildContext context, String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<JobsBloc>().add(
          FetchJobsEvent(
            search: query,
            status: _selectedStatus,
            isRefresh: true,
          ),
        );
      }
    });
  }

  void _onSearch(BuildContext context, String value) {
    context.read<JobsBloc>().add(
      FetchJobsEvent(search: value, status: _selectedStatus, isRefresh: true),
    );
  }

  void _onFilter(BuildContext context, String? status) {
    setState(() {
      _selectedStatus = status;
    });
    context.read<JobsBloc>().add(
      FetchJobsEvent(
        search: _searchController.text,
        status: status,
        isRefresh: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<JobsBloc>()..add(const FetchJobsEvent()),
      child: DefaultTabController(
        length: 2,
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('My Jobs'),
                bottom: const TabBar(
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  labelColor: Colors.white,
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: [
                    Tab(text: 'Today'),
                    Tab(text: 'Upcoming'),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _searchController,
                          builder: (context, value, child) {
                            return TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search jobs...',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: value.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          _searchController.clear();
                                          _onSearchChanged(context, '');
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                ),
                              ),
                              onChanged: (val) =>
                                  _onSearchChanged(context, val),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip(context, 'All', null),
                              const SizedBox(width: 8),
                              _buildFilterChip(context, 'Pending', 'pending'),
                              const SizedBox(width: 8),
                              _buildFilterChip(
                                context,
                                'In Progress',
                                'in_progress',
                              ),
                              const SizedBox(width: 8),
                              _buildFilterChip(
                                context,
                                'Completed',
                                'completed',
                              ),
                              const SizedBox(width: 8),
                              _buildFilterChip(
                                context,
                                'Cancelled',
                                'cancelled',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<JobsBloc, JobsState>(
                      builder: (context, state) {
                        if (state is JobsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is JobsError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.message,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<JobsBloc>().add(
                                      FetchJobsEvent(
                                        search: _searchController.text,
                                        status: _selectedStatus,
                                        isRefresh: true,
                                      ),
                                    );
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        } else if (state is JobsLoaded) {
                          return TabBarView(
                            children: [
                              _JobsList(
                                type: 'today',
                                jobs: state.jobsData.today.data,
                                hasReachedMax: state.hasReachedMaxToday,
                                currentPage:
                                    state.jobsData.today.pagination.currentPage,
                                search: state.search,
                                status: state.status,
                                isFetchingMore: state.isFetchingMore,
                              ),
                              _JobsList(
                                type: 'upcoming',
                                jobs: state.jobsData.upcoming.data,
                                hasReachedMax: state.hasReachedMaxUpcoming,
                                currentPage: state
                                    .jobsData
                                    .upcoming
                                    .pagination
                                    .currentPage,
                                search: state.search,
                                status: state.status,
                                isFetchingMore: state.isFetchingMore,
                              ),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String? value) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedStatus == value,
      onSelected: (selected) {
        if (selected) {
          _onFilter(context, value);
        } else if (value != null) {
          _onFilter(context, null);
        }
      },
    );
  }
}

class _JobsList extends StatefulWidget {
  final String type;
  final List<JobModel> jobs;
  final bool hasReachedMax;
  final int currentPage;
  final String? search;
  final String? status;
  final bool isFetchingMore;

  const _JobsList({
    required this.type,
    required this.jobs,
    required this.hasReachedMax,
    required this.currentPage,
    this.search,
    this.status,
    required this.isFetchingMore,
  });

  @override
  State<_JobsList> createState() => _JobsListState();
}

class _JobsListState extends State<_JobsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!widget.hasReachedMax && !widget.isFetchingMore) {
        context.read<JobsBloc>().add(
          FetchJobsEvent(
            search: widget.search,
            status: widget.status,
            todayPage: widget.type == 'today' ? widget.currentPage + 1 : null,
            upcomingPage: widget.type == 'upcoming'
                ? widget.currentPage + 1
                : null,
          ),
        );
      }
    }
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return 'Unknown Date';
    try {
      final date = DateTime.parse(isoDate);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return 'Unknown Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onRefresh() async {
      context.read<JobsBloc>().add(
        FetchJobsEvent(
          search: widget.search,
          status: widget.status,
          isRefresh: true,
        ),
      );
    }

    if (widget.jobs.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: Text(
                  'No ${widget.type == 'today' ? 'jobs for today' : 'upcoming jobs'}.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount:
          widget.jobs.length +
          (widget.isFetchingMore && !widget.hasReachedMax ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= widget.jobs.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final job = widget.jobs[index];
        final currentJobDate = _formatDate(job.scheduledAt);

        bool showHeader = false;
        if (widget.type == 'upcoming') {
          if (index == 0) {
            showHeader = true;
          } else {
            final prevJob = widget.jobs[index - 1];
            final prevJobDate = _formatDate(prevJob.scheduledAt);
            if (currentJobDate != prevJobDate) {
              showHeader = true;
            }
          }
        }

        final jobCard = JobCard(
          jobDbId: job.id,
          jobId: job.bookingNumber ?? '#JOB-${job.id}',
          title: job.service?.name ?? 'Unknown Service',
          customerName: job.customer?.name ?? 'Unknown Customer',
          address: job.address ?? 'Unknown Address',
          time: job.time ?? job.scheduledAt ?? '',
          status: job.status ?? 'pending',
          statusLabel: job.statusLabel ?? 'Pending',
          price: job.price?.toString(),
          isDashboard: false,
        );

        if (showHeader) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
                child: Text(
                  currentJobDate,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              jobCard,
              if (index < widget.jobs.length - 1) const SizedBox(height: 16),
            ],
          );
        }

        return Column(
          children: [
            jobCard,
            if (index < widget.jobs.length - 1) const SizedBox(height: 16),
          ],
        );
      },
    ),
    );
  }
}
