import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../controllers/trip_controller.dart';
import '../models/trip.dart';
import '../utils/constants.dart';

/// Screen for creating a new trip
class NewTripScreen extends StatefulWidget {
  final Trip? tripToEdit;

  const NewTripScreen({super.key, this.tripToEdit});

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _destinationController = TextEditingController();
  final _departureController = TextEditingController();
  final _transportNumberController = TextEditingController();
  final _notesController = TextEditingController();

  TripType _selectedType = TripType.flight;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime? _endDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.tripToEdit != null) {
      _initializeWithTrip(widget.tripToEdit!);
    }
  }

  void _initializeWithTrip(Trip trip) {
    _nameController.text = trip.name;
    _destinationController.text = trip.destination ?? '';
    _departureController.text = trip.departureLocation ?? '';
    _transportNumberController.text = trip.transportNumber ?? '';
    _notesController.text = trip.notes ?? '';
    _selectedType = trip.type;
    _startDate = trip.startDate;
    _endDate = trip.endDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _destinationController.dispose();
    _departureController.dispose();
    _transportNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.tripToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Trip' : 'New Trip'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.paddingMD,
          children: [
            // Trip name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Trip Name *',
                hintText: 'e.g., Tokyo Business Trip',
                prefixIcon: Icon(Icons.travel_explore),
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

            // Trip type
            DropdownButtonFormField<TripType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Trip Type *',
                prefixIcon: Icon(Icons.directions),
              ),
              items: TripType.values.map((type) {
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

            // Destination
            TextFormField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: 'Destination',
                hintText: 'e.g., Tokyo, Japan',
                prefixIcon: Icon(Icons.location_on),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: AppSpacing.md),

            // Departure location
            TextFormField(
              controller: _departureController,
              decoration: const InputDecoration(
                labelText: 'Departure From',
                hintText: 'e.g., New York, USA',
                prefixIcon: Icon(Icons.flight_takeoff),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: AppSpacing.md),

            // Transport number (flight/train/bus number)
            TextFormField(
              controller: _transportNumberController,
              decoration: InputDecoration(
                labelText: '${_selectedType.displayName} Number',
                hintText: _selectedType == TripType.flight
                    ? 'e.g., AA123'
                    : _selectedType == TripType.train
                    ? 'e.g., T456'
                    : 'e.g., B789',
                prefixIcon: const Icon(Icons.confirmation_number),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: AppSpacing.md),

            // Start date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Start Date *'),
              subtitle: Text(
                DateFormat('MMM dd, yyyy - hh:mm a').format(_startDate),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _selectStartDate(),
            ),
            const Divider(),

            // End date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: const Text('End Date (Optional)'),
              subtitle: Text(
                _endDate != null
                    ? DateFormat('MMM dd, yyyy - hh:mm a').format(_endDate!)
                    : 'Not set',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_endDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        setState(() {
                          _endDate = null;
                        });
                      },
                    ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () => _selectEndDate(),
            ),
            const Divider(),

            const SizedBox(height: AppSpacing.md),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Additional details about your trip',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Save button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveTrip,
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
                  : Text(isEditing ? 'Update Trip' : 'Create Trip'),
            ),
          ],
        ),
      ),
    );
  }

  /// Select start date and time
  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startDate),
      );

      if (time != null) {
        setState(() {
          _startDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  /// Select end date and time
  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 1)),
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: _endDate != null
            ? TimeOfDay.fromDateTime(_endDate!)
            : const TimeOfDay(hour: 23, minute: 59),
      );

      if (time != null) {
        setState(() {
          _endDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  /// Save trip
  Future<void> _saveTrip() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate end date
    if (_endDate != null && _endDate!.isBefore(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppMessages.validationEndBeforeStart),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final tripController = Provider.of<TripController>(context, listen: false);

    final trip = Trip(
      id: widget.tripToEdit?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _selectedType,
      startDate: _startDate,
      endDate: _endDate,
      destination: _destinationController.text.trim().isNotEmpty
          ? _destinationController.text.trim()
          : null,
      departureLocation: _departureController.text.trim().isNotEmpty
          ? _departureController.text.trim()
          : null,
      transportNumber: _transportNumberController.text.trim().isNotEmpty
          ? _transportNumberController.text.trim()
          : null,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      createdAt: widget.tripToEdit?.createdAt,
      updatedAt: DateTime.now(),
    );

    bool success;
    if (widget.tripToEdit != null) {
      success = await tripController.updateTrip(trip);
    } else {
      success = await tripController.addTrip(trip);
    }

    setState(() {
      _isLoading = false;
    });

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.tripToEdit != null
                  ? AppMessages.tripUpdated
                  : AppMessages.tripAdded,
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
            content: Text(tripController.error ?? AppMessages.errorGeneric),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}