import 'item.dart';

class Roulette {
  final String id;
  final String name;
  final List<Item> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastPlayedAt;

  const Roulette({
    required this.id,
    required this.name,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    this.lastPlayedAt,
  });

  Roulette copyWith({
    String? id,
    String? name,
    List<Item>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastPlayedAt,
    bool clearLastPlayedAt = false,
  }) {
    return Roulette(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastPlayedAt:
          clearLastPlayedAt ? null : (lastPlayedAt ?? this.lastPlayedAt),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastPlayedAt': lastPlayedAt?.toIso8601String(),
    };
  }

  factory Roulette.fromJson(Map<String, dynamic> json) {
    return Roulette(
      id: json['id'] as String,
      name: json['name'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastPlayedAt: json['lastPlayedAt'] != null
          ? DateTime.parse(json['lastPlayedAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Roulette &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
