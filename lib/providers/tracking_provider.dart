import 'package:flutter/foundation.dart';

import '../services/location_service.dart';

class TrackingProvider with ChangeNotifier {
  bool _isTracking = false;

  bool get isTracking => _isTracking;

  void clockIn() async {
    _isTracking = true;
    notifyListeners();
   await LocationService.startTracking(); 
  }

  void clockOut() async {
    _isTracking = false;
    notifyListeners();
    await LocationService.stopTracking();
  }
}
