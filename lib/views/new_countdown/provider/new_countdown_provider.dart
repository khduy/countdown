import 'dart:io';

import 'package:countdown/constant/color.dart';
import 'package:countdown/database/database.dart';
import 'package:countdown/models/countdown.dart';
import 'package:flutter/material.dart';

class NewCountdownProvider extends ChangeNotifier {
  Countdown? _needUpdateCountdown;

  String? _name;
  set setName(String? name) => _name = name;
  String? get name => _name;

  int _pickedColorIndex = 0;
  int get pickedColorIndex => _pickedColorIndex;
  Color _color = MColor.red;

  bool _isLoop = true;
  bool get isLoop => _isLoop;

  File? _backgroundPhoto;
  File? get backgroundPhoto => _backgroundPhoto;

  var _time = TimeOfDay.now();
  TimeOfDay get time => _time;

  DateTime _date = DateTime.now();
  DateTime get date => _date;

  void pickColor(int pickedIndex, Color color) {
    _pickedColorIndex = pickedIndex;
    _color = color;
    notifyListeners();
  }

  void pickDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  void pickTime(TimeOfDay time) {
    _time = time;
    notifyListeners();
  }

  void pickPhoto(File photo) {
    _backgroundPhoto = photo;
    notifyListeners();
  }

  void setLoop(bool value) {
    _isLoop = value;
    notifyListeners();
  }

  Future<void> saveCountdown() async {
    _date = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);

    var countdown = Countdown(
      title: _name!,
      datetime: _date,
      color: _color,
      photo: _backgroundPhoto?.readAsBytesSync(),
      isLoop: _isLoop,
    );

    if (_needUpdateCountdown == null)
      await DatabaseHelper().saveCountdown(countdown);
    else {
      countdown.id = _needUpdateCountdown!.id;
      await DatabaseHelper().updateCountdown(countdown);
    }
  }

  setData(Countdown? countdown) {
    if (countdown != null) {
      _needUpdateCountdown = countdown;
      _name = countdown.title;
      _date = countdown.date;
      _time = countdown.time;
      // set color ?
      _isLoop = countdown.isLoop;
      // if (countdown.photo != null) {
      //   _backgroundPhoto = File.fromRawPath(countdown.photo!);
      // }
    }
  }
}
