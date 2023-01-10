import 'dart:io';

import 'package:html/dom.dart';
import 'package:job_bot/data/link_data.dart';
import 'package:job_bot/data/parsed_data.dart';
import 'package:job_bot/data/user_data.dart';
import 'package:job_bot/enums/day_time.dart';
import 'package:job_bot/enums/site_type.dart';
import 'package:job_bot/services/data_manager.dart';
import 'package:job_bot/services/site_parser.dart';
import 'package:job_bot/services/validator.dart';
import 'package:test/test.dart';

import 'package:html/parser.dart';

void main() {
  group('Data tests', () {
    String path = 'test/mocks/data.json';

    setUpAll(() {
      File file = File(path);
      if (file.existsSync()) file.deleteSync();
    });

    test('Parsed data from/to JSON', () {
      ParsedData data = ParsedData.fromJson(
        {
          'title': 'title',
          'link': 'link',
        },
      );

      expect(data.title, 'title');
      expect(data.link, 'link');

      Map<String, dynamic> json = data.toJson();

      expect(json['title'], 'title');
      expect(json['link'], 'link');
    });

    test('Link data from/to JSON', () {
      LinkData data = LinkData.fromJson({
        'link': 'link',
        'siteType': 'dou',
        'parsed': [
          {
            'title': 'title',
            'link': 'link',
          }
        ],
      });

      expect(data.link, 'link');
      expect(data.siteType.toString(), 'dou');
      expect(data.parsed.length, 1);
      expect(data.parsed.first.title, 'title');
      expect(data.parsed.first.link, 'link');

      Map<String, dynamic> json = data.toJson();

      expect(json['link'], 'link');
      expect(json['siteType'], 'dou');
      expect(json['parsed'].length, 1);
      expect(json['parsed'][0], {
        'title': 'title',
        'link': 'link',
      });
    });
    test('User data from/to JSON', () {
      UserData data = UserData.fromJson({
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
        'menuState': 'main'
      });

      expect(data.id, 1);
      expect(data.subscribedTimes.length, 2);
      expect(data.subscribedTimes[0], DayTime.morning);
      expect(data.subscribedTimes[1], DayTime.evening);
      expect(data.links.first.link, 'link');
      expect(data.links.first.siteType, SiteType.dou);
      expect(data.links.first.parsed.first.title, 'title');
      expect(data.links.first.parsed.first.link, 'link');
      expect(data.menuState.toString(), 'main');

      Map<String, dynamic> json = data.toJson();

      expect(json['id'], 1);
      expect(json['subscribedTimes'], ['morning', 'evening']);
      expect(json['links'].length, 1);
      expect(json['links'][0], {
        'link': 'link',
        'siteType': 'dou',
        'parsed': [
          {
            'title': 'title',
            'link': 'link',
          }
        ],
      });
      expect(json['menuState'], 'main');
    });
    test('Data manager file not exist', () {
      DataManager dataManager = DataManager(path: path);
      expect(dataManager.users.length, 0);
    });

    test('Data manager file exist', () {
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
        'menuState': 'main'
      }));

      data.save(path: path);

      DataManager dataManager = DataManager(path: path);

      expect(dataManager.users.length, 1);
      expect(dataManager.users.first.id, 1);
      expect(dataManager.users.first.subscribedTimes.length, 2);
      expect(dataManager.users.first.subscribedTimes[0], DayTime.morning);
      expect(dataManager.users.first.subscribedTimes[1], DayTime.evening);
      expect(dataManager.users.first.links.first.link, 'link');
      expect(dataManager.users.first.links.first.siteType, SiteType.dou);
      expect(dataManager.users.first.links.first.parsed.first.title, 'title');
      expect(dataManager.users.first.links.first.parsed.first.link, 'link');
      expect(dataManager.users.first.menuState.toString(), 'main');
    });
  });

  group('Services', () {
    String pathDjinni = 'test/mocks/djinni.html';
    String pathDou = 'test/mocks/dou.html';
    test('Validator', () {
      expect(
          Validator.validate(
              'https://djinni.co/jobs/keyword-flutter/?exp_level=1y&employment=remote'),
          true);
      expect(
          Validator.validate(
              'https/djinni.co/jobs/keyword-flutter/?exp_level=1y&employment=remote'),
          false);
      expect(Validator.validate('https://djinni.co'), true);
    });
    test('Site parser djinni', () {
      File file = File(pathDjinni);
      String html = file.readAsStringSync();
      Document document = parse(html);

      var tittles = document.getElementsByClassName('profile');
      expect(tittles.length, 7);

      var links = document
          .getElementsByClassName('profile')
          .where((element) => element.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();
      expect(links.length, 7);
    });
    test('Site parser dou', () {
      File file = File(pathDou);
      String html = file.readAsStringSync();
      Document document = parse(html);

      var tittles = document.getElementsByClassName('vt');
      expect(tittles.length, 3);

      var links = document
          .getElementsByClassName('vt')
          .where((element) => element.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();
      expect(links.length, 3);
    });
  });
}
