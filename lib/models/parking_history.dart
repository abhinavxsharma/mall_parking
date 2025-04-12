import 'package:flutter/material.dart';
import 'mall_location.dart';

class ParkingHistory {
  final String id;
  final String slotId;
  final DateTime entryTime;
  final DateTime? exitTime;
  final double? cost;
  final MallLocation? mallLocation;
  final String vehicleNumber;

  ParkingHistory({
    required this.id,
    required this.slotId,
    required this.entryTime,
    this.exitTime,
    this.cost,
    this.mallLocation,
    required this.vehicleNumber,
  });

  String get duration {
    if (exitTime == null) return 'Currently Parked';
    final difference = exitTime!.difference(entryTime);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    return '$hours hours ${minutes} minutes';
  }

  String get formattedEntryTime => 
      '${entryTime.day}/${entryTime.month}/${entryTime.year} ${entryTime.hour}:${entryTime.minute.toString().padLeft(2, '0')}';

  String get formattedExitTime => exitTime == null ? 'Not exited yet' :
      '${exitTime!.day}/${exitTime!.month}/${exitTime!.year} ${exitTime!.hour}:${exitTime!.minute.toString().padLeft(2, '0')}';

  String get formattedCost => cost == null ? 'Pending' : '₹${cost!.toStringAsFixed(2)}';
}