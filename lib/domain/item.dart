import 'package:flutter/material.dart';

class Item {
  final String id;
  final String label;
  final int colorValue;
  final int order;

  const Item({
    required this.id,
    required this.label,
    required this.colorValue,
    required this.order,
  });

  Color get color => Color(colorValue);

  Item copyWith({
    String? id,
    String? label,
    int? colorValue,
    int? order,
  }) {
    return Item(
      id: id ?? this.id,
      label: label ?? this.label,
      colorValue: colorValue ?? this.colorValue,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'colorValue': colorValue,
      'order': order,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      label: json['label'] as String,
      colorValue: json['colorValue'] as int,
      order: json['order'] as int,
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
