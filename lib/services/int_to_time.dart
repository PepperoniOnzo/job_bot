import 'package:job_bot/constants/configuration.dart';
import 'package:job_bot/enums/day_time.dart';

extension IntToHour on int {
  /// Get time of day by hour. Recieve [int] and return [DayTime]
  DayTime getTime() {
    // Check if hour is valid
    if (this > 24 || this < 0) {
      throw Exception('Invalid hour');
    }

    // Check if hour is in range
    if (this >= Configuration.morning && this < Configuration.afternoon) {
      return DayTime.morning;
    } else if (this >= Configuration.afternoon &&
        this < Configuration.evening) {
      return DayTime.afternoon;
    } else if (this >= Configuration.evening && this < Configuration.night) {
      return DayTime.evening;
    } else {
      return DayTime.night;
    }
  }
}
