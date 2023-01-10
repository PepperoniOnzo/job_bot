import 'package:job_bot/shedule.dart';
import 'package:job_bot/telegram_bot.dart';

void main() async {
  // Initialize shedule
  Shedule shedule = Shedule();
  shedule.initShedule();

  // Initialize telegram bot
  TelegramBot telegramBot = TelegramBot(stream: shedule.controller.stream);
  await telegramBot.initialize();
  telegramBot.start();
}
