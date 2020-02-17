import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart' ;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yabo_bank/util/AppConstants.dart';
import 'PlaceDetailWidget.dart';
import 'package:location/location.dart' as LocationManager;
// import 'place_detail.dart';
const kGoogleApiKey = "AIzaSyAdpQ0Hr_uBp8CZzFI9WEAlYRLXJa5ES-0";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
class MapSearch extends StatefulWidget {
  @override
  _MapSearchState createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch> {
  final LatLng _center = const LatLng(-3.9850467, 122.5129742);
  Set<Marker> _markers = {};

  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  List<PlacesSearchResult> places = [];
  bool isLoading = false;
  String errorMessage;

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: homeScaffoldKey,
        appBar: AppBar(
          title: Text('Cari Lokasi'),
          backgroundColor: AppColor.PRIMARY,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                refresh();
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _handlePressButton();
              },
            ),
          ],
        ),
        body: GoogleMap(
          onTap: _onTap,
          markers: _markers,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 13,
          ),
        ),
      ),
    );
  }
  void _onTap(LatLng position) {
    _markers.clear();
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("${position.latitude}, ${position.longitude}"),
          icon: BitmapDescriptor.defaultMarker,
          position: position,
        ),
      );
    });
  }
  void refresh() async {
    final center = await getUserLocation();

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
    setState(() {
      _markers
          .add(Marker(position: center, markerId: MarkerId('currentLocation')));
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    refresh();
  }

  Future<LatLng> getUserLocation() async {
    var currentLocation;
    // final Location location = LocationManager.Location();
    // final Location location = 
    final  location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation.latitude;
      final lng = currentLocation.longitude;
      final center = LatLng(lat, lng);
      return center;
    } catch (e) {
      currentLocation = null;
      return null;
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async {
    try {
      final center = await getUserLocation();
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          strictbounds: center == null ? false : true,
          apiKey: kGoogleApiKey,
          onError: onError,
          mode: Mode.fullscreen,
          language: "en",
          location: center == null
              ? null
              : Location(center.latitude, center.longitude),
          radius: center == null ? null : 10000);

      onSearchSuccess(p.placeId);
    } catch (e) {
      return;
    }
  }

  Future<Null> onSearchSuccess(String placeId) async {
      PlacesDetailsResponse place = await _places.getDetailsByPlaceId(placeId);

      final placeDetail = place.result;
      final location = place.result.geometry.location;
      final lat = location.lat;
      final lng = location.lng;
      final center = LatLng(lat, lng);

      _markers.clear();
      setState(() {
        _markers.add(Marker(position: center, markerId: MarkerId('currentLocation'), infoWindow: InfoWindow( title : "${placeDetail.name} ${placeDetail.formattedAddress}") ) );
      });
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center, zoom: 15.0)));
  }
}
