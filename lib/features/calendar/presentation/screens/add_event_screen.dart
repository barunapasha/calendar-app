import 'package:calender_app/core/constants/app_colors.dart';
import 'package:calender_app/features/calendar/data/models/event_model.dart';
import 'package:calender_app/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  final DateTime selectedDate;
  final EventModel? event;
  const AddEventScreen({
    super.key,
    required this.selectedDate,
    this.event,
  });

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  bool get _isEditMode => widget.event != null;

  // For simplicity, we'll use a predefined list of tags.
  final List<Color> _tagColors = [
    AppColors.tagYellow,
    AppColors.tagGreen,
    AppColors.tagBlue,
    AppColors.tagPink,
    AppColors.tagRed,
    AppColors.tagPurple,
  ];
  Color _selectedTagColor = AppColors.tagYellow;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _titleController.text = widget.event!.title;
      _locationController.text = widget.event!.location;
      _startTime = TimeOfDay.fromDateTime(widget.event!.startTime);
      _endTime = TimeOfDay.fromDateTime(widget.event!.endTime);
      _selectedTagColor = widget.event!.tagColor;
    } else {
      _startTime = TimeOfDay.now();
      _endTime = TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1)));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final startDateTime = DateTime(widget.selectedDate.year, widget.selectedDate.month, widget.selectedDate.day, _startTime.hour, _startTime.minute);
      final endDateTime = DateTime(widget.selectedDate.year, widget.selectedDate.month, widget.selectedDate.day, _endTime.hour, _endTime.minute);
      
      if (_isEditMode) {
        final updatedEvent = widget.event!.copyWith(
          title: _titleController.text,
          location: _locationController.text,
          tagColor: _selectedTagColor,
          startTime: startDateTime,
          endTime: endDateTime,
        );
        context.read<CalendarCubit>().updateEvent(updatedEvent);
      } else {
        final newEvent = EventModel(
          id: '', // Firestore will generate this
          userId: '', // Cubit will fill this in
          title: _titleController.text,
          location: _locationController.text,
          tagName: 'ME', // Placeholder
          tagColor: _selectedTagColor,
          startTime: startDateTime,
          endTime: endDateTime,
        );
        context.read<CalendarCubit>().addEvent(newEvent);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Event' : 'Add New Event',
            style: GoogleFonts.plusJakartaSans(color: AppColors.textLight)),
        backgroundColor: AppColors.cardBackground,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: AppColors.textLight),
                decoration: _buildInputDecoration('Event Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                style: const TextStyle(color: AppColors.textLight),
                decoration: _buildInputDecoration('Location'),
                validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
              ),
              const SizedBox(height: 20),
              _buildTimePicker('From', _startTime, () => _selectTime(context, true)),
              const SizedBox(height: 20),
              _buildTimePicker('To', _endTime, () => _selectTime(context, false)),
              const SizedBox(height: 30),
              Text('Select a Tag Color', style: GoogleFonts.plusJakartaSans(color: AppColors.textFaded, fontSize: 16)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12.0,
                children: _tagColors.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTagColor = color),
                    child: CircleAvatar(
                      backgroundColor: color,
                      radius: 20,
                      child: _selectedTagColor == color ? const Icon(Icons.check, color: AppColors.darkBackground) : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_isEditMode ? 'Save Changes' : 'Save Event', style: GoogleFonts.plusJakartaSans(fontSize: 18, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.plusJakartaSans(color: AppColors.textFaded),
      filled: true,
      fillColor: AppColors.cardBackground,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay time, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.plusJakartaSans(color: AppColors.textLight, fontSize: 16)),
            Text(
              time.format(context),
              style: GoogleFonts.plusJakartaSans(color: AppColors.textLight, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
} 