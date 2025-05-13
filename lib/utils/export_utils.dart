import 'package:hive/hive.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import '../models/daily_summary.dart';

class ExportUtils {
  static Future<String> exportCSV() async {
    final box = await Hive.openBox<DailySummary>('summaries');
    List<List<String>> rows = [
      ["Date", "Home", "Office", "Traveling"],
    ];

    for (var key in box.keys) {
      final s = box.get(key)!;
      rows.add([
        key.toString(),
        _format(s.homeMillis),
        _format(s.officeMillis),
        _format(s.travelingMillis),
      ]);
    }

    return const ListToCsvConverter().convert(rows);
  }

  static Future<String> exportJSON() async {
    final box = await Hive.openBox<DailySummary>('summaries');
    final map = {
      for (var key in box.keys)
        key.toString(): {
          "Home": _format(box.get(key)!.homeMillis),
          "Office": _format(box.get(key)!.officeMillis),
          "Traveling": _format(box.get(key)!.travelingMillis),
        }
    };
    return const JsonEncoder.withIndent("  ").convert(map);
  }

  static String _format(int millis) {
    final d = Duration(milliseconds: millis);
    return '${d.inHours}h ${d.inMinutes.remainder(60)}m ${d.inSeconds.remainder(60)}s';
  }
}
