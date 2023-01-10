import 'package:job_bot/enums/site_type.dart';

class BotStrings {
  static final String start =
      "You can use this bot for announcements about jobs from sites"
      "${SiteType.djinni.name} and ${SiteType.dou.name}.\n"
      "To start send command /subscription.\n\n"
      "To get help, use the /help command.";

  static final String setSite = 'Paste site link. Example:'
      'https://djinni.co/jobs/keyword-flutter/?exp_level=1y&employment=remote \n\n'
      'Acceptable sites ${SiteType.djinni.name} and ${SiteType.dou.name}.';

  static final String setTime =
      'Choose time from list, can be a few options:\n\n'
      '1. Morning (12:00)\n'
      '2. Afternoon (15:00)\n'
      '3. Evening (18:00)\n'
      '4. Night (21:00)';

  static final String setTimeSuccess = 'Successfully set time';
  static final String setTimeUndo = 'Successfully deleted time';

  static const String help = 'List of commands:\n\n'
      '1. /subscribe - subscribe to mailing\n'
      '2. /unsubscribe - unsubscribe to mailing\n'
      '3. /set_time - set mailing time\n'
      '4. /set_site - set site\n'
      '5. /back - go back\n'
      '6. /help - help';

  static const String subscribeSuccess = 'Successfully subscribed to mailing';
  static const String unsubscribeSuccess =
      'Successfully unsubscribed from mailing';

  static const String subscribeError =
      'You are already un/subscribed to mailing';

  static const String pressBack = 'Back button to return to main menu';

  static const String pleasePressBack = 'Please send url or press /back';

  static const String setSiteSuccess = 'Successfully set site';

  static const String setSiteError = 'Error setting site';
}
