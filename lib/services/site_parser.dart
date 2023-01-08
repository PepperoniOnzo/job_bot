import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:job_bot/data/parsed_data.dart';
import 'package:job_bot/enums/site_type.dart';

class SiteParser {
  /// Returns a document from the specified url
  Future<Document> getDocument(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      return parse(response.body);
    } catch (e) {
      return Document();
    }
  }

  /// Depending on the site type, the method will return a list of parsed data
  List<ParsedData> getSite(String link, SiteType siteType) {
    // TODO: implement getSite
    switch (siteType) {
      case SiteType.djinni:
        {
          throw UnimplementedError();
        }
      case SiteType.dou:
        {
          throw UnimplementedError();
        }
      default:
        throw UnimplementedError();
    }
  }
}
