import 'package:hive/hive.dart';


part 'daily_summary.g.dart';

@HiveType(typeId: 0)
class DailySummary extends HiveObject {
  @HiveField(0)
  int homeMillis;

  @HiveField(1)
  int officeMillis;

  @HiveField(2)
  int travelingMillis;

  DailySummary({
    this.homeMillis = 0,
    this.officeMillis = 0,
    this.travelingMillis = 0,
  });

  void addTo(String location, Duration duration) {
    switch (location) {
      case 'Home':
        homeMillis += duration.inMilliseconds;
        break;
      case 'Office':
        officeMillis += duration.inMilliseconds;
        break;
      case 'Traveling':
        travelingMillis += duration.inMilliseconds;
        break;
    }
  }

  String _format(int millis) {
    final d = Duration(milliseconds: millis);
    return '${d.inHours}h ${d.inMinutes.remainder(60)}m ${d.inSeconds.remainder(60)}s';
  }

  @override
  String toString() {
    return 'Home: ${_format(homeMillis)}\nOffice: ${_format(officeMillis)}\nTraveling: ${_format(travelingMillis)}';
  }
}
