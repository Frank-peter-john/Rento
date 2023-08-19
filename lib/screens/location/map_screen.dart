import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/widgets/buttons/multpurpose_button.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final bool isSelecting;
  const MapScreen({
    super.key,
    this.latitude = -6.7862528,
    this.longitude = 39.2265728,
    this.isSelecting = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation; // Declare the LatLng variable as nullable

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.latitude,
                widget.longitude,
              ),
              zoom: 16,
            ),
            onTap: widget.isSelecting ? _selectLocation : null,
            markers: _pickedLocation == null && !widget.isSelecting
                ? {
                    Marker(
                      markerId: const MarkerId('c1'),
                      position: LatLng(widget.latitude, widget.longitude),
                    )
                  }
                : {
                    Marker(
                      markerId: const MarkerId('m1'),
                      position: _pickedLocation!,
                    ),
                  },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: Dimensions.width20,
                    top: Dimensions.height30,
                  ),
                  height: Dimensions.height20 * 1.5,
                  width: Dimensions.width20 * 1.5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius20 / 2.3),
                  ),
                  child: Icon(
                    Icons.close,
                    size: Dimensions.font22,
                    color: isDark ? blackColor : whiteColor,
                  ),
                ),
              ),
              if (widget.isSelecting && _pickedLocation != null)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(_pickedLocation);
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      right: Dimensions.width20,
                      top: Dimensions.height20,
                    ),
                    height: Dimensions.height20 * 1.5,
                    width: Dimensions.width20 * 3,
                    child: const MultipurposeButton(
                      text: 'Done',
                      textColor: whiteColor,
                      backgroundColor: blackColor,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
