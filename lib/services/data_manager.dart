import 'dart:convert';
import 'dart:io';

import 'package:job_bot/constants/configuration.dart';
import 'package:job_bot/data/user_data.dart';

class DataManager {
  List<UserData> users = [];

  DataManager({String path = Configuration.saveDataPath}) {
    load(path: path);
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
    File(path).writeAsStringSync(jsonEncode(toJson()));
  }

  /// Creates a [Map] from a [DataManager] object
  Map<String, dynamic> toJson() => {
        'users': users.map((e) => e.toJson()).toList(),
      };
}
