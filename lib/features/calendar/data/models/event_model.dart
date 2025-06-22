import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EventModel extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String location;
  final String tagName;
  final Color tagColor;
  final DateTime startTime;
  final DateTime endTime;

  const EventModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.location,
    required this.tagName,
    required this.tagColor,
    required this.startTime,
    required this.endTime,
  });

  factory EventModel.fromJson(Map<String, dynamic> json, String id) {
    return EventModel(
      id: id,
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      tagName: json['tagName'] ?? '',
      tagColor: Color(int.parse(json['tagColor'], radix: 16)),
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: (json['endTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'location': location,
      'tagName': tagName,
      'tagColor': tagColor.value.toRadixString(16),
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        location,
        tagName,
        tagColor,
        startTime,
        endTime,
      ];

  EventModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? location,
    String? tagName,
    Color? tagColor,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return EventModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      location: location ?? this.location,
      tagName: tagName ?? this.tagName,
      tagColor: tagColor ?? this.tagColor,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
} 