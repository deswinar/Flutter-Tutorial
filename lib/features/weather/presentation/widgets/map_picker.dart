import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tutorial_app/features/weather/weather.dart'; // Ensure this contains the WeatherService class
import 'package:tutorial_app/injections/service_locator.dart'; // Ensure proper setup for dependency injection

class MapPicker extends StatefulWidget {
  final LatLng initialLocation;

  const MapPicker({
    Key? key,
    required this.initialLocation,
  }) : super(key: key);

  @override
  _MapPickerState createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late LatLng selectedLocation;
  String? currentCity = "Fetching city...";
  String? currentCountry;
  List<dynamic> searchResults = [];

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.initialLocation;
    _fetchCityDetails(widget.initialLocation);
  }

  Future<void> _fetchSearchResults(String city) async {
    try {
      final results = await sl<WeatherService>().getCoordinatesFromCity(city);
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  Future<void> _fetchCityDetails(LatLng location) async {
    try {
      final cityData = await sl<WeatherService>().getCityFromCoordinates(
        location.latitude,
        location.longitude,
      );
      setState(() {
        currentCity = cityData['address']['town']?.toString() ??
            cityData['address']['city']?.toString() ??
            cityData['address']['village']?.toString() ??
            cityData['address']['state']?.toString() ??
            'Unknown location';

        currentCountry =
            cityData['address']['country']?.toString() ?? "Unknown Country";
      });
    } catch (error) {
      setState(() {
        currentCity = "Error fetching city";
        currentCountry = null;
      });
    }
  }

  void _selectLocation(Map<String, dynamic> location) async {
    final GoogleMapController controller = await _controller.future;

    setState(() {
      selectedLocation = LatLng(
        double.parse(location['lat'].toString()),
        double.parse(location['lon'].toString()),
      );
      searchResults.clear(); // Hide the list after selection
    });

    controller.animateCamera(
      CameraUpdate.newLatLng(selectedLocation),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: selectedLocation,
                zoom: 12,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onCameraMove: (CameraPosition position) {
                // Update the marker's position when the camera moves
                setState(() {
                  selectedLocation = position.target;
                });
              },
              onCameraIdle: () async {
                await _fetchCityDetails(selectedLocation);
              },
              markers: {
                Marker(
                  position: selectedLocation,
                  draggable: true,
                  markerId: MarkerId('Marker'),
                  onDragEnd: (LatLng newPosition) async {
                    await _fetchCityDetails(newPosition);
                    setState(() {
                      selectedLocation = newPosition;
                    });
                  },
                ),
              },
            ),
            Positioned(
              top: 10,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.black54),
                        hintText: "Search here...",
                        hintStyle: const TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onSubmitted: (value) {
                        _fetchSearchResults(value);
                      },
                    ),
                  ),
                  if (searchResults.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: Card(
                        elevation: 4,
                        child: ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final result = searchResults[index];
                            return ListTile(
                              title: Text(
                                result['display_name'].toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                _selectLocation(result as Map<String, dynamic>);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentCity ?? "Fetching city...",
                              style: const TextStyle(fontSize: 18),
                            ),
                            if (currentCountry != null)
                              Text(
                                currentCountry!,
                                style: const TextStyle(fontSize: 14),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, selectedLocation);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 6,
                      ),
                    ),
                    child: const Text(
                      "CONFIRM",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
