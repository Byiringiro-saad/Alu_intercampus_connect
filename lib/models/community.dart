import 'opportunity_category.dart';

class CommunityModel {
  CommunityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.memberCount,
    this.isJoined = false,
    this.upcomingActivityIds = const [],
    this.memberAvatars = const [],
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final OpportunityCategory category;
  int memberCount;
  bool isJoined;
  final List<String> upcomingActivityIds;
  final List<String> memberAvatars;

  CommunityModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    OpportunityCategory? category,
    int? memberCount,
    bool? isJoined,
    List<String>? upcomingActivityIds,
    List<String>? memberAvatars,
  }) {
    return CommunityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      memberCount: memberCount ?? this.memberCount,
      isJoined: isJoined ?? this.isJoined,
      upcomingActivityIds: upcomingActivityIds ?? this.upcomingActivityIds,
      memberAvatars: memberAvatars ?? this.memberAvatars,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'category': category.id,
        'memberCount': memberCount,
        'isJoined': isJoined,
        'upcomingActivityIds': upcomingActivityIds,
        'memberAvatars': memberAvatars,
      };

  factory CommunityModel.fromJson(Map<String, dynamic> json) => CommunityModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String,
        category: OpportunityCategory.fromId(json['category'] as String) ??
            OpportunityCategory.clubs,
        memberCount: json['memberCount'] as int? ?? 0,
        isJoined: json['isJoined'] as bool? ?? false,
        upcomingActivityIds:
            (json['upcomingActivityIds'] as List<dynamic>?)?.cast<String>() ??
                [],
        memberAvatars:
            (json['memberAvatars'] as List<dynamic>?)?.cast<String>() ?? [],
      );
}
