import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:bump_report/ui/widgets/index.dart' show RectButton;

class MapScreen extends StatefulWidget {
  static const String routeName = '/map';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Location _geoLocation = Location();

  GoogleMapController _controller;

  Future<void> _setCurrentLocation() async {
    final LocationData position = await _geoLocation.getLocation();

    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16.0,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });

    rootBundle.loadString('assets/map-style.json').then((String data) {
      _controller.setMapStyle(data);
    });
  }

  @override
  void initState() {
    super.initState();
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
            onMapCreated: _onMapCreated,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: RectButton(
              margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).padding.bottom + 20.0,
                horizontal: 25.0,
              ),
              backgroundColor: Colors.red,
              height: 50.0,
              icon: Icons.my_location,
              iconColor: Colors.white,
              iconSize: 25.0,
              onClick: _setCurrentLocation,
              splashColor: Colors.red[700],
              width: 50.0,
            ),
          ),
        ],
      ),
    );
  }
}
