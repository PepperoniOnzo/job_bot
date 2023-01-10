import 'dart:async';
import 'package:job_bot/constants/bot_strings.dart';
import 'package:job_bot/constants/configuration.dart';
import 'package:job_bot/data/user_data.dart';
import 'package:job_bot/enums/day_time.dart';
import 'package:job_bot/enums/menu_state.dart';
import 'package:job_bot/services/data_manager.dart';
import 'package:job_bot/services/site_parser.dart';
import 'package:job_bot/services/validator.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class TelegramBot with SiteParser {
  late TeleDart teledart;
  late DataManager dataManager;
  late StreamSubscription<DayTime> subscription;
  Stream<DayTime> stream;

  TelegramBot({required this.stream});

  /// Send message to the user if necessary
  void sendMessage(UserData data) async {
    if (data.links.isNotEmpty) {
      for (var link in data.links) {
        if (await link.compareData()) {
          teledart.sendMessage(data.id, link.toString());
        }
      }
    }
  }

  /// Check users if have subscription to DayTime
  void checkUsers(DayTime dayTime) {
    if (dataManager.users.isNotEmpty) {
      for (var user in dataManager.users) {
        if (user.subscribedTimes.contains(dayTime)) {
          sendMessage(user);
        }
      }
    }
  }

  /// Start bot
  void start() {
    teledart.start();
  }

  /// Initialize bot
  initialize() async {
    // Initializing
    dataManager = DataManager();
    final username = (await Telegram(Configuration.token).getMe()).username;
    teledart = TeleDart(Configuration.token, Event(username!));

    // Set commands
    teledart.setMyCommands([
      BotCommand(command: 'start', description: 'Start bot'),
      BotCommand(command: 'subscribe', description: 'Subscribe to mailing'),
      BotCommand(
          command: 'ussubscribe', description: 'Unsubscribe from mailing'),
      BotCommand(command: 'set_time', description: 'Mailing time'),
      BotCommand(command: 'set_site', description: 'Set parsing site'),
      BotCommand(command: 'back', description: 'Back to the menu'),
      BotCommand(command: 'help', description: 'Help')
    ]);

    // Set handlers
    teledart.onCommand('start').listen((message) {
      message.reply(BotStrings.start);
    });

    teledart.onCommand('subscribe').listen((message) {
      if (dataManager.addUser(message.chat.id)) {
        message.reply(BotStrings.subscribeSuccess);
      } else {
        message.reply(BotStrings.subscribeError);
      }
    });

    teledart.onCommand('unsubscribe').listen((message) {
      if (dataManager.removeUser(message.chat.id)) {
        message.reply(BotStrings.unsubscribeSuccess);
      } else {
        message.reply(BotStrings.subscribeError);
      }
    });

    teledart.onCommand('set_time').listen((message) {
      if (dataManager.isUserExist(message.chat.id)) {
        message.replyMarkup = InlineKeyboardMarkup(inlineKeyboard: [
          [
            InlineKeyboardButton(text: 'Morning', callbackData: 'morning'),
            InlineKeyboardButton(text: 'Afternoon', callbackData: 'afternoon'),
            InlineKeyboardButton(text: 'Evening', callbackData: 'evening'),
            InlineKeyboardButton(text: 'Night', callbackData: 'Night'),
          ]
        ]);
        message.reply(BotStrings.setTime);
      } else {
        message.reply(BotStrings.subscribeError);
      }
    });

    teledart.onMessage(keyword: 'morning').listen((message) {
      if (!dataManager.isUserExist(message.chat.id)) {
        message.reply(BotStrings.subscribeError);
        dataManager.save();
        return;
      }

      if (dataManager.addDayTime(DayTime.morning, message.chat.id)) {
        message.reply(BotStrings.setTimeSuccess);
      } else {
        message.reply(BotStrings.setTimeUndo);
      }
    });

    teledart.onMessage(keyword: 'afternoon').listen((message) {
      if (!dataManager.isUserExist(message.chat.id)) {
        message.reply(BotStrings.subscribeError);
        dataManager.save();
        return;
      }

      if (dataManager.addDayTime(DayTime.afternoon, message.chat.id)) {
        message.reply(BotStrings.setTimeSuccess);
      } else {
        message.reply(BotStrings.setTimeUndo);
      }
    });

    teledart.onMessage(keyword: 'evening').listen((message) {
      if (!dataManager.isUserExist(message.chat.id)) {
        message.reply(BotStrings.subscribeError);
        dataManager.save();
        return;
      }

      if (dataManager.addDayTime(DayTime.evening, message.chat.id)) {
        message.reply(BotStrings.setTimeSuccess);
      } else {
        message.reply(BotStrings.setTimeUndo);
      }
    });

    teledart.onMessage(keyword: 'night').listen((message) {
      if (!dataManager.isUserExist(message.chat.id)) {
        message.reply(BotStrings.subscribeError);
        return;
      }

      if (dataManager.addDayTime(DayTime.night, message.chat.id)) {
        message.reply(BotStrings.setTimeSuccess);
        dataManager.save();
      } else {
        message.reply(BotStrings.setTimeUndo);
      }
    });

    teledart.onCommand('set_site').listen((message) {
      if (!dataManager.isUserExist(message.chat.id)) {
        message.reply(BotStrings.subscribeError);
        return;
      }

      message.reply(BotStrings.setSite);

      dataManager.setMenuState(MenuState.site, message.chat.id);
    });

    teledart.onMessage(entityType: 'url').listen((message) {
      if (!dataManager.isUserExist(message.chat.id)) return;
      if (dataManager.getMenuState(message.chat.id) == MenuState.site) {
        if (Validator.validate(message.entities![0].url ?? '')) {
          dataManager.setSite(message.entities![0].url ?? '', message.chat.id);
          message.reply(BotStrings.setSiteSuccess);
          dataManager.setMenuState(MenuState.main, message.chat.id);
        } else {
          message.reply(BotStrings.setSiteError);
        }
      } else {
        message.reply(BotStrings.pleasePressBack);
      }
    });

    teledart.onCommand('help').listen((message) {
      message.reply(BotStrings.help);
    });

    teledart.onCommand('back').listen((message) {
      if (!dataManager.isUserExist(message.chat.id)) {
        message.reply(BotStrings.subscribeError);
        return;
      }

      message.reply(BotStrings.pressBack);

      dataManager.setMenuState(MenuState.main, message.chat.id);
    });

    subscription = stream.listen((event) {
      checkUsers(event);
    });
  }
}
