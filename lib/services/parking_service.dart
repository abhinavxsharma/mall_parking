import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/parking_slot.dart';
import '../models/parking_history.dart';
import '../models/mall_location.dart';

class ParkingService {
  // Mock mall locations data
  final List<MallLocation> _mallLocations = [
    MallLocation(
      id: 'vr_punjab',
      name: 'VR Punjab',
      address: 'Kharar Landran Rd, Mohali, Punjab',
      latitude: 30.7046,
      longitude: 76.6913,
      totalSlots: 10,
    ),
    MallLocation(
      id: 'elante',
      name: 'Elante Mall',
      address: 'Industrial Area Phase I, Chandigarh',
      latitude: 30.7051,
      longitude: 76.8011,
      totalSlots: 15,
    ),
    MallLocation(
      id: 'north_country',
      name: 'North Country Mall',
      address: 'Mohali, Punjab',
      latitude: 30.7280,
      longitude: 76.7179,
      totalSlots: 12,
    ),
  ];

  // Get list of available mall locations
  List<MallLocation> getMallLocations() {
    return _mallLocations;
  }

  // Get available slots for a specific mall
  Future<List<ParkingSlot>> getAvailableSlots({
    String mallId = 'vr_punjab',
    ParkingType? slotType,
    double? maxPrice,
    bool? showOnlyAvailable,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Get selected mall
    final mall = _mallLocations.firstWhere(
      (mall) => mall.id == mallId,
      orElse: () => _mallLocations.first,
    );

    // Generate all parking slots
    var slots = List.generate(
      mall.totalSlots,
      (index) {
        final isVip = index < (mall.totalSlots ~/ 3); // First third of slots are VIP
        final baseRate = isVip ? 100.0 : 50.0;
        final mallMultiplier = switch(mallId) {
          'elante' => 1.2,
          'north_country' => 0.9,
          _ => 1.0
        };
        final hourlyRate = baseRate * mallMultiplier;
        
        return ParkingSlot(
          id: (index + 1).toString(),
          isOccupied: index < 3, // First 3 slots are occupied
          carNumber: index < 3 ? 'CAR${index + 1}' : null,
          entryTime: index < 3 ? DateTime.now() : null,
          type: isVip ? ParkingType.vip : ParkingType.public,
          hourlyRate: hourlyRate,
          currency: '₹',
          latitude: mall.latitude + (index % 5) * 0.0001, // Mock proximity data
          longitude: mall.longitude + (index % 5) * 0.0001
        );
      },
    );

    // Apply filters
    if (slotType != null) {
      slots = slots.where((slot) => slot.type == slotType).toList();
    }
    if (maxPrice != null) {
      slots = slots.where((slot) => slot.hourlyRate <= maxPrice).toList();
    }
    if (showOnlyAvailable == true) {
      slots = slots.where((slot) => !slot.isOccupied).toList();
    }

    return slots;
  }
  // Book a parking slot
  Future<ParkingSlot> bookSlot(String slotId, String carNumber) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Get current slot details
    final slots = await getAvailableSlots();
    final slot = slots.firstWhere(
      (slot) => slot.id == slotId,
      orElse: () => throw Exception('Invalid parking slot')
    );
    
    if (slot.isOccupied) {
      throw Exception('This parking slot is already occupied');
    }
    
    // Return booked slot with all properties
    return ParkingSlot(
      id: slotId,
      isOccupied: true,
      carNumber: carNumber,
      entryTime: DateTime.now(),
      type: slot.type,
      hourlyRate: slot.hourlyRate,
      currency: slot.currency,
      latitude: slot.latitude,
      longitude: slot.longitude,
      mallLocation: slot.mallLocation
    );
  }

  static final ParkingService _instance = ParkingService._internal();
  factory ParkingService() => _instance;
  ParkingService._internal();

  final List<ParkingHistory> _parkingHistory = [];

  List<ParkingHistory> get parkingHistory => List.unmodifiable(_parkingHistory);

  void addParkingHistory(ParkingHistory history) {
    _parkingHistory.insert(0, history);
  }

  Future<double> calculateFee(String slotId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Get slot details (mock implementation)
    final slot = (await getAvailableSlots()).firstWhere(
      (slot) => slot.id == slotId,
      orElse: () => ParkingSlot(id: slotId),
    );
    
    if (slot.entryTime == null) {
      throw Exception('No entry time recorded for this slot');
    }
    
    final duration = DateTime.now().difference(slot.entryTime!);
    final minutes = duration.inMinutes;
    
    // Rate is ₹1.2 per minute for all slots
    const ratePerMinute = 1.2;
    return ratePerMinute * minutes;
  }

  Future<ParkingSlot> validateExit(String slotId, {ParkingHistory? history}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Get slot details
    final slot = (await getAvailableSlots()).firstWhere(
      (slot) => slot.id == slotId,
      orElse: () => throw Exception('Invalid parking slot'),
    );
    
    if (!slot.isOccupied) {
      throw Exception('Parking slot is not occupied');
    }

    // Add to parking history if provided
    if (history != null) {
      _parkingHistory.add(history);
    }
    
    return slot;
  }

  // Mock validation - always succeeds
  void _validateSlotId(String slotId) {
    if (slotId.isEmpty) {
      throw Exception('Invalid slot ID');
    }
  }

  Future<Map<String, dynamic>> getNavigationPath(String slotId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return mock navigation data
    return {
      'path': [
        {'lat': 37.7749, 'lng': -122.4194},  // Example coordinates
        {'lat': 37.7748, 'lng': -122.4193},
        {'lat': 37.7747, 'lng': -122.4192}
      ],
      'distance': '50m',
      'steps': [
        {'direction': 'straight', 'instruction': 'Go straight for 20m'},
        {'direction': 'left', 'instruction': 'Turn left and continue for 15m'},
        {'direction': 'right', 'instruction': 'Turn right to reach your slot'}
      ]
    };
  }

  // Update parking slot status
  Future<ParkingSlot> updateSlotStatus(String slotId, String status, {String? carNumber}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Validate slot ID
    _validateSlotId(slotId);

    // Get current slot status
    final slots = await getAvailableSlots();
    final slot = slots.firstWhere(
      (slot) => slot.id == slotId,
      orElse: () => throw Exception('Invalid parking slot')
    );

    // Allow rebooking if slot is occupied but not exited
    if (status == 'occupied' && slot.isOccupied) {
      if (slot.exitTime != null) {
        throw Exception('This slot has already been exited');
      }
      // Reset slot for rebooking
      slot.entryTime = DateTime.now();
      slot.paymentTime = null;
      slot.paymentAmount = null;
      return slot;
    }

    // Check if slot is already occupied when trying to occupy
    if (status == 'occupied') {
      if (slot.isOccupied) {
        final duration = slot.entryTime != null
          ? DateTime.now().difference(slot.entryTime!)
          : const Duration();
        final hours = duration.inHours;
        final minutes = duration.inMinutes.remainder(60);
        throw Exception(
          'This parking slot is already occupied.\n'
          'Vehicle: ${slot.carNumber}\n'
          'Duration: $hours hours $minutes minutes'
        );
      }
    }
    
    // Update slot status
    return ParkingSlot(
      id: slot.id,
      isOccupied: status == 'occupied',
      carNumber: status == 'occupied' ? (carNumber ?? slot.carNumber) : null,
      entryTime: status == 'occupied' ? DateTime.now() : null,
      type: slot.type,
      hourlyRate: slot.hourlyRate,
      currency: slot.currency,
      latitude: slot.latitude,
      longitude: slot.longitude,
      mallLocation: slot.mallLocation
    );
  }
}