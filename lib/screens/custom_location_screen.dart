import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import '../models/custom_location.dart';

class CustomLocationScreen extends StatefulWidget {
  const CustomLocationScreen({super.key});

  @override
  State<CustomLocationScreen> createState() => _CustomLocationScreenState();
}

class _CustomLocationScreenState extends State<CustomLocationScreen> {
  Box<CustomLocation>? locationBox;  // Make nullable instead of late

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    try {
    final box = await Hive.openBox<CustomLocation>('custom_locations');
    setState(() => locationBox = box);
    } catch (e) {
      // Handle error if needed
      debugPrint("Error opening Hive box: $e");
    }
  }

  Future<void> _addCurrentLocation() async {
    if (locationBox == null) return;  // Guard against null box

    final nameController = TextEditingController();
    
  try {
    final position = await Geolocator.getCurrentPosition();

    if (!mounted) return; // Ensures the widget is still in the tree

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Name this location"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: "Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final custom = CustomLocation(
                  label: name,
                  latitude: position.latitude,
                  longitude: position.longitude,
                );
                locationBox!.add(custom);
                setState(() {});
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  } catch (e) {
    debugPrint("Error retrieving location: $e");
  } finally {
    nameController.dispose();
  }
}

void _delete(int index) {
  locationBox?.deleteAt(index);
  setState(() {});
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Custom Geo-fences")),
      body: locationBox == null 
          ? const Center(child: CircularProgressIndicator())
          : _buildLocationList(),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_location_alt),
        label: const Text("Add Current Location"),
        onPressed: locationBox == null ? null : _addCurrentLocation,
      ),
    );
  }

  Widget _buildLocationList() {
    final items = locationBox!.values.toList();
    
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, index) {
        final loc = items[index];
        return ListTile(
          title: Text(loc.label),
          subtitle: Text("Lat: ${loc.latitude}, Lng: ${loc.longitude}"),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _delete(index),
          ),
        );
      },
    );
  }
}