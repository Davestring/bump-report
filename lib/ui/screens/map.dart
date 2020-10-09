import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = '/map';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Location _geoLocation = Location();

  GoogleMapController _controller;
  double _bearing, _tilt, _zoom;

  Future<void> _setCurrentLocation() async {
    final LocationData position = await _geoLocation.getLocation();

    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          bearing: _bearing,
          tilt: _tilt,
          zoom: _zoom,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _bearing = 80.0;
    _tilt = 20.0;
    _zoom = 19.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            compassEnabled: false,
            initialCameraPosition: const CameraPosition(
              target: LatLng(23.634501, -102.552784),
            ),
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _controller = controller;
              });
            },
          )
        ],
      ),
    );
  }
}
