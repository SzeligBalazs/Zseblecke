import 'dart:typed_data';

class NoteModel {
  final int? id;
  final String subject;
  final String where;
  final String pageNumber;
  final String taskNumber;
  final String year;
  final String month;
  final String day;

  NoteModel({
    this.id,
    required this.subject,
    required this.where,
    required this.pageNumber,
    required this.taskNumber,
    required this.year,
    required this.month,
    required this.day,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      subject: map['subject'],
      where: map['bookType'],
      pageNumber: map['pageNumber'],
      taskNumber: map['taskNumber'],
      year: map['year'],
      month: map['month'],
      day: map['day'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'bookType': where,
      'pageNumber': pageNumber,
      'taskNumber': taskNumber,
      'year': year,
      'month': month,
      'day': day,
    };
  }
}
