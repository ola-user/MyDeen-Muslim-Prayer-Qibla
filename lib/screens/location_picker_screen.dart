import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/prayer_service.dart';

class SelectCityScreen extends StatefulWidget {
  final String currentLocationLabel;

  const SelectCityScreen({super.key, required this.currentLocationLabel});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  final PrayerService _prayerService = PrayerService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  late String _currentLabel;
  String? _selectedCountryCode;
  String? _selectedCountryName;
  List<Map<String, dynamic>> _history = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _isRelocating = false;

  @override
  void initState() {
    super.initState();
    _currentLabel = widget.currentLocationLabel;
    _loadHistory();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final items = await _prayerService.getLocationHistory();
    if (!mounted) return;
    setState(() {
      _history = items;
    });
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _searchCities(query.trim());
    });
  }

  Future<void> _searchCities(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final url = Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search'
        '?name=${Uri.encodeComponent(query)}&count=25&language=en&format=json',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = (data['results'] as List<dynamic>?) ?? [];

        final filtered = results
            .where((item) {
              if (_selectedCountryCode == null) return true;
              return (item['country_code'] ?? '').toString().toUpperCase() ==
                  _selectedCountryCode!.toUpperCase();
            })
            .map((item) {
              final city = item['name'] ?? '';
              final admin = item['admin1'] ?? '';
              final country = item['country'] ?? '';
              return {
                'city': city,
                'admin': admin,
                'country': country,
                'lat': (item['latitude'] as num).toDouble(),
                'lng': (item['longitude'] as num).toDouble(),
              };
            })
            .toList();

        if (!mounted) return;
        setState(() {
          _searchResults = filtered;
          _isSearching = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSearching = false);
    }
  }

  Future<void> _selectCity(Map<String, dynamic> item) async {
    final city = item['city'] as String;
    final country = (item['country'] ?? '') as String;
    final lat = (item['lat'] as num).toDouble();
    final lng = (item['lng'] as num).toDouble();

    await _prayerService.saveLocation(
      lat: lat,
      lng: lng,
      city: city,
      country: country,
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _handleRelocate() async {
    setState(() => _isRelocating = true);
    try {
      final result = await _prayerService.relocateWithGps();
      if (!mounted) return;
      setState(() {
        _currentLabel = result['label'];
        _isRelocating = false;
      });
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isRelocating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not detect GPS on this device. Search a city or tap Country.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _openCountryPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectCountryScreen()),
    );

    if (result is Map && mounted) {
      final selected = Map<String, String>.from(result);
      setState(() {
        _selectedCountryCode = selected['code'];
        _selectedCountryName = selected['name'];
        _searchController.text = selected['capital'] ?? selected['name']!;
      });
      _searchCities(_searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141718),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141718),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: const Text(
          'Select City',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _openCountryPicker,
            icon: const Icon(Icons.public, color: Colors.white, size: 22),
            label: Text(
              _selectedCountryName ?? 'Country',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Search City Input
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF222628),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: _selectedCountryName != null
                      ? 'Search city in $_selectedCountryName'
                      : 'Search city',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search, color: Colors.white38),
                  suffixIcon:
                      _searchController.text.isNotEmpty ||
                          _selectedCountryName != null
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white54),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _selectedCountryCode = null;
                              _selectedCountryName = null;
                              _searchResults = [];
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (_isSearching)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF00B060)),
                ),
              )
            else if (_searchResults.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: _searchResults.length,
                  separatorBuilder: (_, _) =>
                      const Divider(color: Colors.white12, height: 1),
                  itemBuilder: (context, index) {
                    final item = _searchResults[index];
                    final subtitle = [item['admin'], item['country']]
                        .where((s) => s != null && s.toString().isNotEmpty)
                        .join(', ');
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: const Icon(
                        Icons.location_city,
                        color: Color(0xFF00B060),
                      ),
                      title: Text(
                        item['city'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        subtitle,
                        style: const TextStyle(color: Colors.white54),
                      ),
                      onTap: () => _selectCity(item),
                    );
                  },
                ),
              )
            else ...[
              // Current Location Section
              const Text(
                'Current Location',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F2325),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFF00B060),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _currentLabel,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _isRelocating ? null : _handleRelocate,
                    child: _isRelocating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF00B060),
                            ),
                          )
                        : const Text(
                            'Relocate',
                            style: TextStyle(
                              color: Color(0xFF00B060),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),

              // History Location Section
              if (_history.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  'History Location',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _history.map((item) {
                    return GestureDetector(
                      onTap: () => _selectCity(item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F2325),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['label'] ?? item['city'],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _query = '';

  static const List<Map<String, String>> _recommended = [
    {'name': 'Nigeria', 'code': 'NG', 'flag': '🇳🇬', 'capital': 'Lagos'},
    {'name': 'USA', 'code': 'US', 'flag': '🇺🇸', 'capital': 'New York'},
    {'name': 'Saudi Arabia', 'code': 'SA', 'flag': '🇸🇦', 'capital': 'Makkah'},
    {
      'name': 'United Kingdom',
      'code': 'GB',
      'flag': '🇬🇧',
      'capital': 'London',
    },
  ];

  static const List<Map<String, String>> _allCountries = [
    {'name': 'Afghanistan', 'code': 'AF', 'flag': '🇦🇫', 'capital': 'Kabul'},
    {'name': 'Albania', 'code': 'AL', 'flag': '🇦🇱', 'capital': 'Tirana'},
    {'name': 'Algeria', 'code': 'DZ', 'flag': '🇩🇿', 'capital': 'Algiers'},
    {'name': 'Andorra', 'code': 'AD', 'flag': '🇦🇩', 'capital': 'Andorra'},
    {'name': 'Angola', 'code': 'AO', 'flag': '🇦🇴', 'capital': 'Luanda'},
    {
      'name': 'Argentina',
      'code': 'AR',
      'flag': '🇦🇷',
      'capital': 'Buenos Aires',
    },
    {'name': 'Armenia', 'code': 'AM', 'flag': '🇦🇲', 'capital': 'Yerevan'},
    {'name': 'Australia', 'code': 'AU', 'flag': '🇦🇺', 'capital': 'Sydney'},
    {'name': 'Austria', 'code': 'AT', 'flag': '🇦🇹', 'capital': 'Vienna'},
    {'name': 'Azerbaijan', 'code': 'AZ', 'flag': '🇦🇿', 'capital': 'Baku'},
    {'name': 'Bahrain', 'code': 'BH', 'flag': '🇧🇭', 'capital': 'Manama'},
    {'name': 'Bangladesh', 'code': 'BD', 'flag': '🇧🇩', 'capital': 'Dhaka'},
    {'name': 'Belarus', 'code': 'BY', 'flag': '🇧🇾', 'capital': 'Minsk'},
    {'name': 'Belgium', 'code': 'BE', 'flag': '🇧🇪', 'capital': 'Brussels'},
    {'name': 'Benin', 'code': 'BJ', 'flag': '🇧🇯', 'capital': 'Cotonou'},
    {'name': 'Bolivia', 'code': 'BO', 'flag': '🇧🇴', 'capital': 'La Paz'},
    {
      'name': 'Bosnia and Herzegovina',
      'code': 'BA',
      'flag': '🇧🇦',
      'capital': 'Sarajevo',
    },
    {'name': 'Botswana', 'code': 'BW', 'flag': '🇧🇼', 'capital': 'Gaborone'},
    {'name': 'Brazil', 'code': 'BR', 'flag': '🇧🇷', 'capital': 'Sao Paulo'},
    {
      'name': 'Brunei',
      'code': 'BN',
      'flag': '🇧🇳',
      'capital': 'Bandar Seri Begawan',
    },
    {'name': 'Bulgaria', 'code': 'BG', 'flag': '🇧🇬', 'capital': 'Sofia'},
    {
      'name': 'Burkina Faso',
      'code': 'BF',
      'flag': '🇧🇫',
      'capital': 'Ouagadougou',
    },
    {'name': 'Burundi', 'code': 'BI', 'flag': '🇧🇮', 'capital': 'Bujumbura'},
    {'name': 'Cambodia', 'code': 'KH', 'flag': '🇰🇭', 'capital': 'Phnom Penh'},
    {'name': 'Cameroon', 'code': 'CM', 'flag': '🇨🇲', 'capital': 'Douala'},
    {'name': 'Canada', 'code': 'CA', 'flag': '🇨🇦', 'capital': 'Toronto'},
    {
      'name': 'Central African Republic',
      'code': 'CF',
      'flag': '🇨🇫',
      'capital': 'Bangui',
    },
    {'name': 'Chad', 'code': 'TD', 'flag': '🇹🇩', 'capital': 'NDjamena'},
    {'name': 'Chile', 'code': 'CL', 'flag': '🇨🇱', 'capital': 'Santiago'},
    {'name': 'China', 'code': 'CN', 'flag': '🇨🇳', 'capital': 'Beijing'},
    {'name': 'Colombia', 'code': 'CO', 'flag': '🇨🇴', 'capital': 'Bogota'},
    {'name': 'Comoros', 'code': 'KM', 'flag': '🇰🇲', 'capital': 'Moroni'},
    {'name': 'Congo', 'code': 'CG', 'flag': '🇨🇬', 'capital': 'Brazzaville'},
    {'name': 'Costa Rica', 'code': 'CR', 'flag': '🇨🇷', 'capital': 'San Jose'},
    {'name': 'Croatia', 'code': 'HR', 'flag': '🇭🇷', 'capital': 'Zagreb'},
    {'name': 'Cuba', 'code': 'CU', 'flag': '🇨🇺', 'capital': 'Havana'},
    {'name': 'Cyprus', 'code': 'CY', 'flag': '🇨🇾', 'capital': 'Nicosia'},
    {
      'name': 'Czech Republic',
      'code': 'CZ',
      'flag': '🇨🇿',
      'capital': 'Prague',
    },
    {'name': 'Denmark', 'code': 'DK', 'flag': '🇩🇰', 'capital': 'Copenhagen'},
    {'name': 'Djibouti', 'code': 'DJ', 'flag': '🇩🇯', 'capital': 'Djibouti'},
    {
      'name': 'Dominican Republic',
      'code': 'DO',
      'flag': '🇩🇴',
      'capital': 'Santo Domingo',
    },
    {'name': 'DR Congo', 'code': 'CD', 'flag': '🇨🇩', 'capital': 'Kinshasa'},
    {'name': 'Ecuador', 'code': 'EC', 'flag': '🇪🇨', 'capital': 'Quito'},
    {'name': 'Egypt', 'code': 'EG', 'flag': '🇪🇬', 'capital': 'Cairo'},
    {
      'name': 'El Salvador',
      'code': 'SV',
      'flag': '🇸🇻',
      'capital': 'San Salvador',
    },
    {
      'name': 'Equatorial Guinea',
      'code': 'GQ',
      'flag': '🇬🇶',
      'capital': 'Malabo',
    },
    {'name': 'Eritrea', 'code': 'ER', 'flag': '🇪🇷', 'capital': 'Asmara'},
    {'name': 'Estonia', 'code': 'EE', 'flag': '🇪🇪', 'capital': 'Tallinn'},
    {'name': 'Eswatini', 'code': 'SZ', 'flag': '🇸🇿', 'capital': 'Mbabane'},
    {
      'name': 'Ethiopia',
      'code': 'ET',
      'flag': '🇪🇹',
      'capital': 'Addis Ababa',
    },
    {'name': 'Fiji', 'code': 'FJ', 'flag': '🇫🇯', 'capital': 'Suva'},
    {'name': 'Finland', 'code': 'FI', 'flag': '🇫🇮', 'capital': 'Helsinki'},
    {'name': 'France', 'code': 'FR', 'flag': '🇫🇷', 'capital': 'Paris'},
    {'name': 'Gabon', 'code': 'GA', 'flag': '🇬🇦', 'capital': 'Libreville'},
    {'name': 'Gambia', 'code': 'GM', 'flag': '🇬🇲', 'capital': 'Banjul'},
    {'name': 'Georgia', 'code': 'GE', 'flag': '🇬🇪', 'capital': 'Tbilisi'},
    {'name': 'Germany', 'code': 'DE', 'flag': '🇩🇪', 'capital': 'Berlin'},
    {'name': 'Ghana', 'code': 'GH', 'flag': '🇬🇭', 'capital': 'Accra'},
    {'name': 'Greece', 'code': 'GR', 'flag': '🇬🇷', 'capital': 'Athens'},
    {
      'name': 'Guatemala',
      'code': 'GT',
      'flag': '🇬🇹',
      'capital': 'Guatemala City',
    },
    {'name': 'Guinea', 'code': 'GN', 'flag': '🇬🇳', 'capital': 'Conakry'},
    {
      'name': 'Guinea-Bissau',
      'code': 'GW',
      'flag': '🇬🇼',
      'capital': 'Bissau',
    },
    {'name': 'Guyana', 'code': 'GY', 'flag': '🇬🇾', 'capital': 'Georgetown'},
    {
      'name': 'Haiti',
      'code': 'HT',
      'flag': '🇭🇹',
      'capital': 'Port-au-Prince',
    },
    {
      'name': 'Honduras',
      'code': 'HN',
      'flag': '🇭🇳',
      'capital': 'Tegucigalpa',
    },
    {'name': 'Hungary', 'code': 'HU', 'flag': '🇭🇺', 'capital': 'Budapest'},
    {'name': 'Iceland', 'code': 'IS', 'flag': '🇮🇸', 'capital': 'Reykjavik'},
    {'name': 'India', 'code': 'IN', 'flag': '🇮🇳', 'capital': 'New Delhi'},
    {'name': 'Indonesia', 'code': 'ID', 'flag': '🇮🇩', 'capital': 'Jakarta'},
    {'name': 'Iran', 'code': 'IR', 'flag': '🇮🇷', 'capital': 'Tehran'},
    {'name': 'Iraq', 'code': 'IQ', 'flag': '🇮🇶', 'capital': 'Baghdad'},
    {'name': 'Ireland', 'code': 'IE', 'flag': '🇮🇪', 'capital': 'Dublin'},
    {'name': 'Italy', 'code': 'IT', 'flag': '🇮🇹', 'capital': 'Rome'},
    {'name': 'Ivory Coast', 'code': 'CI', 'flag': '🇨🇮', 'capital': 'Abidjan'},
    {'name': 'Jamaica', 'code': 'JM', 'flag': '🇯🇲', 'capital': 'Kingston'},
    {'name': 'Japan', 'code': 'JP', 'flag': '🇯🇵', 'capital': 'Tokyo'},
    {'name': 'Jordan', 'code': 'JO', 'flag': '🇯🇴', 'capital': 'Amman'},
    {'name': 'Kazakhstan', 'code': 'KZ', 'flag': '🇰🇿', 'capital': 'Astana'},
    {'name': 'Kenya', 'code': 'KE', 'flag': '🇰🇪', 'capital': 'Nairobi'},
    {'name': 'Kuwait', 'code': 'KW', 'flag': '🇰🇼', 'capital': 'Kuwait City'},
    {'name': 'Kyrgyzstan', 'code': 'KG', 'flag': '🇰🇬', 'capital': 'Bishkek'},
    {'name': 'Laos', 'code': 'LA', 'flag': '🇱🇦', 'capital': 'Vientiane'},
    {'name': 'Latvia', 'code': 'LV', 'flag': '🇱🇻', 'capital': 'Riga'},
    {'name': 'Lebanon', 'code': 'LB', 'flag': '🇱🇧', 'capital': 'Beirut'},
    {'name': 'Lesotho', 'code': 'LS', 'flag': '🇱🇸', 'capital': 'Maseru'},
    {'name': 'Liberia', 'code': 'LR', 'flag': '🇱🇷', 'capital': 'Monrovia'},
    {'name': 'Libya', 'code': 'LY', 'flag': '🇱🇾', 'capital': 'Tripoli'},
    {'name': 'Lithuania', 'code': 'LT', 'flag': '🇱🇹', 'capital': 'Vilnius'},
    {
      'name': 'Luxembourg',
      'code': 'LU',
      'flag': '🇱🇺',
      'capital': 'Luxembourg',
    },
    {
      'name': 'Madagascar',
      'code': 'MG',
      'flag': '🇲🇬',
      'capital': 'Antananarivo',
    },
    {'name': 'Malawi', 'code': 'MW', 'flag': '🇲🇼', 'capital': 'Lilongwe'},
    {
      'name': 'Malaysia',
      'code': 'MY',
      'flag': '🇲🇾',
      'capital': 'Kuala Lumpur',
    },
    {'name': 'Maldives', 'code': 'MV', 'flag': '🇲🇻', 'capital': 'Male'},
    {'name': 'Mali', 'code': 'ML', 'flag': '🇲🇱', 'capital': 'Bamako'},
    {'name': 'Malta', 'code': 'MT', 'flag': '🇲🇹', 'capital': 'Valletta'},
    {
      'name': 'Mauritania',
      'code': 'MR',
      'flag': '🇲🇷',
      'capital': 'Nouakchott',
    },
    {
      'name': 'Mauritius',
      'code': 'MU',
      'flag': '🇲🇺',
      'capital': 'Port Louis',
    },
    {'name': 'Mexico', 'code': 'MX', 'flag': '🇲🇽', 'capital': 'Mexico City'},
    {'name': 'Moldova', 'code': 'MD', 'flag': '🇲🇩', 'capital': 'Chisinau'},
    {
      'name': 'Mongolia',
      'code': 'MN',
      'flag': '🇲🇳',
      'capital': 'Ulaanbaatar',
    },
    {
      'name': 'Montenegro',
      'code': 'ME',
      'flag': '🇲🇪',
      'capital': 'Podgorica',
    },
    {'name': 'Morocco', 'code': 'MA', 'flag': '🇲🇦', 'capital': 'Casablanca'},
    {'name': 'Mozambique', 'code': 'MZ', 'flag': '🇲🇿', 'capital': 'Maputo'},
    {'name': 'Myanmar', 'code': 'MM', 'flag': '🇲🇲', 'capital': 'Yangon'},
    {'name': 'Namibia', 'code': 'NA', 'flag': '🇳🇦', 'capital': 'Windhoek'},
    {'name': 'Nepal', 'code': 'NP', 'flag': '🇳🇵', 'capital': 'Kathmandu'},
    {
      'name': 'Netherlands',
      'code': 'NL',
      'flag': '🇳🇱',
      'capital': 'Amsterdam',
    },
    {
      'name': 'New Zealand',
      'code': 'NZ',
      'flag': '🇳🇿',
      'capital': 'Auckland',
    },
    {'name': 'Nicaragua', 'code': 'NI', 'flag': '🇳🇮', 'capital': 'Managua'},
    {'name': 'Niger', 'code': 'NE', 'flag': '🇳🇪', 'capital': 'Niamey'},
    {'name': 'Nigeria', 'code': 'NG', 'flag': '🇳🇬', 'capital': 'Lagos'},
    {
      'name': 'North Macedonia',
      'code': 'MK',
      'flag': '🇲🇰',
      'capital': 'Skopje',
    },
    {'name': 'Norway', 'code': 'NO', 'flag': '🇳🇴', 'capital': 'Oslo'},
    {'name': 'Oman', 'code': 'OM', 'flag': '🇴🇲', 'capital': 'Muscat'},
    {'name': 'Pakistan', 'code': 'PK', 'flag': '🇵🇰', 'capital': 'Karachi'},
    {'name': 'Palestine', 'code': 'PS', 'flag': '🇵🇸', 'capital': 'Jerusalem'},
    {'name': 'Panama', 'code': 'PA', 'flag': '🇵🇦', 'capital': 'Panama City'},
    {
      'name': 'Papua New Guinea',
      'code': 'PG',
      'flag': '🇵🇬',
      'capital': 'Port Moresby',
    },
    {'name': 'Paraguay', 'code': 'PY', 'flag': '🇵🇾', 'capital': 'Asuncion'},
    {'name': 'Peru', 'code': 'PE', 'flag': '🇵🇪', 'capital': 'Lima'},
    {'name': 'Philippines', 'code': 'PH', 'flag': '🇵🇭', 'capital': 'Manila'},
    {'name': 'Poland', 'code': 'PL', 'flag': '🇵🇱', 'capital': 'Warsaw'},
    {'name': 'Portugal', 'code': 'PT', 'flag': '🇵🇹', 'capital': 'Lisbon'},
    {'name': 'Qatar', 'code': 'QA', 'flag': '🇶🇦', 'capital': 'Doha'},
    {'name': 'Romania', 'code': 'RO', 'flag': '🇷🇴', 'capital': 'Bucharest'},
    {'name': 'Russia', 'code': 'RU', 'flag': '🇷🇺', 'capital': 'Moscow'},
    {'name': 'Rwanda', 'code': 'RW', 'flag': '🇷🇼', 'capital': 'Kigali'},
    {'name': 'Saudi Arabia', 'code': 'SA', 'flag': '🇸🇦', 'capital': 'Makkah'},
    {'name': 'Senegal', 'code': 'SN', 'flag': '🇸🇳', 'capital': 'Dakar'},
    {'name': 'Serbia', 'code': 'RS', 'flag': '🇷🇸', 'capital': 'Belgrade'},
    {
      'name': 'Sierra Leone',
      'code': 'SL',
      'flag': '🇸🇱',
      'capital': 'Freetown',
    },
    {'name': 'Singapore', 'code': 'SG', 'flag': '🇸🇬', 'capital': 'Singapore'},
    {'name': 'Slovakia', 'code': 'SK', 'flag': '🇸🇰', 'capital': 'Bratislava'},
    {'name': 'Slovenia', 'code': 'SI', 'flag': '🇸🇮', 'capital': 'Ljubljana'},
    {'name': 'Somalia', 'code': 'SO', 'flag': '🇸🇴', 'capital': 'Mogadishu'},
    {
      'name': 'South Africa',
      'code': 'ZA',
      'flag': '🇿🇦',
      'capital': 'Johannesburg',
    },
    {'name': 'South Korea', 'code': 'KR', 'flag': '🇰🇷', 'capital': 'Seoul'},
    {'name': 'South Sudan', 'code': 'SS', 'flag': '🇸🇸', 'capital': 'Juba'},
    {'name': 'Spain', 'code': 'ES', 'flag': '🇪🇸', 'capital': 'Madrid'},
    {'name': 'Sri Lanka', 'code': 'LK', 'flag': '🇱🇰', 'capital': 'Colombo'},
    {'name': 'Sudan', 'code': 'SD', 'flag': '🇸🇩', 'capital': 'Khartoum'},
    {'name': 'Suriname', 'code': 'SR', 'flag': '🇸🇷', 'capital': 'Paramaribo'},
    {'name': 'Sweden', 'code': 'SE', 'flag': '🇸🇪', 'capital': 'Stockholm'},
    {'name': 'Switzerland', 'code': 'CH', 'flag': '🇨🇭', 'capital': 'Zurich'},
    {'name': 'Syria', 'code': 'SY', 'flag': '🇸🇾', 'capital': 'Damascus'},
    {'name': 'Tajikistan', 'code': 'TJ', 'flag': '🇹🇯', 'capital': 'Dushanbe'},
    {
      'name': 'Tanzania',
      'code': 'TZ',
      'flag': '🇹🇿',
      'capital': 'Dar es Salaam',
    },
    {'name': 'Thailand', 'code': 'TH', 'flag': '🇹🇭', 'capital': 'Bangkok'},
    {'name': 'Togo', 'code': 'TG', 'flag': '🇹🇬', 'capital': 'Lome'},
    {
      'name': 'Trinidad and Tobago',
      'code': 'TT',
      'flag': '🇹🇹',
      'capital': 'Port of Spain',
    },
    {'name': 'Tunisia', 'code': 'TN', 'flag': '🇹🇳', 'capital': 'Tunis'},
    {'name': 'Turkey', 'code': 'TR', 'flag': '🇹🇷', 'capital': 'Istanbul'},
    {
      'name': 'Turkmenistan',
      'code': 'TM',
      'flag': '🇹🇲',
      'capital': 'Ashgabat',
    },
    {'name': 'Uganda', 'code': 'UG', 'flag': '🇺🇬', 'capital': 'Kampala'},
    {'name': 'Ukraine', 'code': 'UA', 'flag': '🇺🇦', 'capital': 'Kyiv'},
    {
      'name': 'United Arab Emirates',
      'code': 'AE',
      'flag': '🇦🇪',
      'capital': 'Dubai',
    },
    {
      'name': 'United Kingdom',
      'code': 'GB',
      'flag': '🇬🇧',
      'capital': 'London',
    },
    {'name': 'Uruguay', 'code': 'UY', 'flag': '🇺🇾', 'capital': 'Montevideo'},
    {'name': 'USA', 'code': 'US', 'flag': '🇺🇸', 'capital': 'New York'},
    {'name': 'Uzbekistan', 'code': 'UZ', 'flag': '🇺🇿', 'capital': 'Tashkent'},
    {'name': 'Venezuela', 'code': 'VE', 'flag': '🇻🇪', 'capital': 'Caracas'},
    {'name': 'Vietnam', 'code': 'VN', 'flag': '🇻🇳', 'capital': 'Hanoi'},
    {'name': 'Yemen', 'code': 'YE', 'flag': '🇾🇪', 'capital': 'Sanaa'},
    {'name': 'Zambia', 'code': 'ZM', 'flag': '🇿🇲', 'capital': 'Lusaka'},
    {'name': 'Zimbabwe', 'code': 'ZW', 'flag': '🇿🇼', 'capital': 'Harare'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _allCountries.where((c) {
      return c['name']!.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    final letters = <String>{};
    for (final c in filtered) {
      letters.add(c['name']![0].toUpperCase());
    }
    final sortedLetters = letters.toList()..sort();

    return Scaffold(
      backgroundColor: const Color(0xFF141718),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141718),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _query = val),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: const InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              if (_query.isEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    'Recommended',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ),
                ..._recommended.map((country) => _buildCountryTile(country)),
                const Divider(color: Colors.white12, height: 24),
              ],
              ...sortedLetters.expand((letter) {
                final group = filtered
                    .where((c) => c['name']!.toUpperCase().startsWith(letter))
                    .toList();
                return [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                    child: Text(
                      letter,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...group.map((country) => _buildCountryTile(country)),
                ];
              }),
            ],
          ),
          // Right-side A-Z Index Bar
          if (_query.isEmpty)
            Positioned(
              right: 4,
              top: 40,
              bottom: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: sortedLetters.map((letter) {
                  return GestureDetector(
                    onTap: () {
                      final index = sortedLetters.indexOf(letter);
                      final offset =
                          (index / sortedLetters.length) *
                          _scrollController.position.maxScrollExtent;
                      _scrollController.animateTo(
                        offset,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 1.5,
                        horizontal: 6,
                      ),
                      child: Text(
                        letter,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCountryTile(Map<String, String> country) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Text(
        country['flag'] ?? '',
        style: const TextStyle(fontSize: 24),
      ),
      title: Text(
        country['name'] ?? '',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () => Navigator.pop(context, country),
    );
  }
}
