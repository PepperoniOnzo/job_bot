import 'package:job_bot/data/user_data.dart';
import 'package:job_bot/services/data_manager.dart';

void main() {
  String path = 'test/mocks/data.json';
  DataManager data = DataManager(path: path);
  data.users.add(UserData.fromJson({
    'id': 1,
    'subscribedTimes': ['morning', 'evening'],
    'links': [
      {
        'link': 'link',
        'siteType': 'dou',
        'parsed': [
          {
            'title': 'title',
            'link': 'link',
          }
        ],
      }
    ],
  }));

  data.save(path: path);
}
