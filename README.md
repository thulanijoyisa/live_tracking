# Location Tracking App

This Flutter app tracks the user's live location and summarizes time spent in predefined and custom geo-fenced locations.

## Features

- Clock In/Out to start/stop tracking
- Background location updates using `background_location`
- Real-time time tracking in:
  - Predefined zones (Home, Office)
  - Custom user-defined zones
  - "Traveling" state outside any zone
- Daily summary screen with persistent history (via Hive)
- Export data as:
  - CSV
  - JSON
- Manage custom geo-fences with live location capture

## Dependencies

- [provider](https://pub.dev/packages/provider)
- [background_location](https://pub.dev/packages/background_location)
- [geolocator](https://pub.dev/packages/geolocator)
- [hive](https://pub.dev/packages/hive) + [hive_flutter](https://pub.dev/packages/hive_flutter)
- [path_provider](https://pub.dev/packages/path_provider)
- [csv](https://pub.dev/packages/csv)
- [share_plus](https://pub.dev/packages/share_plus)

## Running the App

```bash
flutter pub get
flutter run
