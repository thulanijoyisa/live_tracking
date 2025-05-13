import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tracking_provider.dart';
import 'custom_location_screen.dart';
import 'summary_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTracking = context.watch<TrackingProvider>().isTracking;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Tracker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SummaryScreen()),
            ),
          )
        ],
      ),
      body: Center(
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.all(24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isTracking ? Icons.location_on : Icons.location_off,
                  color: isTracking ? Colors.green : Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  isTracking ? "Tracking Active" : "Tracking Inactive",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: isTracking
                      ? null
                      : () => context.read<TrackingProvider>().clockIn(),
                  label: const Text("Clock In"),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 48)),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.stop),
                  onPressed: isTracking
                      ? () {
                          context.read<TrackingProvider>().clockOut();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SummaryScreen()),
                          );
                        }
                      : null,
                  label: const Text("Clock Out"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(150, 48),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.map),
                  label: const Text("Manage Geo-fences"),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CustomLocationScreen()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
