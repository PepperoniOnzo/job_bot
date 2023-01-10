import 'dart:async';

import 'package:job_bot/constants/configuration.dart';
import 'package:job_bot/enums/day_time.dart';
import 'services/int_to_time.dart';

class Shedule {
  late StreamController<DayTime> controller;
  late DayTime currentDayTime;

  void initShedule() {
    DateTime now = DateTime.now();
    currentDayTime = now.hour.getTime();
    controller = StreamController();
    shedule();
  }

  void shedule() {
    DateTime now = DateTime.now();
    DateTime next;
    Duration duration;

    switch (currentDayTime) {
      case DayTime.morning:
        next = DateTime(
            now.year, now.month, now.day, Configuration.afternoon, 0, 0);
        duration = next.difference(now);
        Timer(duration, () {
          currentDayTime = DayTime.afternoon;
          controller.sink.add(currentDayTime);
        });
        break;
      case DayTime.afternoon:
        next =
            DateTime(now.year, now.month, now.day, Configuration.evening, 0, 0);
        duration = next.difference(now);
        Timer(duration, () {
          currentDayTime = DayTime.evening;
          controller.sink.add(currentDayTime);
        });
        break;
      case DayTime.evening:
        next = DateTime(
            now.year, now.month, now.day + 1, Configuration.night, 0, 0);
        duration = next.difference(now);
        Timer(duration, () {
          currentDayTime = DayTime.morning;
          controller.sink.add(currentDayTime);
        });
        break;
      case DayTime.night:
        next = DateTime(
            now.year, now.month, now.day + 1, Configuration.morning, 0, 0);
        duration = next.difference(now);
        Timer(duration, () {
          currentDayTime = DayTime.morning;
          controller.sink.add(currentDayTime);
        });
        shedule();
    }
  }
}
