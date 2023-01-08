import 'package:job_bot/data/link_data.dart';
import 'package:job_bot/enums/day_time.dart';

class UserData {
  final int id;
  List<DayTime> subscribedTimes = [];
  List<LinkData> links = [];

  UserData(this.id, this.subscribedTimes, this.links);

  /// Creates a [UserData] object from a [Map]
  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        json['id'],
        json['subscribedTimes']
            .map<DayTime>((e) =>
                DayTime.values.firstWhere((element) => element.toString() == e))
            .toList(),
        json['links'].map<LinkData>((e) => LinkData.fromJson(e)).toList(),
      );

  /// Creates a [Map] from a [UserData] object
  Map<String, dynamic> toJson() => {
        'id': id,
        'subscribedTimes': subscribedTimes.map((e) => e.toString()).toList(),
        'links': links.map((e) => e.toJson()).toList(),
      };
}
