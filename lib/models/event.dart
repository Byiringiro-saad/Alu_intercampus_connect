import 'opportunity_category.dart';

enum RsvpStatus { none, going, interested }

class EventModel {
  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.organizer,
    required this.organizerId,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
    required this.imageUrl,
    this.maxParticipants = 100,
    this.participantCount = 0,
    this.interestedCount = 0,
    this.attendeeAvatars = const [],
    this.communityId,
    this.isFeatured = false,
    this.matchScore = 0,
  });

  final String id;
  final String title;
  final String description;
  final String organizer;
  final String organizerId;
  final DateTime date;
  final String time;
  final String location;
  final OpportunityCategory category;
  final String imageUrl;
  final int maxParticipants;
  int participantCount;
  int interestedCount;
  final List<String> attendeeAvatars;
  final String? communityId;
  final bool isFeatured;
  int matchScore;

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? organizer,
    String? organizerId,
    DateTime? date,
    String? time,
    String? location,
    OpportunityCategory? category,
    String? imageUrl,
    int? maxParticipants,
    int? participantCount,
    int? interestedCount,
    List<String>? attendeeAvatars,
    String? communityId,
    bool? isFeatured,
    int? matchScore,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      organizer: organizer ?? this.organizer,
      organizerId: organizerId ?? this.organizerId,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      participantCount: participantCount ?? this.participantCount,
      interestedCount: interestedCount ?? this.interestedCount,
      attendeeAvatars: attendeeAvatars ?? this.attendeeAvatars,
      communityId: communityId ?? this.communityId,
      isFeatured: isFeatured ?? this.isFeatured,
      matchScore: matchScore ?? this.matchScore,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'organizer': organizer,
        'organizerId': organizerId,
        'date': date.toIso8601String(),
        'time': time,
        'location': location,
        'category': category.id,
        'imageUrl': imageUrl,
        'maxParticipants': maxParticipants,
        'participantCount': participantCount,
        'interestedCount': interestedCount,
        'attendeeAvatars': attendeeAvatars,
        'communityId': communityId,
        'isFeatured': isFeatured,
        'matchScore': matchScore,
      };

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        organizer: json['organizer'] as String,
        organizerId: json['organizerId'] as String,
        date: DateTime.parse(json['date'] as String),
        time: json['time'] as String,
        location: json['location'] as String,
        category: OpportunityCategory.fromId(json['category'] as String) ??
            OpportunityCategory.events,
        imageUrl: json['imageUrl'] as String,
        maxParticipants: json['maxParticipants'] as int? ?? 100,
        participantCount: json['participantCount'] as int? ?? 0,
        interestedCount: json['interestedCount'] as int? ?? 0,
        attendeeAvatars:
            (json['attendeeAvatars'] as List<dynamic>?)?.cast<String>() ?? [],
        communityId: json['communityId'] as String?,
        isFeatured: json['isFeatured'] as bool? ?? false,
        matchScore: json['matchScore'] as int? ?? 0,
      );
}
