import 'package:calender_app/core/constants/app_colors.dart';
import 'package:calender_app/features/calendar/data/models/event_model.dart';
import 'package:calender_app/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:calender_app/features/calendar/presentation/screens/add_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EventListView extends StatelessWidget {
  const EventListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        if (state.eventsForSelectedDay.isEmpty) {
          return const Expanded(
            child: Center(
              child: Text(
                'No events for this day.',
                style: TextStyle(color: AppColors.textFaded),
              ),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: state.eventsForSelectedDay.length,
            itemBuilder: (context, index) {
              final event = state.eventsForSelectedDay[index];
              return EventItemCard(event: event).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0);
            },
          ),
        );
      },
    );
  }
}

class EventItemCard extends StatelessWidget {
  const EventItemCard({
    super.key,
    required this.event,
  });

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    final startTime = DateFormat('HH:mm').format(event.startTime);
    final endTime = DateFormat('HH:mm').format(event.endTime);

    return InkWell(
      onTap: () => _showOptionsDialog(context, event),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: event.tagColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                event.tagName,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.darkBackground,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$startTime - $endTime',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textFaded,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              event.location,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textFaded,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, EventModel event) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: Text('Options', style: GoogleFonts.plusJakartaSans(color: AppColors.textLight)),
          content: Text('What would you like to do with this event?', style: GoogleFonts.plusJakartaSans(color: AppColors.textFaded)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<CalendarCubit>(),
                      child: AddEventScreen(
                        selectedDate: event.startTime,
                        event: event,
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showDeleteConfirmation(context, event);
              },
              child: const Text('Delete', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, EventModel event) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: Text('Delete Event', style: GoogleFonts.plusJakartaSans(color: AppColors.textLight)),
          content: Text('Are you sure you want to delete "${event.title}"?', style: GoogleFonts.plusJakartaSans(color: AppColors.textFaded)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<CalendarCubit>().deleteEvent(event.id);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Confirm', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        );
      },
    );
  }
} 