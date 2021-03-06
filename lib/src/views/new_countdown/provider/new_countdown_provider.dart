import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../models/countdown.dart';
import '../../../services/database/database.dart';
import '../../../services/notification/notification_service.dart';

class NewCountdownProvider extends ChangeNotifier {
  Countdown? _cdNeedUpdated;

  String? _name;
  set setName(String? name) => _name = name;
  String? get name => _name;

  Color? _color;
  Color? get color => _color;
  void pickColor(Color color) {
    _color = color;
  }

  bool _isLoop = true;
  bool get isLoop => _isLoop;
  void setLoop(bool value) {
    _isLoop = value;
    notifyListeners();
  }

  Uint8List? _backgroundPhoto;
  Uint8List? get backgroundPhoto => _backgroundPhoto;
  void pickPhoto(File photo) {
    _backgroundPhoto = photo.readAsBytesSync();
    notifyListeners();
  }

  var _time = TimeOfDay.now();
  TimeOfDay get time => _time;
  void pickTime(TimeOfDay time) {
    _time = time;
    notifyListeners();
  }

  DateTime _date = DateTime.now();
  DateTime get date => _date;
  void pickDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  Future<void> saveCountdown() async {
    _date = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);

    var countdown = Countdown(
      title: _name!,
      datetime: _date,
      color: _color!,
      photo: _backgroundPhoto,
      isLoop: _isLoop,
    );

    if (_cdNeedUpdated == null) {
      int newId = await DatabaseHelper().newCountdown(countdown);
      await NotificationService().scheduleNotification(
        id: newId,
        title: _name!,
        datetime: _date,
        isRepeat: _isLoop,
      );
    } else {
      countdown.id = _cdNeedUpdated!.id;
      await DatabaseHelper().updateCountdown(countdown);
      await NotificationService().scheduleNotification(
        id: countdown.id!,
        title: _name!,
        datetime: _date,
        isRepeat: _isLoop,
      );
    }
  }

  setData(Countdown? countdown) {
    if (countdown != null) {
      _cdNeedUpdated = countdown;
      _name = countdown.title;
      _date = countdown.date;
      _time = countdown.time;
      _color = countdown.color;
      _isLoop = countdown.isLoop;
      _backgroundPhoto = countdown.photo;
    }
  }
}
