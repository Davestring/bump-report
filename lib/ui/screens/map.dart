import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:bump_report/models/index.dart' show Bump;
import 'package:bump_report/ui/pages/index.dart' show Report;
import 'package:bump_report/ui/widgets/index.dart' show Loading;
import 'package:bump_report/ui/widgets/index.dart' show RectButton;

class MapScreen extends StatefulWidget {
  static const String routeName = '/map';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  BitmapDescriptor _reportedIcon;
  BitmapDescriptor _inRepairIcon;

  List<Bump> _transformResponse(List<DocumentSnapshot> data) {
    return data
        .map((DocumentSnapshot item) => Bump.fromDocument(item))
        .where((Bump item) => item.bumpStatus == 0 || item.bumpStatus == 1)
        .toList();
  }

  Set<Marker> _setupMarkers(List<Bump> bumps) {
    final Map<String, Marker> markers = <String, Marker>{};

    for (final Bump item in bumps) {
      markers[item.bumpId] = Marker(
        icon: item.bumpStatus == 0 ? _reportedIcon : _inRepairIcon,
        markerId: MarkerId(item.bumpId),
        position: LatLng(
          item.bumpCoords.latitude,
          item.bumpCoords.longitude,
        ),
      );
    }

    return markers.values.toSet();
  }

  Future<void> _setCustomMarkers() async {
    _reportedIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/reported.png',
    );

    _inRepairIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/in-repair.png',
    );
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
      body: FutureBuilder<dynamic>(
        future: _setCustomMarkers(),
        builder: (BuildContext _, AsyncSnapshot<dynamic> fbSnapshot) {
          if (fbSnapshot.connectionState == ConnectionState.waiting) {
            return const Loading(color: Colors.blueGrey);
          }

          return StreamBuilder<dynamic>(
            stream: FirebaseFirestore.instance.collection('bump').snapshots(),
            builder: (BuildContext _, AsyncSnapshot<dynamic> sbSnapshot) {
              if (sbSnapshot.connectionState == ConnectionState.waiting) {
                return const Loading(color: Colors.blueGrey);
              }

              final List<Bump> bumps = _transformResponse(
                sbSnapshot.data.documents as List<DocumentSnapshot>,
              );

              final Set<Marker> markers = _setupMarkers(bumps);

              return BumpsMap(
                markers: markers,
                scaffoldKey: _scaffoldKey,
              );
            },
          );
        },
      ),
    );
  }
}

class BumpsMap extends StatefulWidget {
  const BumpsMap({
    Key key,
    @required this.markers,
    @required this.scaffoldKey,
  })  : assert(markers != null),
        assert(scaffoldKey != null),
        super(key: key);

  final Set<Marker> markers;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _BumpsMapState createState() => _BumpsMapState();
}

class _BumpsMapState extends State<BumpsMap> {
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

  Future<void> _onMapCreated(GoogleMapController controller) async {
    PermissionStatus permissionGranted;
    bool serviceEnabled;

    serviceEnabled = await _geoLocation.serviceEnabled();
    if (!serviceEnabled) {
      await _geoLocation.requestService();
    }

    permissionGranted = await _geoLocation.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      await _geoLocation.requestPermission();
    }

    setState(() {
      _controller = controller;
    });

    await rootBundle.loadString('assets/map-style.json').then((String data) {
      _controller.setMapStyle(data);
    });
  }

  Future<void> _onCreateReport() async {
    final LocationData position = await _geoLocation.getLocation();

    await showModalBottomSheet<Widget>(
      backgroundColor: Colors.transparent,
      context: widget.scaffoldKey.currentContext,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Report(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          compassEnabled: false,
          initialCameraPosition: const CameraPosition(
            target: LatLng(23.634501, -102.552784),
          ),
          mapType: MapType.normal,
          markers: widget.markers,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          onMapCreated: _onMapCreated,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: RectButton(
            backgroundColor: Colors.blueGrey[600],
            height: 50.0,
            icon: Icons.my_location,
            iconColor: Colors.white,
            iconSize: 25.0,
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).padding.bottom + 35.0,
              horizontal: 25.0,
            ),
            onClick: _setCurrentLocation,
            splashColor: Colors.blueGrey[800],
            width: 50.0,
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: RectButton(
            backgroundColor: Colors.blueGrey[600],
            height: 50.0,
            icon: Icons.report,
            iconColor: Colors.white,
            iconSize: 25.0,
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).padding.bottom + 35.0,
              horizontal: 25.0,
            ),
            onClick: _onCreateReport,
            splashColor: Colors.blueGrey[800],
            width: 50.0,
          ),
        ),
      ],
    );
  }
}
