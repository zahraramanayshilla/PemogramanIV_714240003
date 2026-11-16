import 'dart:typed_data';

import 'package:flutter/material.dart';

class ContactModel {
  final String name;
  final String phone;
  final DateTime date;
  final Color color;
  final String fileName;
  final String? filePath;
  final Uint8List? fileBytes;

  ContactModel({
    required this.name,
    required this.phone,
    required this.date,
    required this.color,
    required this.fileName,
    this.filePath,
    this.fileBytes,
  });

  ContactModel copyWith({
    String? name,
    String? phone,
    DateTime? date,
    Color? color,
    String? fileName,
    String? filePath,
    Uint8List? fileBytes,
  }) {
    return ContactModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      date: date ?? this.date,
      color: color ?? this.color,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      fileBytes: fileBytes ?? this.fileBytes,
    );
  }
}
