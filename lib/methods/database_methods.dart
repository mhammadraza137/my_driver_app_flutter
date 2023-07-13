
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseMethods{
  static Future<String> saveCarDetails(String model, String number, String color) async{
    String status = 'some error occurred';
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('drivers').child(FirebaseAuth.instance.currentUser!.uid).child('car_details');
    Map carDetailsMap = {
      'car_model' : model,
      'car_number' : number,
      'car_color' : color
    };
    try{
      await databaseReference.set(carDetailsMap);
      status = 'success';
    } catch(e){
      status = e.toString();
    }
    return status;
  }
  static Future<bool> checkDriverHasVehicleData() async{
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('drivers').child(FirebaseAuth.instance.currentUser!.uid).child('car_details');
    DatabaseEvent databaseEvent = await databaseReference.once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;
    if(dataSnapshot.value == null)
      {
        return false;
      }
    else{
      return true;
    }
  }
  static Future<bool> checkUserIsDriver() async{
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('drivers').child(FirebaseAuth.instance.currentUser!.uid);
    DatabaseEvent databaseEvent = await databaseReference.once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;
    if(dataSnapshot.value == null){
      return false;
    }else{
      return true;
    }
  }
}