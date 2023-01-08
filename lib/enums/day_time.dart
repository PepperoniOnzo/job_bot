import 'package:job_bot/constants/configuration.dart';

/// Time of day
enum DayTime {
  morning,
  afternoon,
  evening,
  night;

  /// Get next time of day
  DayTime getNext() {
    switch (this) {
      case DayTime.morning:
        return DayTime.afternoon;
      case DayTime.afternoon:
        return DayTime.evening;
      case DayTime.evening:
        return DayTime.night;
      case DayTime.night:
        return DayTime.morning;
      default:
        return DayTime.morning;
    }
  }

  /// Get default time of day by hour
  int getDefaultTime() {
    switch (this) {
      case DayTime.morning:
        return Configuration.morning;
      case DayTime.afternoon:
        return Configuration.afternoon;
      case DayTime.evening:
        return Configuration.evening;
      case DayTime.night:
        return Configuration.night;
      default:
        return Configuration.morning;
    }
  }
}
