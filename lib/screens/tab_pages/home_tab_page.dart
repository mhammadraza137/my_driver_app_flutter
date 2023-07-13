import 'dart:async';

import 'package:driver_app/models/ride_request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);
  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController? _newGoogleMapController;
  static const CameraPosition _kLahore =
      CameraPosition(target: LatLng(31.520370, 74.358749), zoom: 14.4746);
  StreamSubscription<Position>? homeTabStreamSubscription;
  Position? currentPosition;
  bool driverAvailable = false;
  DatabaseReference onlineDriverReference = FirebaseDatabase.instance
      .ref()
      .child('active_drivers')
      .child(FirebaseAuth.instance.currentUser!.uid);
  DatabaseReference rideRequestReference = FirebaseDatabase.instance.ref().child('ride requests');
  List<RideRequest> rideRequestList = [];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: _kLahore,
            onMapCreated: (controller) {
              if (!_googleMapController.isCompleted) {
                _googleMapController.complete(controller);
              }
              _newGoogleMapController = controller;
              getCurrentLocation();
            },
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: FloatingActionButton(
                onPressed: () {
                  getCurrentLocation();
                },
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.black,
                ),
              )),
          Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                    onPressed: () async {
                      if (!driverAvailable) {
                        makeDriverOnline();
                      } else {
                        await homeTabStreamSubscription!.cancel();
                        onlineDriverReference.remove();
                        setState(() {
                          driverAvailable = false;
                        });
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            driverAvailable ? Colors.green : Colors.black)),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            driverAvailable ? 'Go offline' : 'Go Online',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const Icon(
                            Icons.online_prediction,
                            size: 26,
                          )
                        ],
                      ),
                    )),
              )),
          Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: driverAvailable
                  ? StreamBuilder(
                      stream: FirebaseDatabase.instance
                          .ref()
                          .child('ride requests')
                          .orderByChild('pickup/latitude')
                          .startAt(currentPosition!.latitude - 0.027027)
                          .endAt(currentPosition!.latitude + 0.027027)
                          .onValue,
                      builder: (context, AsyncSnapshot<DatabaseEvent> event) {
                        if (event.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        DataSnapshot snapshot = event.data!.snapshot;
                        if (snapshot.value != null) {
                          print(' stream value : ${snapshot.value}');
                          List<RideRequest> list = [];
                          rideRequestList.clear();
                          Map map = snapshot.value as Map<dynamic, dynamic>;
                          map.forEach((key, value) {
                            list.add(RideRequest.getRideRequestFromMap(value));
                          });
                          for (RideRequest rideRequest in list) {
                            print(rideRequest);
                            if (rideRequest.pickupLongitude >
                                    currentPosition!.longitude - 0.027027 &&
                                rideRequest.pickupLongitude <
                                    currentPosition!.longitude + 0.027027) {
                              rideRequestList.add(rideRequest);
                            }
                          }
                          print('ride request : $rideRequestList');
                          return Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height * 0.3,
                            padding: const EdgeInsets.all(10),
                            child: ListView.builder(
                              itemCount: rideRequestList.length,
                              itemBuilder: (context, index) => Container(
                                // height: MediaQuery.of(context).size.height*0.2,
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 5,
                                          spreadRadius: 0.5,
                                          offset: Offset(0.7, 0.7))
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Rider  :  ${rideRequestList[index].riderName}'),
                                    Text('Pickup  :  ${rideRequestList[index].pickupAddress}'),
                                    Text('Drop Off  :  ${rideRequestList[index].dropOffAddress}'),
                                    Row(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              rideRequestReference.child(rideRequestList[index].riderUid).update({
                                                'driver_id' : FirebaseAuth.instance.currentUser!.uid
                                              });
                                            },
                                            child: const Text(
                                              'Accept',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        return SizedBox();
                      },
                    )
                  : SizedBox()),
        ],
      ),
    ));
  }

  getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.error('Location permissions are denied');
      }
    } else if (permission == LocationPermission.deniedForever) {
      Future.error('Location permissions are denied forever');
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentPosition = position;
      LatLng latLng = LatLng(position.latitude, position.longitude);
      CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 14);
      _newGoogleMapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  void getLiveLocationUpdates() {
    homeTabStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) async {
      print('${position.latitude}  and  ${position.longitude}');
      await onlineDriverReference.update(
          {'latitude': position.latitude, 'longitude': position.longitude});
      // onlineDriverReference.child('longitude').set(currentPosition!.longitude);
      LatLng latLng = LatLng(position.latitude, position.longitude);
      _newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void makeDriverOnline() {
    if (currentPosition != null) {
      onlineDriverReference.set({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'latitude': currentPosition!.latitude,
        'longitude': currentPosition!.longitude
      });
      setState(() {
        driverAvailable = true;
      });
      getLiveLocationUpdates();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location is not received yet')));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _googleMapController = Completer();
    if (homeTabStreamSubscription != null) {
      homeTabStreamSubscription!.cancel();
    }
  }
}
