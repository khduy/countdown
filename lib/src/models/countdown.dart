import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Countdown {
  int? id;
  String title;
  DateTime datetime;
  Uint8List? photo;
  Color color;
  bool isLoop;

  late int days, hours, mins, secs;
  late DateTime date;
  late TimeOfDay time;

  Countdown({
    this.id,
    required this.title,
    required this.datetime,
    required this.color,
    this.photo,
    required this.isLoop,
  }) {
    time = TimeOfDay.fromDateTime(datetime);
    date = datetime.subtract(Duration(hours: time.hour, minutes: time.minute));
    var secondsUntilEnd = datetime.difference(DateTime.now()).inSeconds;
    if (secondsUntilEnd > 0) {
      days = secondsUntilEnd ~/ 86400;
      secondsUntilEnd = secondsUntilEnd % 86400;
      hours = secondsUntilEnd ~/ 3600;
      secondsUntilEnd = secondsUntilEnd % 3600;
      mins = secondsUntilEnd ~/ 60;
      secs = secondsUntilEnd % 60;
    } else {
      days = 0;
      hours = 0;
      mins = 0;
      secs = 0;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'TITLE': title,
      'DATETIME': datetime.millisecondsSinceEpoch,
      'PHOTO': photo,
      'COLOR': color.value,
      'ISLOOP': isLoop ? 1 : 0,
    };
  }

  factory Countdown.fromMap(Map<String, dynamic> map) {
    return Countdown(
      id: map['ID'],
      title: map['TITLE'],
      datetime: DateTime.fromMillisecondsSinceEpoch(map['DATETIME']),
      photo: map['PHOTO'],
      color: Color(int.parse(map['COLOR'])),
      isLoop: map['ISLOOP'] == 1 ? true : false,
    );
  }

  String dateToString() {
    return DateFormat("dd MMMM yyyy").format(date);
  }

  String timeToString() {
    var hour = time.hour < 10 ? "0${time.hour}" : "${time.hour}";
    var mins = time.minute < 10 ? "0${time.minute}" : "${time.minute}";
    return "$hour:$mins";
  }

  Countdown copyWith({
    int? id,
    String? title,
    DateTime? datetime,
    Uint8List? photo,
    Color? color,
    bool? isLoop,
  }) {
    return Countdown(
      id: id ?? this.id,
      title: title ?? this.title,
      datetime: datetime ?? this.datetime,
      photo: photo ?? this.photo,
      color: color ?? this.color,
      isLoop: isLoop ?? this.isLoop,
    );
  }
}
