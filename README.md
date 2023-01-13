# Job Bot

![build status](https://github.com/PepperoniOnzo/job_bot/actions/workflows/build.yml/badge.svg)

Telegram bot for job search. Parses job offers from avalaible sites and sends them to the user.

- entrypoint in `bin/`.
- library code in `lib/`.
- unit tests in `test/`.

## Available sites

- [djinni.co](https://djinni.co/)
- [dou.ua](https://dou.ua/)

## Project structure

```text
lib/
|- constants/
|- data/
|- enums/
|- services/
schedule.dart
telegram_bot.dart
```

### `lib/constants/`

Contains constants for the project. Such as: bot reply strings, bot configurations.

### `lib/data/`

Contains models for the project. Such as: `Link data`, `Parsed data`, `User data`.

### `lib/enums/`

Contains enums for the project. Such as: bot states, avalailable sites, day time.

### `lib/services/`

Contains services for the project. Such as: data manager, int to time converter, site parser and url validator.

### `schedule.dart`

Realization of shedule for the bot. Send by stream `StreamController<DayTime>` data which contains current day time.

### `telegram_bot.dart`

Realization of telegram bot. Contains all bot logic. Also has stream `Stream<DayTime>` which receives data from `schedule.dart` and triggers specific actions.
