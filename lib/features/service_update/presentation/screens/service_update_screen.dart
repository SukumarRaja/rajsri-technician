import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../jobs/data/models/complete_job_request.dart';
import '../../../jobs/presentation/bloc/job_action_bloc.dart';
import '../../../jobs/presentation/bloc/job_action_event.dart';
import '../../../jobs/presentation/bloc/job_action_state.dart';
import '../../../jobs/presentation/bloc/job_detail_bloc.dart';
import '../../../jobs/presentation/bloc/job_detail_state.dart';

class ServiceUpdateScreen extends StatefulWidget {
  final int jobDbId;
  final String jobId;
  final String customerName;
  final String serviceName;
  final String statusLabel;
  final String price;

  const ServiceUpdateScreen({
    super.key,
    required this.jobDbId,
    required this.jobId,
    required this.customerName,
    required this.serviceName,
    required this.statusLabel,
    required this.price,
  });

  @override
  State<ServiceUpdateScreen> createState() => _ServiceUpdateScreenState();
}

class _ServiceUpdateScreenState extends State<ServiceUpdateScreen> {
  final TextEditingController _afterNotesController = TextEditingController();
  final TextEditingController _paymentAmountController =
      TextEditingController();

  bool _paymentReceived = false;
  String _paymentMethod =
      'cash'; // Default: 'cash', options: 'cash', 'upi', 'card', 'online'

  final List<File> _images = [];
  final List<PartUsed> _partsUsed = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    if (_images.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only upload a maximum of 6 images.'),
        ),
      );
      return;
    }

    final List<XFile> pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final tempDir = await getTemporaryDirectory();
      int addedCount = 0;

      for (var file in pickedFiles) {
        if (_images.length + addedCount >= 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Maximum 6 images reached. Some images were ignored.',
              ),
            ),
          );
          break;
        }

        File imageFile = File(file.path);
        int fileSize = imageFile.lengthSync();

        // 3 MB = 3 * 1024 * 1024 bytes
        if (fileSize > 3 * 1024 * 1024) {
          final targetPath =
              '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
          var result = await FlutterImageCompress.compressAndGetFile(
            imageFile.absolute.path,
            targetPath,
            quality: 70,
          );
          if (result != null) {
            imageFile = File(result.path);
          }
        }

        setState(() {
          _images.add(imageFile);
        });
        addedCount++;
      }

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
      }
    }
  }

  void _showAddPartDialog() {
    final productIdController = TextEditingController();
    final nameController = TextEditingController();
    final qtyController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        String? errorMessage;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Part Used'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    TextField(
                      controller: productIdController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Product ID (Required)',
                        hintText: 'e.g. 3',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      maxLength: 150,
                      decoration: const InputDecoration(
                        labelText: 'Part Name (Optional)',
                        hintText: 'e.g. AC Fan Motor',
                        counterText: "",
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: qtyController,
                            maxLength: 3,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                              LengthLimitingTextInputFormatter(3),
                            ],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Quantity',
                              hintText: '1',
                              counterText: "",
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: priceController,
                            maxLength: 7,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Price (₹)',
                              hintText: '250.00',
                              counterText: "",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final productIdText = productIdController.text.trim();
                    final name = nameController.text.trim();
                    final qtyText = qtyController.text.trim();
                    final priceText = priceController.text.trim();

                    final productId = int.tryParse(productIdText);
                    if (productId == null) {
                      setDialogState(() {
                        errorMessage = 'Please enter a valid Product ID.';
                      });
                      return;
                    }

                    if (qtyText.isEmpty || priceText.isEmpty) {
                      setDialogState(() {
                        errorMessage = 'Please enter Quantity and Price.';
                      });
                      return;
                    }

                    final qty = int.tryParse(qtyText) ?? 1;
                    final price = double.tryParse(priceText) ?? 0.0;

                    setState(() {
                      _partsUsed.add(
                        PartUsed(
                          productId: productId,
                          name: name.isNotEmpty ? name : 'Product #$productId',
                          quantity: qty,
                          price: price,
                        ),
                      );
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Add Part'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _submitCompletion() {
    if (_paymentReceived) {
      final amountText = _paymentAmountController.text.trim();
      if (amountText.isEmpty || (double.tryParse(amountText) ?? -1) < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid payment amount.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    final List<String> imageUrls = _images.map((e) => e.path).toList();

    context.read<JobActionBloc>().add(
      CompleteJobEvent(
        widget.jobDbId,
        afterNotes: _afterNotesController.text.trim(),
        notes: _afterNotesController.text.trim(),
        images: imageUrls,
        partsUsed: _partsUsed,
        paymentReceived: _paymentReceived,
        paymentAmount: _paymentReceived
            ? double.tryParse(_paymentAmountController.text.trim())
            : null,
        paymentMethod: _paymentReceived ? _paymentMethod : null,
      ),
    );
  }

  @override
  void dispose() {
    _afterNotesController.dispose();
    _paymentAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<JobActionBloc, JobActionState>(
      listener: (context, state) {
        if (state is JobActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        } else if (state is JobActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: GestureDetector(
            onTap: () => context.pop(),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: theme.cardColor, size: 20),
                const Text('Complete Job'),
              ],
            ),
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Header Card
              Text(
                'Job Details',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<JobDetailBloc, JobDetailState>(
                builder: (context, state) {
                  String jobId = widget.jobId;
                  String customerName = widget.customerName;
                  String serviceName = widget.serviceName;
                  String statusLabel = widget.statusLabel;
                  String price = widget.price;

                  if (state is JobDetailLoaded) {
                    final job = state.jobDetail;
                    jobId = job.bookingNumber ?? jobId;
                    customerName = job.customer?.name ?? customerName;
                    serviceName = job.service?.name ?? serviceName;
                    statusLabel = job.statusLabel ?? statusLabel;
                    price = job.price?.toString() ?? price;
                  }

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailRow(label: 'Booking No.', value: jobId),
                        const Divider(height: 24),
                        _DetailRow(label: 'Customer', value: customerName),
                        const Divider(height: 24),
                        _DetailRow(label: 'Service', value: serviceName),
                        const Divider(height: 24),
                        _DetailRow(label: 'Status', value: statusLabel),
                        const Divider(height: 24),
                        _DetailRow(label: 'Price', value: "₹ $price"),
                        if (state is JobDetailLoading) ...[
                          const Divider(height: 16),
                          const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ] else if (state is JobDetailError) ...[
                          const Divider(height: 16),
                          Text(
                            state.message,
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // After Notes Section
              Text(
                'After Notes / Work Done',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _afterNotesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'Describe work completed, tests done, or observations...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Parts Used Section
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Parts Used',
              //       style: theme.textTheme.titleMedium?.copyWith(
              //         fontWeight: FontWeight.bold,
              //         color: colorScheme.onSurface,
              //       ),
              //     ),
              //     TextButton.icon(
              //       onPressed: _showAddPartDialog,
              //       icon: const Icon(Icons.add),
              //       label: const Text('Add Part'),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 8),
              // if (_partsUsed.isEmpty)
              //   const Padding(
              //     padding: EdgeInsets.symmetric(vertical: 8.0),
              //     child: Text(
              //       'No spare parts added for this job.',
              //       style: TextStyle(color: Colors.grey),
              //     ),
              //   )
              // else
              //   ListView.builder(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemCount: _partsUsed.length,
              //     itemBuilder: (context, index) {
              //       final part = _partsUsed[index];
              //       return Card(
              //         margin: const EdgeInsets.only(bottom: 8),
              //         child: ListTile(
              //           title: Text(part.name ?? 'Product #${part.productId}'),
              //           subtitle: Text(
              //             'Product ID: ${part.productId ?? 'N/A'} | Qty: ${part.quantity} | Unit Price: ₹${part.price}',
              //           ),
              //           trailing: IconButton(
              //             icon: const Icon(Icons.delete, color: Colors.red),
              //             onPressed: () {
              //               setState(() {
              //                 _partsUsed.removeAt(index);
              //               });
              //             },
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // const SizedBox(height: 32),

              // Payment Details Section
              Text(
                'Payment Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Material(
                color: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text(
                        'Payment Received',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        'Check if payment was collected from customer',
                      ),
                      value: _paymentReceived,
                      onChanged: (bool val) {
                        setState(() {
                          _paymentReceived = val;
                        });
                      },
                    ),
                    if (_paymentReceived) ...[
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _paymentAmountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}'),
                                ),
                              ],
                              decoration: InputDecoration(
                                labelText: 'Payment Amount (₹)',
                                hintText: 'e.g. 750.00',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Payment Method',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: ['cash', 'upi', 'card', 'online'].map((
                                method,
                              ) {
                                final isSelected = _paymentMethod == method;
                                return ChoiceChip(
                                  label: Text(method.toUpperCase()),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _paymentMethod = method;
                                      });
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Upload Images Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upload Completion Photos',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '${_images.length}/6 selected',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_images.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(_images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 12,
                            child: IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _images.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              if (_images.isNotEmpty) const SizedBox(height: 16),
              if (_images.length < 6)
                InkWell(
                  onTap: _pickImages,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 48,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to add photos',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 48),

              // Submit Button
              BlocBuilder<JobActionBloc, JobActionState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is JobActionLoading
                          ? null
                          : _submitCompletion,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state is JobActionLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Mark as Completed',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
