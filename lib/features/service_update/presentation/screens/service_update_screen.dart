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

class ServiceUpdateScreen extends StatefulWidget {
  final int jobDbId;
  final String jobId;
  final String customerName;
  final String serviceName;
  final String statusLabel;

  const ServiceUpdateScreen({
    super.key,
    required this.jobDbId,
    required this.jobId,
    required this.customerName,
    required this.serviceName,
    required this.statusLabel,
  });

  @override
  State<ServiceUpdateScreen> createState() => _ServiceUpdateScreenState();
}

class _ServiceUpdateScreenState extends State<ServiceUpdateScreen> {
  final TextEditingController _notesController = TextEditingController();
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
            quality: 70, // Adjust quality to reduce size
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

      Navigator.pop(context); // Close loading dialog
    }
  }

  void _showAddPartDialog() {
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
              title: const Text('Add Part'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  TextField(
                    controller: nameController,
                    maxLength: 150,
                    decoration: const InputDecoration(
                      labelText: 'Part Name',
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
                            counterText: "",
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: priceController,
                          maxLength: 5,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                            LengthLimitingTextInputFormatter(5),
                          ],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            counterText: "",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final qtyText = qtyController.text.trim();
                    final priceText = priceController.text.trim();

                    if (name.isEmpty || qtyText.isEmpty || priceText.isEmpty) {
                      setDialogState(() {
                        errorMessage = 'Please fill all fields.';
                      });
                      return;
                    }

                    final qty = int.tryParse(qtyText) ?? 1;
                    final price = double.tryParse(priceText) ?? 0.0;

                    setState(() {
                      _partsUsed.add(
                        PartUsed(name: name, quantity: qty, price: price),
                      );
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _submitCompletion() {
    final List<String> imageUrls = _images.map((e) => e.path).toList();

    context.read<JobActionBloc>().add(
      CompleteJobEvent(
        widget.jobDbId,
        notes: _notesController.text.trim(),
        images: imageUrls,
        partsUsed: _partsUsed,
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
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
          // Navigate back
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
                Text('Update Job'),
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
              Text(
                'Job Details',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(label: 'Job Id', value: widget.jobId),
                    const Divider(height: 24),
                    _DetailRow(label: 'Customer', value: widget.customerName),
                    const Divider(height: 24),
                    _DetailRow(label: 'Service', value: widget.serviceName),
                    const Divider(height: 24),
                    _DetailRow(label: 'Status', value: widget.statusLabel),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Notes Section
              Text(
                'Technician Notes',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter any observations or work done...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Parts Section
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
              // if (_partsUsed.isEmpty)
              //   const Padding(
              //     padding: EdgeInsets.symmetric(vertical: 8.0),
              //     child: Text(
              //       'No parts added.',
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
              //       return ListTile(
              //         contentPadding: EdgeInsets.zero,
              //         title: Text(part.name),
              //         subtitle: Text(
              //           'Qty: ${part.quantity} | Price: ₹${part.price}',
              //         ),
              //         trailing: IconButton(
              //           icon: const Icon(Icons.delete, color: Colors.red),
              //           onPressed: () {
              //             setState(() {
              //               _partsUsed.removeAt(index);
              //             });
              //           },
              //         ),
              //       );
              //     },
              //   ),
              // const SizedBox(height: 32),

              // Images Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upload Images',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '${_images.length}/6 selected',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
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
                      color: colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.3),
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
                              style: TextStyle(fontSize: 16),
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
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
