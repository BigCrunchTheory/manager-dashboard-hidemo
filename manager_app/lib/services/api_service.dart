import 'dart:convert';
import 'package:http/http.dart' as http;

// Note: when running on Android emulator, use 10.0.2.2 to reach host machine.
const _base = String.fromEnvironment('API_BASE', defaultValue: 'http://10.0.2.2:4000');

class SummaryResponse {
  final int averageLocationOnline;
  final int totalLocationsCount;

  SummaryResponse({required this.averageLocationOnline, required this.totalLocationsCount});

  factory SummaryResponse.fromJson(Map<String, dynamic> j) => SummaryResponse(
        averageLocationOnline: j['averageLocationOnline'] as int,
        totalLocationsCount: j['totalLocationsCount'] as int,
      );
}

class StationInfo {
  final String cabinetId;
  final int currentOnlineStatus;
  final int thirtyDaysOnlinePercentage;
  final int onlinePercentageSinceInstallation;

  StationInfo({required this.cabinetId, required this.currentOnlineStatus, required this.thirtyDaysOnlinePercentage, required this.onlinePercentageSinceInstallation});

  factory StationInfo.fromJson(Map<String, dynamic> j) => StationInfo(
        cabinetId: j['cabinetId'] as String,
        currentOnlineStatus: j['currentOnlineStatus'] as int,
        thirtyDaysOnlinePercentage: (j['thirtyDaysOnlinePercentage'] as num).toInt(),
        onlinePercentageSinceInstallation: (j['onlinePercentageSinceInstallation'] as num).toInt(),
      );
}

class LocationCard {
  final String locationId;
  final List<StationInfo> stationsInfo;
  final String address;
  final String locationNumber;
  final double totalRevenue;
  final String shopStart;
  final String shopEnd;
  final String locationType;
  final bool hasCompetitors;
  final bool isGoodVisibility;
  final String area;
  final int taughtStaffCount;
  final String locationCategory;
  final String establishmentNumber;

  LocationCard({required this.locationId, required this.stationsInfo, required this.address, required this.locationNumber, required this.totalRevenue, required this.shopStart, required this.shopEnd, required this.locationType, required this.hasCompetitors, required this.isGoodVisibility, required this.area, required this.taughtStaffCount, required this.locationCategory, required this.establishmentNumber});

  factory LocationCard.fromJson(Map<String, dynamic> j) => LocationCard(
        locationId: j['locationId'] as String,
        stationsInfo: (j['stationsInfo'] as List<dynamic>).map((e) => StationInfo.fromJson(e as Map<String, dynamic>)).toList(),
        address: j['address'] as String,
        locationNumber: j['locationNumber'] as String,
        totalRevenue: (j['totalRevenue'] as num).toDouble(),
        shopStart: j['shopStart'] as String,
        shopEnd: j['shopEnd'] as String,
        locationType: j['locationType'] as String,
        hasCompetitors: j['hasCompetitors'] as bool,
        isGoodVisibility: j['isGoodVisibility'] as bool,
        area: j['area'] as String,
        taughtStaffCount: (j['taughtStaffCount'] as num).toInt(),
        locationCategory: j['locationCategory'] as String,
        establishmentNumber: j['establishmentNumber'] as String,
      );
}

class ApiService {
  final http.Client client;
  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<SummaryResponse> fetchSummary({String? preset, String? from, String? to}) async {
    final uri = Uri.parse('$_base/api/v1/manager/locations').replace(queryParameters: {
      if (preset != null) 'preset': preset,
      if (from != null) 'from': from,
      if (to != null) 'to': to,
    });

    final resp = await client.get(uri);
    if (resp.statusCode != 200) throw Exception('Failed to fetch summary');
    final j = jsonDecode(resp.body) as Map<String, dynamic>;
    return SummaryResponse.fromJson(j);
  }

  Future<List<LocationCard>> fetchLocationCards() async {
    final uri = Uri.parse('$_base/api/v1/manager/locations/cards');
    final resp = await client.get(uri);
    if (resp.statusCode != 200) throw Exception('Failed to fetch cards');
    final list = jsonDecode(resp.body) as List<dynamic>;
    return list.map((e) => LocationCard.fromJson(e as Map<String, dynamic>)).toList();
  }
}
