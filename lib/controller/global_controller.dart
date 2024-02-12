import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

class GlobalController extends GetxController {
  //create various varibles
  final RxBool _isLoading = true.obs;
  final RxDouble _lattitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;

  RxBool checkLoading() => _isLoading;
  RxDouble getLattitude() => _lattitude;
  RxDouble getLongitude() => _longitude;

  @override
  void onInit() {
    if (_isLoading.isTrue) {
      getLocation();
    }
    super.onInit();
  }

  getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;
    Geolocator.isLocationServiceEnabled();

    if (isServiceEnabled? == false) {
      return Future.error("Location Not enabled");
    }
    //status of Permission

    locationPermission = Geolocator.checkPermission() as LocationPermission;

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error("Location Permission denied forever");
    }

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error("Location sentence is denied");
      }
    }

    //getting the current position
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      //update our lattitude and longitude
      _lattitude.value = value.latitude;
      _longitude.value = value.longitude;
      _isLoading.value = false;
    });
  }
}
