import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class PlacePickerScreen extends StatefulWidget {
  const PlacePickerScreen({super.key});

  @override
  State<PlacePickerScreen> createState() => _PlacePickerScreenState();
}

class _PlacePickerScreenState extends State<PlacePickerScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  LatLng _markerPosition = const LatLng(30.0444, 31.2357);

  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  String _currentAddress = "Loading address...";

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      Position position = await Geolocator.getCurrentPosition();
      _updateMarkerAndCamera(LatLng(position.latitude, position.longitude));
    } catch (e) {
      log("Error getting location: $e");
    }
  }

  Future<void> _updateMarkerAndCamera(LatLng newPosition) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: newPosition, zoom: 16),
      ),
    );

    setState(() {
      _markerPosition = newPosition;
    });

    _getAddressFromLatLng(newPosition.latitude, newPosition.longitude);
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isLoading = true);

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5',
      );
      final response = await http.get(
        url,
        headers: {'User-Agent': 'OrdersApp_Flutter_Client'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _searchResults = json.decode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      setState(() => _currentAddress = "Fetching address...");
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              "${place.street}, ${place.subAdministrativeArea}, ${place.administrativeArea}";
          _currentAddress = _currentAddress
              .replaceAll(RegExp(r'^, |, $'), '')
              .replaceAll(', ,', ',');
        });
      }
    } catch (e) {
      setState(() => _currentAddress = "Unknown location");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخريطة
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _markerPosition,
              zoom: 14,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },

            onTap: (LatLng position) {
              setState(() {
                _markerPosition = position;
              });
              _getAddressFromLatLng(position.latitude, position.longitude);
            },
            markers: {
              Marker(
                markerId: const MarkerId('selected_location'),
                position: _markerPosition,
                draggable: true, // 👈 دي أهم كلمة! بتخلي اليوزر يقدر يسحبه
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),

                // الدالة دي بتتنفذ أول ما اليوزر يسيب الماركر من إيده
                onDragEnd: (LatLng newPosition) {
                  setState(() {
                    _markerPosition = newPosition;
                  });
                  // نجيب العنوان بتاع المكان الجديد اللي اتسحب ليه
                  _getAddressFromLatLng(
                    newPosition.latitude,
                    newPosition.longitude,
                  );
                },
              ),
            },
          ),

          Positioned(
            bottom: 180,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search for a building, street or city...",
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        suffixIcon: _isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () =>
                                    _searchPlaces(_searchController.text),
                              ),
                      ),
                      onSubmitted: _searchPlaces,
                    ),
                  ),
                ),
                if (_searchResults.isNotEmpty)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final place = _searchResults[index];
                          return ListTile(
                            leading: const Icon(
                              Icons.location_city,
                              color: Colors.blue,
                            ),
                            title: Text(
                              place['display_name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              double lat = double.parse(place['lat']);
                              double lon = double.parse(place['lon']);
                              _updateMarkerAndCamera(
                                LatLng(lat, lon),
                              ); // ننقل الماركر والكاميرا لنتيجة البحث
                              setState(() {
                                _searchResults = [];
                                FocusScope.of(context).unfocus();
                              });
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
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.my_location, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _currentAddress,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, {
                      'location': _markerPosition,
                      'address': _currentAddress,
                    });
                  },
                  child: const Text(
                    "Confirm Location",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
