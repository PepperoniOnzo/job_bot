import 'dart:convert';
import 'dart:io';

import 'package:job_bot/constants/configuration.dart';
import 'package:job_bot/data/user_data.dart';

class DataManager {
  List<UserData> users = [];

  DataManager() {
    load();
  }

  /// Load the data by the path [Configuration.saveDataPath]
  load() async {
    if (File(Configuration.saveDataPath).existsSync()) {
      final json =
          jsonDecode(await File(Configuration.saveDataPath).readAsString());
      users = json['users'].map<UserData>((e) => UserData.fromJson(e)).toList();
    } else {
      File(Configuration.saveDataPath).createSync();
      File file = File(Configuration.saveDataPath);
      file.writeAsStringSync(jsonEncode(toJson()));
      users = [];
    }
  }

  /// Save the data by the path [Configuration.saveDataPath]
  save() async {
    await File(Configuration.saveDataPath).writeAsString(jsonEncode(toJson()));
  }

  /// Creates a [Map] from a [DataManager] object
  Map<String, dynamic> toJson() => {
        'users': users.map((e) => e.toJson()).toList(),
      };
}
