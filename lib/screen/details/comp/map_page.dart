
import 'package:firebase/screen/details/comp/sales_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import 'package:geocoding/geocoding.dart';

import '../../home_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  String currentCity = '';
  late Position currentPosition;
  Set<Marker> markers = {};
  int _selectedIndex = 2;
  int selectedShop = -1;
  Marker? selectedMarker;

  final List<String> stores = ['ATБ', 'MegaMarket', 'Novus', 'Fozzy'];
  final redCircleMarker = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  final placesApiClient = GoogleMapsPlaces(apiKey: 'AIzaSyAn39dBSNXB8hcHBocoSIaU76eVMPkOc50');

  List<StoreInfo> storeInfos = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      if (index == 2) {
      } else if (index == 0) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
      } else if (index == 1){
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SalesPage(),
        ));
      }
    }
  }

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Разрешение на доступ к местоположению отклонено
    } else if (permission == LocationPermission.whileInUse) {
      // Разрешение на доступ к местоположению предоставлено только во время использования приложения
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await _getCityName(currentPosition.latitude, currentPosition.longitude);
      setState(() {
        markers.add(Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(currentPosition.latitude, currentPosition.longitude),
          icon: redCircleMarker,
          infoWindow: InfoWindow(title: 'Current Location', snippet: 'Your location'),
        ));
        stores[0] = 'ATБ $currentCity';
        stores[1] = 'MegaMarket $currentCity';
        stores[2] = 'Novus $currentCity';
        stores[3] = 'Fozzy $currentCity';
      });
      _addMarkers();
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 15)));
    } else if (permission == LocationPermission.always) {
      // Разрешение на доступ к местоположению предоставлено всегда
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        markers.add(Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(currentPosition.latitude, currentPosition.longitude),
          icon: redCircleMarker,
          infoWindow: InfoWindow(title: 'Current Location', snippet: 'Your location'),
        ));
      });
      _addMarkers();
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 15)));
    }
  }
  Future<void> _getCityName(double latitude, double longitude) async {
    final List<Placemark> placemarks =
    await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      final Placemark placemark = placemarks.first;
      setState(() {
        currentCity = placemark.locality ?? '';
      });
    }
  }

  void _addMarkers() async {
    for (var store in stores) {
      final response = await placesApiClient.searchByText(store);
      if (response.isOkay) {
        final result = response.results.first;
        final location = result.geometry?.location;
        if (location != null) {
          final distance = await Geolocator.distanceBetween(
            currentPosition.latitude,
            currentPosition.longitude,
            location.lat,
            location.lng,
          );
          final marker = Marker(
            markerId: MarkerId(result.placeId),
            position: LatLng(location.lat, location.lng),
            infoWindow: InfoWindow(
              title: result.name ?? '',
              snippet: '${(distance / 1000).toStringAsFixed(2)} km',
            ),
          );
          setState(() {
            markers.add(marker);
          });
          storeInfos.add(StoreInfo(name: result.name ?? '', distance: distance, marker: marker));
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        backgroundColor: Colors.green, // изменение цвета AppBar
        centerTitle: true, // выравнивание заголовка по центру
        elevation: 0, // удаление тени AppBar
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(50.4501, 30.5234),
                zoom: 15,
              ),
              markers: markers,
              onTap: (position) {
                setState(() {
                  selectedMarker = null;
                });
              },
            ),
          ),
          Container(
            height: 150,
            child: ListView.builder(
              itemCount: storeInfos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(storeInfos[index].name),
                  subtitle: Text('${(storeInfos[index].distance / 1000).toStringAsFixed(2)} km'),
                  onTap: () {
                    final storeInfo = storeInfos[index];
                    final marker = storeInfo.marker;
                    setState(() {
                      selectedMarker = marker;
                    });
                    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                      target: marker.position,
                      zoom: 15,
                    )));
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home ), label: 'Головна'),
          BottomNavigationBarItem(icon: Icon(Icons.percent_rounded), label: 'Знижки'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Мапа'),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        backgroundColor: Colors.green, // изменение цвета BottomNavigationBar
        selectedItemColor: Colors.white, // изменение цвета выбранного элемента
        unselectedItemColor: Colors.black, // изменение цвета не выбранных элементов
      ),
      floatingActionButton: selectedMarker != null ? FloatingActionButton(
        onPressed: () {
          mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: selectedMarker!.position,
            zoom: 15,
          )));
        },
        child: Icon(Icons.location_on),
      ) : null,
    );
  }
}

class StoreInfo {
  final String name;
  final double distance;
  final Marker marker;

  StoreInfo({required this.name, required this.distance, required this.marker});
}
