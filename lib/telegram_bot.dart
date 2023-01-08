import 'dart:async';
import 'package:job_bot/enums/day_time.dart';
import 'package:job_bot/services/data_manager.dart';
import 'package:job_bot/services/site_parser.dart';

class TelegramBot with SiteParser {
  var teledart;
  late DataManager dataManager;
  StreamSubscription subscription;

  TelegramBot({required this.subscription}) {
    initialize();
  }

  /// Initialize bot
  void initialize() {
    dataManager = DataManager();
    //TODO: initialize bot
    throw UnimplementedError();
  }

  /// Send message to the user
  void sendMessage(int id) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  void checkUsers(DayTime dayTime) {
    // TODO: implement checkUsers
    throw UnimplementedError();
  }
}
