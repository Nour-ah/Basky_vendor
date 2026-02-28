// // lib/core/services/location_service.dart
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
//
// class LocationService {
//   static LocationService? _instance;
//   static LocationService get instance => _instance ??= LocationService._();
//   LocationService._();
//
//   Future<String> getCurrentLocation() async {
//     try {
//       // Check if location services are enabled
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         return 'خدمة الموقع غير مفعلة';
//       }
//
//       // Check permissions
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           return 'تم رفض إذن الموقع';
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         return 'إذن الموقع مرفوض نهائياً';
//       }
//
//       // Get current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       // Get address from coordinates
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );
//
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         return '${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}';
//       } else {
//         return 'لا يمكن تحديد العنوان';
//       }
//     } catch (e) {
//       return 'خطأ في تحديد الموقع: $e';
//     }
//   }
//
//   Future<bool> hasLocationPermission() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     return permission == LocationPermission.always ||
//         permission == LocationPermission.whileInUse;
//   }
// }
