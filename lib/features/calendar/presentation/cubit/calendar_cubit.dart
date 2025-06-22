import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:calender_app/features/calendar/data/models/event_model.dart';
import 'package:calender_app/features/calendar/data/repositories/event_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final EventRepository _eventRepository;
  final String _userId;
  StreamSubscription? _eventsSubscription;

  CalendarCubit({
    required EventRepository eventRepository,
    required String userId,
  })  : _eventRepository = eventRepository,
        _userId = userId,
        super(CalendarState.initial()) {
    _loadEventsForDay(state.selectedDay);
  }

  void _loadEventsForDay(DateTime day) {
    _eventsSubscription?.cancel();
    _eventsSubscription =
        _eventRepository.getEventsForDay(day: day, userId: _userId).listen(
      (events) {
        emit(state.copyWith(eventsForSelectedDay: events));
      },
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(state.selectedDay, selectedDay)) {
      emit(state.copyWith(
        selectedDay: selectedDay,
        focusedDay: focusedDay,
        eventsForSelectedDay: [], // Clear events momentarily
      ));
      _loadEventsForDay(selectedDay);
    }
  }

  void onPageChanged(DateTime focusedDay) {
    emit(state.copyWith(focusedDay: focusedDay));
  }

  Future<void> addEvent(EventModel event) async {
    // We ensure the event has the correct userId before saving
    final eventWithUser = event.copyWith(userId: _userId);
    await _eventRepository.addEvent(event: eventWithUser, userId: _userId);
  }

  Future<void> updateEvent(EventModel event) async {
    // We ensure the event has the correct userId before saving
    final eventWithUser = event.copyWith(userId: _userId);
    await _eventRepository.updateEvent(event: eventWithUser, userId: _userId);
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventRepository.deleteEvent(eventId: eventId, userId: _userId);
  }

  @override
  Future<void> close() {
    _eventsSubscription?.cancel();
    return super.close();
  }
} 