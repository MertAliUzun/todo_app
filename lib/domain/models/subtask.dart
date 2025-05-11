import 'package:flutter/material.dart';

class Subtask {
  final int id;
  final String text;
  final bool isCompleted;
  final int orderNo;

  Subtask({
    required this.id,
    required this.text,
    this.isCompleted = false,
    required this.orderNo,
  });

  Subtask copyWith({
    int? id,
    String? text,
    bool? isCompleted,
    int? orderNo,
  }) {
    return Subtask(
      id: id ?? this.id,
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
      orderNo: orderNo ?? this.orderNo,
    );
  }
} 