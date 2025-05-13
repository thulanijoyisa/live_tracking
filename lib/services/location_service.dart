import 'dart:async';
import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import '../models/custom_location.dart';
import '../models/geo_location.dart';
import '../models/daily_summary.dart';

class LocationService {
  static final List<GeoLocation> predefinedLocations = [
    GeoLocation(label: 'Home', latitude: 37.7749, longitude: -122.4194),
    GeoLocation(label: 'Office', latitude: 37.7858, longitude: -122.4364),
  ];

  static Future<List<GeoLocation>> getAllLocations() async {
    final customBox = await Hive.openBox<CustomLocation>('custom_locations');
    return [
      ...predefinedLocations,
      ...customBox.values.map((c) => GeoLocation(
          label: c.label, latitude: c.latitude, longitude: c.longitude))
    ];
  }

  static final DailySummary summary = DailySummary();
  static DateTime? _lastUpdate;

  static Future<void> startTracking() async {
    await BackgroundLocation.stopLocationService();
    _lastUpdate = null;

    final box = await Hive.openBox<DailySummary>('summaries');
    final todayKey = DateTime.now().toIso8601String().substring(0, 10);
    await box.put(todayKey, summary);

    await BackgroundLocation.setAndroidNotification(
      title: 'Location Tracking',
      message: 'Tracking in the background',
      icon: '@mipmap/ic_launcher',
    );

    await BackgroundLocation.startLocationService(distanceFilter: 10);

    BackgroundLocation.getLocationUpdates((location) {
      final now = DateTime.now();
      final delta = now.difference(_lastUpdate ?? now);
      _lastUpdate ??= now;

      final currentLat = location.latitude!;
      final currentLng = location.longitude!;

      final activeZones = <String>[];

      for (final geo in predefinedLocations) {
        final distance = Geolocator.distanceBetween(
          currentLat,
          currentLng,
          geo.latitude,
          geo.longitude,
        );

        if (distance <= 50) {
          activeZones.add(geo.label);
        }
      }

      if (activeZones.isEmpty) {
        summary.addTo("Traveling", delta);
      } else {
        for (var zone in activeZones) {
          summary.addTo(zone, delta);
        }
      }

      debugPrint("Updated Summary:\n${summary.toString()}");
    });
  }

  static Future<void> stopTracking() async {
    await BackgroundLocation.stopLocationService();
    _lastUpdate = null;
  }

  static DailySummary getSummary() => summary;
}
