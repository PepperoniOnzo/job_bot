import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:job_bot/data/parsed_data.dart';
import 'package:job_bot/enums/site_type.dart';

class SiteParser {
  /// Returns a document from the specified url
  Future<Document?> getDocument(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      return parse(response.body);
    } catch (e) {
      return null;
    }
  }

  /// Depending on the site type, the method will return a list of parsed data
  Future<List<ParsedData>> getSite(String link, SiteType siteType) async {
    switch (siteType) {
      case SiteType.djinni:
        {
          Document? document = await getDocument(link);
          if (document == null) return [];
          List<String> titles = document
              .getElementsByClassName('profile')
              .map((e) => e.text.trim())
              .toList();

          List<String?> links = document
              .getElementsByClassName('profile')
              .where((element) => element.attributes.containsKey('href'))
              .map((e) => 'https://djinni.co/${e.attributes['href']!}')
              .toList();

          if (titles.length == links.length) {
            List<ParsedData> parsedData = [];
            for (int i = 0; i < titles.length; i++) {
              parsedData.add(ParsedData(titles[i], links[i]!));
            }
            return parsedData;
          } else {
            return [];
          }
        }
      case SiteType.dou:
        {
          Document? document = await getDocument(link);
          if (document == null) return [];
          List<String> titles = document
              .getElementsByClassName('vt')
              .map((e) => e.text.trim())
              .toList();

          List<String?> links = document
              .getElementsByClassName('vt')
              .where((element) => element.attributes.containsKey('href'))
              .map((e) => e.attributes['href']!)
              .toList();

          if (titles.length == links.length) {
            List<ParsedData> parsedData = [];
            for (int i = 0; i < titles.length; i++) {
              parsedData.add(ParsedData(titles[i], links[i]!));
            }
            return parsedData;
          } else {
            return [];
          }
        }
      default:
        return [];
    }
  }
}
