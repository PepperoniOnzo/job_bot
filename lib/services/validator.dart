import 'package:job_bot/enums/site_type.dart';

class Validator {
  /// Validate a link
  static bool validate(String link) {
    // Check if valid URL
    if (!Uri.parse(link).isAbsolute) return false;

    // Check if bot support this link
    if (link.contains(SiteType.dou.toString()) ||
        link.contains(SiteType.djinni.toString())) return true;

    return false;
  }
}
