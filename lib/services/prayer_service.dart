import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PrayerService {
  static const String _latKey = 'selected_lat';
  static const String _lngKey = 'selected_lng';
  static const String _cityKey = 'selected_city';
  static const String _countryKey = 'selected_country';
  static const String _historyKey = 'location_history';

  Future<Map<String, dynamic>> getSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'lat': prefs.getDouble(_latKey),
      'lng': prefs.getDouble(_lngKey),
      'city': prefs.getString(_cityKey),
      'country': prefs.getString(_countryKey),
    };
  }

  Future<List<Map<String, dynamic>>> getLocationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? [];
    return raw
        .map((item) => json.decode(item) as Map<String, dynamic>)
        .toList();
  }

  Future<void> saveLocation({
    required double lat,
    required double lng,
    required String city,
    required String country,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latKey, lat);
    await prefs.setDouble(_lngKey, lng);
    await prefs.setString(_cityKey, city);
    await prefs.setString(_countryKey, country);

    final label = country.isNotEmpty ? '$city, $country' : city;
    final history = await getLocationHistory();
    history.removeWhere((e) => e['label'] == label);
    history.insert(0, {
      'label': label,
      'city': city,
      'country': country,
      'lat': lat,
      'lng': lng,
    });
    if (history.length > 10) {
      history.removeRange(10, history.length);
    }
    await prefs.setStringList(
      _historyKey,
      history.map((e) => json.encode(e)).toList(),
    );
  }

  /// Requests permission, fetches GPS coordinates, and resolves city/country via HTTPS.
  Future<Map<String, dynamic>> relocateWithGps() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied.');
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );

    String city = 'Current Location';
    String country = '';

    try {
      final geoUrl = Uri.parse(
        'https://api.bigdatacloud.net/data/reverse-geocode-client'
        '?latitude=${position.latitude}&longitude=${position.longitude}&localityLanguage=en',
      );
      final geoRes = await http.get(geoUrl);
      if (geoRes.statusCode == 200) {
        final geoData = json.decode(geoRes.body);
        city = (geoData['city'] as String?)?.isNotEmpty == true
            ? geoData['city']
            : ((geoData['locality'] as String?)?.isNotEmpty == true
                  ? geoData['locality']
                  : (geoData['principalSubdivision'] ?? 'Current Location'));
        country = geoData['countryName'] ?? '';
      }
    } catch (_) {}

    await saveLocation(
      lat: position.latitude,
      lng: position.longitude,
      city: city,
      country: country,
    );

    return {
      'lat': position.latitude,
      'lng': position.longitude,
      'city': city,
      'country': country,
      'label': country.isNotEmpty ? '$city, $country' : city,
    };
  }

  Future<Map<String, dynamic>> getPrayerTimesAndLocation() async {
    double lat = 6.5244;
    double lng = 3.3792;
    String displayName = 'Lagos, Nigeria';

    final saved = await getSavedLocation();
    if (saved['lat'] != null && saved['lng'] != null) {
      lat = saved['lat'];
      lng = saved['lng'];
      final city = saved['city'] ?? 'Lagos';
      final country = saved['country'] ?? '';
      displayName = country.isNotEmpty ? '$city, $country' : city;
    } else {
      try {
        final gps = await relocateWithGps();
        lat = gps['lat'];
        lng = gps['lng'];
        displayName = gps['label'];
      } catch (_) {
        // Fallback when laptop/Chrome has no GPS hardware
        await saveLocation(
          lat: lat,
          lng: lng,
          city: 'Lagos',
          country: 'Nigeria',
        );
      }
    }

    final dateNow = DateTime.now();
    final url =
        'https://api.aladhan.com/v1/calendar/${dateNow.year}/${dateNow.month}'
        '?latitude=$lat&longitude=$lng&method=2';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      final monthData = decodedData['data'] as List<dynamic>;

      return {
        'prayerData': monthData[dateNow.day - 1],
        'monthData': monthData,
        'cityName': displayName,
      };
    } else {
      throw Exception('Failed to connect to prayer times server');
    }
  }
}
