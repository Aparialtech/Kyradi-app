import '../core/drop_locations.dart';
import 'api_service.dart';

class LocationsService {
  LocationsService._();

  static Future<List<DropLocation>> fetchLocations() async {
    final response = await ApiService.getLocations();
    final list = response['locations'] ?? response['data'];
    if (list is List) {
      return list
          .whereType<Map>()
          .map((raw) => DropLocation.fromJson(Map<String, dynamic>.from(raw)))
          .toList();
    }
    return const [];
  }
}
