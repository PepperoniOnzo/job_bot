import 'package:job_bot/constants/hiden_configuration.dart';

class Configuration {
  /// Telegram bot token
  static const String token = HidenConfigurations.token;

  /// Save data path
  static const String saveDataPath = 'db/data.json';

  // Time of days
  /// Morning time of day
  static const int morning = 12;

  /// Afternoon time of day
  static const int afternoon = 15;

  /// Evening time of day
  static const int evening = 18;

  /// Night time of day
  static const int night = 21;
}
