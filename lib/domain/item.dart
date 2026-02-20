import 'package:flutter/material.dart';

class Item {
  final String id;
  final String label;
  final int colorValue;
  final int order;
  final int weight; // 가중치: 1~10, 기본값 1

  const Item({
    required this.id,
    required this.label,
    required this.colorValue,
    required this.order,
    this.weight = 1,
  });

  Color get color => Color(colorValue);

  Item copyWith({
    String? id,
    String? label,
    int? colorValue,
    int? order,
    int? weight,
  }) {
    return Item(
      id: id ?? this.id,
      label: label ?? this.label,
      colorValue: colorValue ?? this.colorValue,
      order: order ?? this.order,
      weight: weight ?? this.weight,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'colorValue': colorValue,
      'order': order,
      'weight': weight,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      label: json['label'] as String,
      colorValue: json['colorValue'] as int,
      order: json['order'] as int,
      weight: (json['weight'] as int?) ?? 1, // 기존 데이터 마이그레이션: 기본값 1
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
