import 'dart:async';

import 'package:countdown/models/countdown.dart';
import 'package:countdown/services/database/database.dart';
import 'package:countdown/services/notification/notification_service.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  var _countdowns = <Countdown>[];
  List<Countdown> get countdowns => _countdowns;

  Future<void> getCountdowns() async {
    _countdowns = await DatabaseHelper().getListCountdown();
    notifyListeners();
  }

  Future<void> deleteCountdown(int id) async {
    await DatabaseHelper().deleteCountdown(id);
    notifyListeners();
  }

  Timer? _timer;

  void initTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      for (int i = 0; i < _countdowns.length; i++) {
        if (_countdowns[i].secs == _countdowns[i].mins &&
            _countdowns[i].mins == _countdowns[i].hours &&
            _countdowns[i].hours == _countdowns[i].days &&
            _countdowns[i].days == 0) {
          if (_countdowns[i].isLoop) {
            var updatedCd = _countdowns[i].copyWith(
              datetime: _countdowns[i].datetime.add(Duration(days: 7)),
            );

            DatabaseHelper().updateCountdown(updatedCd).then((value) => getCountdowns());
            NotificationService().scheduleNotification(
              id: updatedCd.id!,
              title: updatedCd.title,
              time: updatedCd.datetime,
            );
          }
        } else if (_countdowns[i].secs > 0) {
          _countdowns[i].secs--;
        } else {
          // secs = 0
          _countdowns[i].secs = 59;
          if (_countdowns[i].mins > 0) {
            _countdowns[i].mins--;
          } else {
            // min = 0
            _countdowns[i].mins = 59;
            if (_countdowns[i].hours > 0) {
              _countdowns[i].hours--;
            } else {
              // hour = 0
              _countdowns[i].hours = 23;
              if (_countdowns[i].days > 0) {
                _countdowns[i].days--;
              }
            }
          }
        }
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
