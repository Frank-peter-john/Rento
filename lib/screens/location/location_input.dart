import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rento/screens/location/map_screen.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/small_text.dart';
import '../../utils/dimensions.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  const LocationInput({super.key, required this.onSelectPlace});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String latitude = '';
  String longitude = '';
  String place = '';

  // This method gets the user's current location.
  Future<void> _getUserCurrentLocation() async {
    final locationData = await Location().getLocation();

    widget.onSelectPlace(locationData.latitude, locationData.longitude);

    setState(() {
      latitude = locationData.latitude.toString();
      longitude = locationData.longitude.toString();
    });
  }

//This method gets the location from the map.
  Future<void> _selectOnMap() async {
    final LatLng? selectedLocation =
        await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return const MapScreen(
        isSelecting: true,
      );
    }));

    if (selectedLocation == null) {
      return;
    }
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
    setState(() {
      latitude = selectedLocation.longitude.toString();
      longitude = selectedLocation.longitude.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(Dimensions.height20),
      height: Dimensions.height30 * 6,
      decoration: BoxDecoration(
        border: Border.all(color: darkSearchBarColor),
        borderRadius: BorderRadius.circular(Dimensions.radius20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _getUserCurrentLocation,
                child: Container(
                  decoration: const BoxDecoration(color: greyColor),
                  child: Row(
                    children: [
                      const Icon(Icons.map_outlined),
                      SizedBox(width: Dimensions.width8),
                      SmallText(text: 'Use current location'),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: _selectOnMap,
                child: Container(
                  decoration: const BoxDecoration(color: greyColor),
                  child: Row(
                    children: [
                      const Icon(Icons.map_outlined),
                      SizedBox(width: Dimensions.width8),
                      SmallText(text: 'Select on map'),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: Dimensions.height20),
          latitude.isEmpty && longitude.isEmpty && place.isEmpty
              ? SmallText(text: 'No location choosen yet.')
              : Column(
                  children: [
                    SmallText(text: 'Latitude: $latitude'),
                    SizedBox(height: Dimensions.height7),
                    SmallText(text: 'Longitude: $longitude'),
                  ],
                )
        ],
      ),
    );
  }
}
