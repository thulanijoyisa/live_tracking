import 'package:hive/hive.dart';

part 'custom_location.g.dart';

@HiveType(typeId: 1)
class CustomLocation extends HiveObject {
  @HiveField(0)
  String label;

  @HiveField(1)
  double latitude;

  @HiveField(2)
  double longitude;

  CustomLocation({required this.label, required this.latitude, required this.longitude});
}
