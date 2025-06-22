import 'package:calender_app/features/calendar/data/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventRepository {
  final FirebaseFirestore _firestore;

  EventRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<EventModel>> getEventsForDay({
    required DateTime day,
    required String userId,
  }) {
    // We create a start and end time for the query to get all events on a specific day
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('startTime', isLessThan: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return EventModel.fromJson(data, doc.id);
      }).toList();
    });
  }

  Future<void> addEvent({
    required EventModel event,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .add(event.toJson());
    } catch (e) {
      // In a real app, you'd handle this error more gracefully
      print('Error adding event: $e');
      rethrow;
    }
  }

  Future<void> updateEvent({
    required EventModel event,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(event.id)
          .update(event.toJson());
    } catch (e) {
      print('Error updating event: $e');
      rethrow;
    }
  }

  Future<void> deleteEvent({
    required String eventId,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .delete();
    } catch (e) {
      print('Error deleting event: $e');
      rethrow;
    }
  }
} 