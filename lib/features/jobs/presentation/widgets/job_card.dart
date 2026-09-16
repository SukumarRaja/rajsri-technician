import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/job_action_bloc.dart';
import '../bloc/job_action_event.dart';

class JobCard extends StatelessWidget {
  final int jobDbId;
  final String jobId;
  final String title;
  final String customerName;
  final String address;
  final String time;
  final String status;
  final String statusLabel;
  final String? price;
  final dynamic isDashboard;
  final String? date;

  const JobCard({
    super.key,
    required this.jobDbId,
    required this.jobId,
    required this.title,
    required this.customerName,
    required this.address,
    required this.time,
    required this.status,
    required this.statusLabel,
    this.price,
    this.isDashboard,
    this.date,
  });

  bool _canStartJob(String timeStr) {
    try {
      final parts = timeStr.trim().split(' ');
      if (parts.isEmpty) return true;
      final timeParts = parts[0].split(':');
      if (timeParts.length != 2) return true;

      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      if (parts.length > 1) {
        final period = parts[1].toUpperCase();
        if (period == 'PM' && hour < 12) hour += 12;
        if (period == 'AM' && hour == 12) hour = 0;
      }

      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      final difference = scheduledTime.difference(now).inMinutes;
      return difference <= 30;
    } catch (e) {
      return true; // Fallback if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Future<void> showCancelDialog() async {
      final reasonController = TextEditingController();
      final formKey = GlobalKey<FormState>();

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Cancel Job'),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason for cancellation',
                  hintText: 'Customer unavailable, parts missing...',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a reason';
                  }
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back'),
              ),
              FilledButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.of(context).pop();
                    context.read<JobActionBloc>().add(
                      CancelJobEvent(jobDbId, reasonController.text.trim()),
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                ),
                child: const Text('Cancel Job'),
              ),
            ],
          );
        },
      );
    }

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
              color: colorScheme.primary.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  jobId,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      date ??
                          (isDashboard == true
                              ? '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}'
                              : ''),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      customerName,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    // Coordinates can be dynamic later, using a dummy destination for demonstration
                    // final Uri googleMapsUrl = Uri.parse(
                    //   'https://www.google.com/maps/dir/?api=1&destination=11.0168,76.9558',
                    // );
                    // if (await canLaunchUrl(googleMapsUrl)) {
                    //   await launchUrl(
                    //     googleMapsUrl,
                    //     mode: LaunchMode.externalApplication,
                    //   );
                    // } else {
                    //   if (context.mounted) {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //         content: Text('Could not launch maps'),
                    //       ),
                    //     );
                    //   }
                    // }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            address,
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.8),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (price != null && price!.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Icon(
                        Icons.payments_outlined,
                        size: 16,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '₹$price',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ],
                ),
                status == 'cancelled'
                    ? SizedBox.shrink()
                    : const SizedBox(height: 16),
                status == 'cancelled' || status == 'completed'
                    ? SizedBox.shrink()
                    : Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: showCancelDialog,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: colorScheme.error,
                                side: BorderSide(color: colorScheme.error),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (status == 'in_progress') {
                                  context.push(
                                    '/service-update',
                                    extra: {
                                      'jobDbId': jobDbId,
                                      'jobId': jobId,
                                      'customerName': customerName,
                                      'serviceName': title,
                                      'statusLabel': statusLabel,
                                      'price': price ?? 'N/A',
                                    },
                                  );
                                  return;
                                }

                                //  if (!_canStartJob(time)) {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     const SnackBar(
                                //       content: Text('You can only start a job 30 minutes before its scheduled time.'),
                                //       backgroundColor: Colors.orange,
                                //     ),
                                //   );
                                //   return;
                                // }

                                context.read<JobActionBloc>().add(
                                  StartJobEvent(jobDbId),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    (status == 'in_progress' ||
                                        _canStartJob(time))
                                    ? colorScheme.primary
                                    : Colors.grey.shade400,
                                foregroundColor:
                                    (status == 'in_progress' ||
                                        _canStartJob(time))
                                    ? colorScheme.onPrimary
                                    : Colors.black54,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                status == 'in_progress' ? 'Details' : 'Start',
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
