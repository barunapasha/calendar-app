part of 'calendar_cubit.dart';

class CalendarState extends Equatable {
  const CalendarState({
    required this.focusedDay,
    required this.selectedDay,
    required this.eventsForSelectedDay,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;
  final List<EventModel> eventsForSelectedDay;

  factory CalendarState.initial() {
    final now = DateTime.now();
    return CalendarState(
      focusedDay: now,
      selectedDay: now,
      eventsForSelectedDay: const [],
    );
  }

  @override
  List<Object> get props => [focusedDay, selectedDay, eventsForSelectedDay];

  CalendarState copyWith({
    DateTime? focusedDay,
    DateTime? selectedDay,
    List<EventModel>? eventsForSelectedDay,
  }) {
    return CalendarState(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      eventsForSelectedDay:
          eventsForSelectedDay ?? this.eventsForSelectedDay,
    );
  }
} 