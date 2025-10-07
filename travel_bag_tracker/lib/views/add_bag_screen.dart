import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../controllers/bag_controller.dart';
import '../models/trip.dart';
import '../models/bag.dart';
import '../utils/constants.dart';

/// Screen for adding or editing a bag
class AddBagScreen extends StatefulWidget {
  final Trip trip;
  final Bag? bagToEdit;

  const AddBagScreen({super.key, required this.trip, this.bagToEdit});

  @override
  State<AddBagScreen> createState() => _AddBagScreenState();
}

class _AddBagScreenState extends State<AddBagScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final _weightController = TextEditingController();
  final _tagNumberController = TextEditingController();
  final _notesController = TextEditingController();

  BagType _selectedType = BagType.suitcase;
  BagSize _selectedSize = BagSize.medium;
  String? _photoPath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.bagToEdit != null) {
      _initializeWithBag(widget.bagToEdit!);
    }
  }

  void _initializeWithBag(Bag bag) {
    _nameController.text = bag.name;
    _colorController.text = bag.color ?? '';
    _weightController.text = bag.weight ?? '';
    _tagNumberController.text = bag.tagNumber ?? '';
    _notesController.text = bag.notes ?? '';
    _selectedType = bag.type;
    _selectedSize = bag.size;
    _photoPath = bag.photoPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    _weightController.dispose();
    _tagNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.bagToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Bag' : 'Add Bag'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.paddingMD,
          children: [
            // Photo section
            _buildPhotoSection(),
            const SizedBox(height: AppSpacing.lg),

            // Bag name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Bag Name *',
                hintText: 'e.g., Black Suitcase',
                prefixIcon: Icon(Icons.luggage),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppMessages.validationNameRequired;
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: AppSpacing.md),

            // Bag type
            DropdownButtonFormField<BagType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Bag Type *',
                prefixIcon: Icon(Icons.category),
              ),
              items: BagType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Text(type.icon, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: AppSpacing.sm),
                      Text(type.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),

            // Bag size
            DropdownButtonFormField<BagSize>(
              value: _selectedSize,
              decoration: const InputDecoration(
                labelText: 'Size *',
                prefixIcon: Icon(Icons.straighten),
              ),
              items: BagSize.values.map((size) {
                return DropdownMenuItem(
                  value: size,
                  child: Text(size.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedSize = value;
                  });
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),

            // Color
            TextFormField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: 'Color',
                hintText: 'e.g., Black, Blue',
                prefixIcon: Icon(Icons.palette),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: AppSpacing.md),

            // Weight
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Weight',
                hintText: 'e.g., 23 kg',
                prefixIcon: Icon(Icons.scale),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Tag number
            TextFormField(
              controller: _tagNumberController,
              decoration: const InputDecoration(
                labelText: 'Tag Number',
                hintText: 'Luggage tag number',
                prefixIcon: Icon(Icons.qr_code),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: AppSpacing.md),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Additional details',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Save button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveBag,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.radiusMD,
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Text(isEditing ? 'Update Bag' : 'Add Bag'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build photo section
  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bag Photo',
          style: AppTextStyles.subtitle1,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (_photoPath != null)
          Stack(
            children: [
              ClipRRect(
                borderRadius: AppRadius.radiusMD,
                child: Image.file(
                  File(_photoPath!),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _photoPath = null;
                    });
                  },
                ),
              ),
            ],
          )
        else
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.border.withOpacity(0.1),
              borderRadius: AppRadius.radiusMD,
              border: Border.all(
                color: AppColors.border,
                style: BorderStyle.solid,
                width: 2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: AppIconSize.xxl,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Add a photo of your bag',
                    style: AppTextStyles.body2,
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(fromCamera: true),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(fromCamera: false),
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Pick image from camera or gallery
  Future<void> _pickImage({required bool fromCamera}) async {
    final bagController = Provider.of<BagController>(context, listen: false);

    final photoPath = await bagController.pickImage(fromCamera: fromCamera);

    if (photoPath != null) {
      setState(() {
        _photoPath = photoPath;
      });
    }
  }

  /// Save bag
  Future<void> _saveBag() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final bagController = Provider.of<BagController>(context, listen: false);

    final bag = Bag(
      id: widget.bagToEdit?.id ?? const Uuid().v4(),
      tripId: widget.trip.id,
      name: _nameController.text.trim(),
      type: _selectedType,
      size: _selectedSize,
      color: _colorController.text.trim().isNotEmpty
          ? _colorController.text.trim()
          : null,
      weight: _weightController.text.trim().isNotEmpty
          ? _weightController.text.trim()
          : null,
      tagNumber: _tagNumberController.text.trim().isNotEmpty
          ? _tagNumberController.text.trim()
          : null,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      photoPath: _photoPath,
      isVerified: widget.bagToEdit?.isVerified ?? false,
      createdAt: widget.bagToEdit?.createdAt,
      updatedAt: DateTime.now(),
    );

    bool success;
    if (widget.bagToEdit != null) {
      success = await bagController.updateBag(bag);
    } else {
      success = await bagController.addBag(bag);
    }

    setState(() {
      _isLoading = false;
    });

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.bagToEdit != null
                  ? AppMessages.bagUpdated
                  : AppMessages.bagAdded,
            ),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(bagController.error ?? AppMessages.errorGeneric),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}