import '../../../../core/config/maps_config.dart';

class StaticMapHelper {
  StaticMapHelper._();

  static String previewUrl({
    required double latitude,
    required double longitude,
    int width = 640,
    int height = 280,
    int zoom = 15,
  }) {
    final markerColor = '0xF47827';
    return 'https://maps.googleapis.com/maps/api/staticmap'
        '?center=$latitude,$longitude'
        '&zoom=$zoom'
        '&size=${width}x$height'
        '&scale=2'
        '&markers=color:$markerColor%7C$latitude,$longitude'
        '&key=${MapsConfig.googleMapsApiKey}';
  }
}
