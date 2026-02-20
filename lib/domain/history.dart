import 'package:flutter/material.dart';

class History {
  final String id;
  final String rouletteId;
  final String resultLabel;
  final int resultColorValue;
  final DateTime playedAt;

  const History({
    required this.id,
    required this.rouletteId,
    required this.resultLabel,
    required this.resultColorValue,
    required this.playedAt,
  });

  Color get resultColor => Color(resultColorValue);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rouletteId': rouletteId,
      'resultLabel': resultLabel,
      'resultColorValue': resultColorValue,
      'playedAt': playedAt.toIso8601String(),
    };
  }

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'] as String,
      rouletteId: json['rouletteId'] as String,
      resultLabel: json['resultLabel'] as String,
      resultColorValue: json['resultColorValue'] as int,
      playedAt: DateTime.parse(json['playedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is History &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
