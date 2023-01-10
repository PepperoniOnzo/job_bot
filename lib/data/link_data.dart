import 'package:html/parser.dart';
import 'package:job_bot/data/parsed_data.dart';
import 'package:job_bot/enums/site_type.dart';
import 'package:job_bot/services/site_parser.dart';

class LinkData {
  final String link;
  final SiteType siteType;
  List<ParsedData> parsed = [];
  LinkData(this.link, this.siteType, this.parsed);

  /// Compare data from the same link
  Future<bool> compareData() async {
    SiteParser parser = SiteParser();
    List<ParsedData> newData = await parser.getSite(link, siteType);

    return parsed.length == newData.length &&
        parsed.every((element) => newData.contains(element));
  }

  @override
  toString() async {
    return 'Vacancies on ${siteType.toString()}\n$link\n\n${parsed.map((e) => e.toString()).join('\n\n')}';
  }

  /// Creates a [LinkData] object from a [Map]
  factory LinkData.fromJson(Map<String, dynamic> json) => LinkData(
        json['link'],
        SiteType.values
            .firstWhere((element) => element.toString() == json['siteType']),
        json['parsed'].map<ParsedData>((e) => ParsedData.fromJson(e)).toList(),
      );

  /// Creates a [Map] from a [LinkData] object
  Map<String, dynamic> toJson() => {
        'link': link,
        'siteType': siteType.toString(),
        'parsed': parsed.map((e) => e.toJson()).toList(),
      };
}
