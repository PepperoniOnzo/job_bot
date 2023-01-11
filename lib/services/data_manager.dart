import 'dart:convert';
import 'dart:io';

import 'package:job_bot/constants/configuration.dart';
import 'package:job_bot/data/user_data.dart';
import 'package:job_bot/enums/day_time.dart';
import 'package:job_bot/enums/menu_state.dart';
import 'package:job_bot/enums/site_type.dart';
import 'package:job_bot/services/site_parser.dart';

import '../data/parsed_data.dart';

class DataManager {
  final SiteParser _siteParser = SiteParser();
  List<UserData> users = [];

  DataManager({String path = Configuration.saveDataPath}) {
    load(path: path);
  }

  /// Add mailing time in [UserDate]
  bool addDayTime(DayTime dayTime, int id) =>
      users.firstWhere((element) => element.id == id).addDayTime(dayTime);

  /// Check if user exist
  bool isUserExist(int id) {
    return users.any((element) => element.id == id);
  }

  /// Add new user to [DataManager]
  bool addUser(int id) {
    if (isUserExist(id)) return false;

    users.add(UserData.newUser(id));
    save();
    return true;
  }

  /// Remove user from [DataManager]
  bool removeUser(int id) {
    if (!isUserExist(id)) return false;

    users.removeWhere((element) => element.id == id);
    save();
    return true;
  }

  /// Load the data by the path [Configuration.saveDataPath]
  load({String path = Configuration.saveDataPath}) {
    if (File(path).existsSync()) {
      final json = jsonDecode(File(path).readAsStringSync());
      users = json['users'].map<UserData>((e) => UserData.fromJson(e)).toList();
    } else {
      File(path).createSync();
      File file = File(path);
      file.writeAsStringSync(jsonEncode(toJson()));
      users = [];
    }
  }

  /// Save the data by the path [Configuration.saveDataPath]
  save({String path = Configuration.saveDataPath}) {
    File(path).writeAsString(jsonEncode(toJson()));
  }

  /// Creates a [Map] from a [DataManager] object
  Map<String, dynamic> toJson() => {
        'users': users.map((e) => e.toJson()).toList(),
      };

  /// Set [MenuState] for user
  void setMenuState(MenuState state, int id) =>
      users.firstWhere((element) => element.id == id).setMenuState(state);

  MenuState getMenuState(int id) =>
      users.firstWhere((element) => element.id == id).menuState;

  Future<bool> setSite(String url, int id) async {
    SiteType type = _siteParser.getSiteType(url);
    List<ParsedData> data = await _siteParser.getSite(url, type);

    if (data.isEmpty) return false;

    users.firstWhere((element) => element.id == id).setSite(url, type, data);

    return true;
  }
}
