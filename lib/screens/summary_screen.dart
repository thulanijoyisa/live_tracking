import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/daily_summary.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/export_utils.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Summary")),
      body: FutureBuilder(
        future: Hive.openBox<DailySummary>('summaries'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final box = snapshot.data as Box<DailySummary>;
          final keys = box.keys.toList().reversed;

          if (keys.isEmpty) {
            return const Center(child: Text("No tracking data yet."));
          }

          return ListView.builder(
            itemCount: keys.length,
            itemBuilder: (context, index) {
              final key = keys.elementAt(index);
              final summary = box.get(key)!;

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: const Icon(Icons.date_range),
                  title: Text("Date: $key"),
                  subtitle: Text(summary.toString()),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              final csv = await ExportUtils.exportCSV();
              await Share.share(csv, subject: "Summary CSV");
            },
            heroTag: "csv",
            icon: const Icon(Icons.table_chart),
            label: const Text("Export CSV"),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            onPressed: () async {
              final json = await ExportUtils.exportJSON();
              await Share.share(json, subject: "Summary JSON");
            },
            heroTag: "json",
            icon: const Icon(Icons.code),
            label: const Text("Export JSON"),
          ),
        ],
      ),
    );
  }
}
