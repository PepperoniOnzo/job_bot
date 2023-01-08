import 'package:job_bot/data/parsed_data.dart';
import 'package:job_bot/enums/site_type.dart';

class LinkData {
  final String link;
  final SiteType siteType;
  List<ParsedData> parsed = [];
  LinkData(this.link, this.siteType, this.parsed);

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
