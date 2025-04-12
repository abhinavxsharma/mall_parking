import 'dart:math';
import 'mall_location.dart';

enum ParkingType { vip, public }

class ParkingSlot {
  final String id;
  bool isOccupied;
  String? carNumber;
  DateTime? entryTime;
  DateTime? exitTime;
  DateTime? paymentTime;
  double? paymentAmount;
  final double? latitude;
  final double? longitude;
  final ParkingType type;
  final double hourlyRate;
  final String currency;
  final MallLocation? mallLocation;

  String get formattedEntryTime {
    if (entryTime == null) return 'Not available';
    return '${entryTime!.hour.toString().padLeft(2, '0')}:${entryTime!.minute.toString().padLeft(2, '0')} ${entryTime!.day}/${entryTime!.month}/${entryTime!.year}';
  }

  String get formattedExitTime {
    if (exitTime == null) return 'Not available';
    return '${exitTime!.hour.toString().padLeft(2, '0')}:${exitTime!.minute.toString().padLeft(2, '0')} ${exitTime!.day}/${exitTime!.month}/${exitTime!.year}';
  }

  ParkingSlot({
    required this.id,
    this.isOccupied = false,
    this.carNumber,
    this.entryTime,
    this.exitTime,
    this.paymentTime,
    this.paymentAmount,
    this.latitude,
    this.longitude,
    this.type = ParkingType.public,
    this.hourlyRate = 50.0,
    this.currency = '₹',
    this.mallLocation,
  });

  factory ParkingSlot.fromJson(Map<String, dynamic> json) {
    return ParkingSlot(
      id: json['id'],
      isOccupied: json['isOccupied'] ?? false,
      carNumber: json['carNumber'],
      entryTime: json['entryTime'] != null
          ? DateTime.parse(json['entryTime'])
          : null,
      exitTime: json['exitTime'] != null
          ? DateTime.parse(json['exitTime'])
          : null,
      paymentTime: json['paymentTime'] != null
          ? DateTime.parse(json['paymentTime'])
          : null,
      paymentAmount: json['paymentAmount']?.toDouble(),
      latitude: json['latitude'],
      longitude: json['longitude'],
      type: json['type'] != null
          ? ParkingType.values.firstWhere(
              (e) => e.toString() == 'ParkingType.${json['type']}',
              orElse: () => ParkingType.public)
          : ParkingType.public,
    );
  }

  double? getDistanceFromEntrance(double entranceLat, double entranceLong) {
    if (latitude == null || longitude == null) return null;
    // Calculate approximate distance using the Haversine formula
    const earthRadius = 6371000; // Earth's radius in meters
    final dLat = (latitude! - entranceLat) * (pi / 180);
    final dLon = (longitude! - entranceLong) * (pi / 180);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(entranceLat * (pi / 180)) *
            cos(latitude! * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isOccupied': isOccupied,
      'carNumber': carNumber,
      'entryTime': entryTime?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'type': type.toString().split('.').last,
      'hourlyRate': hourlyRate,
      'currency': currency,
    };
  }
}