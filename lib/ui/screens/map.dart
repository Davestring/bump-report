import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:bump_report/models/index.dart' show Bump;
import 'package:bump_report/ui/pages/index.dart' show Report;
import 'package:bump_report/ui/widgets/index.dart' show RectButton;

class MapScreen extends StatelessWidget {
  static const String routeName = '/map';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Bump> _transformResponse(List<DocumentSnapshot> data) {
    return data
        .map((DocumentSnapshot item) => Bump.fromDocument(item))
        .where((Bump item) => item.bumpStatus == 0 || item.bumpStatus == 1)
        .toList();
  }

  Set<Marker> _getMarkers(List<Bump> bumps) {
    final Map<String, Marker> markers = <String, Marker>{};

    for (final Bump item in bumps) {
      markers[item.bumpId] = Marker(
        markerId: MarkerId(item.bumpId),
        position: LatLng(
          item.bumpCoords.latitude,
          item.bumpCoords.longitude,
        ),
      );
    }

    return markers.values.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      body: StreamBuilder<dynamic>(
        stream: FirebaseFirestore.instance.collection('bump').snapshots(),
        builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              height: MediaQuery.of(ctx).size.height,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey[600]),
              ),
            );
          }

          final List<Bump> bumps = _transformResponse(
            snapshot.data.documents as List<DocumentSnapshot>,
          );

          return BumpsMap(
            markers: _getMarkers(bumps),
            scaffoldKey: _scaffoldKey,
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

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });

    rootBundle.loadString('assets/map-style.json').then((String data) {
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
