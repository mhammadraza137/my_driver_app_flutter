class RideRequest {
  String pickupAddress;
  String dropOffAddress;
  String riderName;
  String riderUid;
  double pickupLatitude;
  double pickupLongitude;
  double dropOffLatitude;
  double dropOffLongitude;

  RideRequest(
      {required this.pickupAddress,
      required this.dropOffAddress,
      required this.riderName,
      required this.riderUid,
      required this.pickupLatitude,
      required this.pickupLongitude,
      required this.dropOffLatitude,
      required this.dropOffLongitude});

  static RideRequest getRideRequestFromMap(Map map) {
    return RideRequest(
        pickupAddress: map['pickup_address'],
        dropOffAddress: map['drop_off_address'],
        riderName: map['rider_name'],
        riderUid: map['rider_uid'],
        pickupLatitude: map['pickup']['latitude'],
        pickupLongitude: map['pickup']['longitude'],
        dropOffLatitude: map['drop-off']['latitude'],
        dropOffLongitude: map['drop-off']['longitude']);
  }
}
