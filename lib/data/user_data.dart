import 'package:job_bot/data/link_data.dart';
import 'package:job_bot/data/parsed_data.dart';
import 'package:job_bot/enums/day_time.dart';
import 'package:job_bot/enums/menu_state.dart';
import 'package:job_bot/enums/site_type.dart';

class UserData {
  final int id;
  List<DayTime> subscribedTimes = [];
  List<LinkData> links = [];

  MenuState menuState;

  UserData.newUser(this.id, {this.menuState = MenuState.main});
  UserData(this.id, this.subscribedTimes, this.links, this.menuState);

  bool addDayTime(DayTime dayTime) {
    if (subscribedTimes.contains(dayTime)) {
      subscribedTimes.remove(dayTime);
      return false;
    }

    subscribedTimes.add(dayTime);
    return true;
  }

  /// Creates a [UserData] object from a [Map]
  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        json['id'],
        json['subscribedTimes']
            .map<DayTime>((e) =>
                DayTime.values.firstWhere((element) => element.toString() == e))
            .toList(),
        json['links'].map<LinkData>((e) => LinkData.fromJson(e)).toList(),
        MenuState.values
            .firstWhere((element) => element.toString() == json['menuState']),
      );

  /// Creates a [Map] from a [UserData] object
  Map<String, dynamic> toJson() => {
        'id': id,
        'subscribedTimes': subscribedTimes.map((e) => e.toString()).toList(),
        'links': links.map((e) => e.toJson()).toList(),
        'menuState': menuState.toString(),
      };

  /// Set the [MenuState] of the user
  void setMenuState(MenuState state) {
    menuState = state;
  }

  /// Set the [SiteType] of the user
  void setSite(String url, SiteType type, List<ParsedData> data) {
    links.add(LinkData(url, type, data));
  }
}
