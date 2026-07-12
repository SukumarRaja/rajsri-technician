import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/injection_container.dart';
import '../../../jobs/data/models/job_model.dart';
import '../bloc/service_history_bloc.dart';
import '../bloc/service_history_event.dart';
import '../bloc/service_history_state.dart';

class ServiceHistoryScreen extends StatelessWidget {
  const ServiceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ServiceHistoryBloc>()..add(const FetchServiceHistoryEvent()),
      child: const _ServiceHistoryView(),
    );
  }
}

class _ServiceHistoryView extends StatefulWidget {
  const _ServiceHistoryView({super.key});

  @override
  State<_ServiceHistoryView> createState() => _ServiceHistoryViewState();
}

class _ServiceHistoryViewState extends State<_ServiceHistoryView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedStatus = 'All';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<ServiceHistoryBloc>().state;
      if (state is ServiceHistoryLoaded &&
          !state.hasReachedMax &&
          !state.isFetchingMore) {
        context.read<ServiceHistoryBloc>().add(
          FetchServiceHistoryEvent(
            search: _searchController.text,
            status: _selectedStatus == 'All'
                ? null
                : _selectedStatus.toLowerCase(),
            page: state.pagination.currentPage + 1,
          ),
        );
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<ServiceHistoryBloc>().add(
          FetchServiceHistoryEvent(
            search: query,
            status: _selectedStatus == 'All'
                ? null
                : _selectedStatus.toLowerCase(),
            isRefresh: true,
          ),
        );
      }
    });
  }

  void _onFilter(String status) {
    setState(() {
      _selectedStatus = status;
    });
    context.read<ServiceHistoryBloc>().add(
      FetchServiceHistoryEvent(
        search: _searchController.text,
        status: status == 'All' ? null : status.toLowerCase(),
        isRefresh: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Service History')),
        body: Column(
          children: [
            // Search and Filters
            Container(
              padding: const EdgeInsets.all(16),
              color: colorScheme.surface,
              child: Column(
                children: [
                  Builder(
                    builder: (context) {
                      return ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _searchController,
                        builder: (context, value, child) {
                          return TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search by Job ID or Customer...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: value.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        _onSearchChanged('');
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
                            onChanged: _onSearchChanged,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Builder(
                    builder: (context) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChip(
                              label: 'All',
                              isSelected: _selectedStatus == 'All',
                              onTap: () => _onFilter('All'),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Completed',
                              isSelected: _selectedStatus == 'Completed',
                              onTap: () => _onFilter('Completed'),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Cancelled',
                              isSelected: _selectedStatus == 'Cancelled',
                              onTap: () => _onFilter('Cancelled'),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Pending',
                              isSelected: _selectedStatus == 'Pending',
                              onTap: () => _onFilter('Pending'),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'In_Progress',
                              isSelected: _selectedStatus == 'In_Progress',
                              onTap: () => _onFilter('In_Progress'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // List of History
            Expanded(
              child: BlocBuilder<ServiceHistoryBloc, ServiceHistoryState>(
                builder: (context, state) {
                  if (state is ServiceHistoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ServiceHistoryError) {
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
                              context.read<ServiceHistoryBloc>().add(
                                FetchServiceHistoryEvent(
                                  search: _searchController.text,
                                  status: _selectedStatus == 'All'
                                      ? null
                                      : _selectedStatus.toLowerCase(),
                                  isRefresh: true,
                                ),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is ServiceHistoryLoaded) {
                    if (state.jobs.isEmpty) {
                      return Center(
                        child: Text(
                          'No service history found.',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          state.jobs.length +
                          (state.isFetchingMore && !state.hasReachedMax
                              ? 1
                              : 0),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        if (index >= state.jobs.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return _HistoryCard(job: state.jobs[index]);
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ChoiceChip(
      label: Text(label.replaceAll('_', ' ')),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) onTap();
      },
      selectedColor: colorScheme.primary,
      backgroundColor: colorScheme.surface,
      labelStyle: TextStyle(
        color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final JobModel job;

  const _HistoryCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCompleted = job.status == 'completed';
    final isCancelled = job.status == 'cancelled';

    Color statusColor;
    if (isCompleted) {
      statusColor = Colors.green;
    } else if (isCancelled) {
      statusColor = Colors.red;
    } else {
      statusColor = colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                job.bookingNumber ?? '#JOB-${job.id}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  job.statusLabel ?? job.status ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            job.service?.name ?? 'Unknown Service',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 16,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(width: 8),
              Text(
                job.customer?.name ?? 'Unknown Customer',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(width: 8),
              Text(
                job.date ?? job.scheduledAt ?? '',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
