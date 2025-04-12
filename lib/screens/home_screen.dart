import 'package:flutter/material.dart';
import 'dart:math';
import '../models/parking_slot.dart';
import '../services/parking_service.dart';
import '../models/mall_location.dart';
import '../models/parking_history.dart';
import 'navigation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ParkingService _parkingService = ParkingService();
  List<ParkingSlot> _parkingSlots = [];
  bool _isLoading = false;
  MallLocation? _selectedLocation;
  ParkingType? _selectedType;
  double? _maxPrice;
  bool _showOnlyAvailable = false;
  RangeValues _priceRange = const RangeValues(0, 200);
  List<ParkingHistory> _parkingHistory = [];
  List<MallLocation> _mallLocations = [
    MallLocation(
      id: '1',
      name: 'VR Punjab',
      address: 'Kharar Landran Rd, Mohali',
      latitude: 30.7046,
      longitude: 76.7179,
      totalSlots: 100,
    ),
    MallLocation(
      id: '2',
      name: 'North Country Mall',
      address: 'Sector 9, Greater Mohali',
      latitude: 30.7333,
      longitude: 76.7794,
      totalSlots: 120,
    ),
    MallLocation(
      id: '3',
      name: 'Bestech Square Mall',
      address: 'Sector 66A, Mohali',
      latitude: 30.7102,
      longitude: 76.7125,
      totalSlots: 80,
    ),
    MallLocation(
      id: '4',
      name: 'Elante Mall',
      address: 'Industrial Area Phase 1, Chandigarh',
      latitude: 30.7051,
      longitude: 76.8014,
      totalSlots: 150,
    ),
    MallLocation(
      id: '5',
      name: 'DLF City Centre Mall',
      address: 'IT Park Road, Chandigarh',
      latitude: 30.7280,
      longitude: 76.8019,
      totalSlots: 90,
    )
  ];

  @override
  void initState() {
    super.initState();
    _selectedLocation = _mallLocations.first;
    _loadParkingSlots();
    _loadMockParkingHistory();
  }

  void _loadMockParkingHistory() {
    final now = DateTime.now();
    _parkingHistory = [
      ParkingHistory(
        id: '1',
        slotId: 'A-101',
        entryTime: now.subtract(const Duration(hours: 3)),
        exitTime: now.subtract(const Duration(hours: 1)),
        cost: 60.0,
        mallLocation: _mallLocations[0],
        vehicleNumber: 'PB10AB1234',
      ),
      ParkingHistory(
        id: '2',
        slotId: 'B-205',
        entryTime: now.subtract(const Duration(days: 1, hours: 4)),
        exitTime: now.subtract(const Duration(days: 1, hours: 2)),
        cost: 40.0,
        mallLocation: _mallLocations[1],
        vehicleNumber: 'PB10CD5678',
      ),
      ParkingHistory(
        id: '3',
        slotId: 'C-308',
        entryTime: now.subtract(const Duration(days: 2, hours: 5)),
        exitTime: now.subtract(const Duration(days: 2, hours: 3)),
        cost: 80.0,
        mallLocation: _mallLocations[2],
        vehicleNumber: 'PB10EF9012',
      ),
    ];
  }

  void _showParkingHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Parking History',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _parkingHistory.length,
                  itemBuilder: (context, index) {
                    final history = _parkingHistory[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Slot ${history.slotId}',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  history.formattedCost,
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              history.mallLocation?.name ?? 'Location not available',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Duration: ${history.duration}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Entry',
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          color: Theme.of(context).colorScheme.outline,
                                        ),
                                      ),
                                      Text(
                                        history.formattedEntryTime,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Exit',
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          color: Theme.of(context).colorScheme.outline,
                                        ),
                                      ),
                                      Text(
                                        history.formattedExitTime,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Vehicle: ${history.vehicleNumber}',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadParkingSlots() async {
    setState(() => _isLoading = true);
    try {
      final slots = await _parkingService.getAvailableSlots(
        mallId: _selectedLocation?.id ?? 'vr_punjab',
        slotType: _selectedType,
        maxPrice: _maxPrice,
        showOnlyAvailable: _showOnlyAvailable,
      );
      setState(() {
        _parkingSlots = slots;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _bookParkingSlot(ParkingSlot slot) async {
    if (!mounted) return;

    if (slot.isOccupied) {
      // Show occupied slot information
      final duration = slot.entryTime != null
          ? DateTime.now().difference(slot.entryTime!)
          : const Duration();
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Slot Occupied'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Slot ${slot.id} is currently occupied'),
              const SizedBox(height: 8),
              Text('Duration: $hours hours $minutes minutes'),
              if (slot.carNumber != null) Text('Vehicle: ${slot.carNumber}')
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _CarNumberDialog(),
    );

    if (result != null && result['carNumber'] != null) {
      try {
        final bookedSlot = await _parkingService.bookSlot(slot.id, result['carNumber']);
        
        // Immediately update local state
        setState(() {
          final index = _parkingSlots.indexWhere((s) => s.id == slot.id);
          if (index != -1) {
            _parkingSlots[index] = bookedSlot;
          }

          // Add new entry to parking history
          final now = DateTime.now();
          final newHistory = ParkingHistory(
            id: now.millisecondsSinceEpoch.toString(),
            slotId: slot.id,
            entryTime: now,
            mallLocation: _selectedLocation!,
            vehicleNumber: result['carNumber'],
            cost: slot.hourlyRate,
          );
          _parkingHistory.insert(0, newHistory);
        });

        // Navigate and handle result
        final navResult = await Navigator.push<Map<String, dynamic>>(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationScreen(
              slot: bookedSlot,
              mallLocation: _selectedLocation,
            ),
          ),
        );

        if (navResult != null) {
          if (navResult['updatedSlot'] != null) {
            setState(() {
              final index = _parkingSlots.indexWhere(
                (s) => s.id == navResult['updatedSlot'].id
              );
              if (index != -1) {
                _parkingSlots[index] = navResult['updatedSlot'];
              }
            });
          } else if (navResult['refresh'] == true) {
            await _loadParkingSlots();
          }
        }

      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.local_parking_rounded, size: 28, color: Colors.white),
            const SizedBox(width: 12),
            Text('Mall Parking',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadParkingSlots,
            tooltip: 'Refresh parking slots',
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: _showParkingHistory,
            tooltip: 'Parking History',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help feature coming soon!')),
              );
            },
            tooltip: 'Help',
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.background,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Search and Filter Section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        // Filter by Type
                        ChoiceChip(
                          label: const Text('VIP'),
                          selected: _selectedType == ParkingType.vip,
                          onSelected: (selected) {
                            setState(() {
                              _selectedType = selected ? ParkingType.vip : null;
                              _loadParkingSlots();
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Public'),
                          selected: _selectedType == ParkingType.public,
                          onSelected: (selected) {
                            setState(() {
                              _selectedType = selected ? ParkingType.public : null;
                              _loadParkingSlots();
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        // Available Only Filter
                        FilterChip(
                          label: const Text('Available Only'),
                          selected: _showOnlyAvailable,
                          onSelected: (selected) {
                            setState(() {
                              _showOnlyAvailable = selected;
                              _loadParkingSlots();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // Price Range Slider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Price Range:'),
                            Text('₹${_priceRange.start.round()} - ₹${_priceRange.end.round()}')
                          ],
                        ),
                        RangeSlider(
                          values: _priceRange,
                          min: 0,
                          max: 200,
                          divisions: 20,
                          labels: RangeLabels(
                            '₹${_priceRange.start.round()}',
                            '₹${_priceRange.end.round()}',
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _priceRange = values;
                              _maxPrice = values.end;
                              _loadParkingSlots();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<MallLocation>(
                        value: _selectedLocation,
                        isExpanded: true,
                        icon: Icon(Icons.location_on,
                            color: Theme.of(context).colorScheme.primary),
                        items: _mallLocations.map((MallLocation location) {
                          return DropdownMenuItem<MallLocation>(
                            value: location,
                            child: Text(location.name,
                                style: Theme.of(context).textTheme.titleMedium),
                          );
                        }).toList(),
                        onChanged: (MallLocation? newLocation) {
                          setState(() {
                            _selectedLocation = newLocation;
                          });
                          _loadParkingSlots();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            const AssetImage('lib/src/images/sample.jpg'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome back,',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline)),
                            const SizedBox(height: 4),
                            Text('Anonymous',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _parkingSlots.length,
                      itemBuilder: (context, index) {
                        final slot = _parkingSlots[index];
                        return _ParkingSlotCard(
                          slot: slot,
                          onBook: () => _bookParkingSlot(slot),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParkingSlotCard extends StatelessWidget {
  final ParkingSlot slot;
  final VoidCallback onBook;

  const _ParkingSlotCard({
    required this.slot,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: slot.isOccupied ? null : onBook,
          borderRadius: BorderRadius.circular(16),
          child: Opacity(
            opacity: slot.isOccupied ? 0.6 : 1.0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Slot ${slot.id}',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: slot.isOccupied
                              ? Theme.of(context).colorScheme.error.withOpacity(0.1)
                              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          slot.isOccupied ? 'Occupied' : 'Available',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: slot.isOccupied
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Type: ${slot.type == ParkingType.vip ? 'VIP' : 'Public'}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rate: ₹${slot.hourlyRate}/hour',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (slot.isOccupied && slot.entryTime != null) ...[                                  
                    const SizedBox(height: 8),
                    Text(
                      'Occupied since: ${slot.formattedEntryTime}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CarNumberDialog extends StatefulWidget {
  @override
  _CarNumberDialogState createState() => _CarNumberDialogState();
}

class _CarNumberDialogState extends State<_CarNumberDialog> {
  final _controller = TextEditingController();
  Duration _selectedDuration = const Duration(hours: 1);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Vehicle Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Vehicle Number',
              hintText: 'e.g., PB10AB1234',
            ),
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Duration>(
            value: _selectedDuration,
            decoration: const InputDecoration(
              labelText: 'Expected Duration',
            ),
            items: [
              const Duration(hours: 1),
              const Duration(hours: 2),
              const Duration(hours: 3),
              const Duration(hours: 4),
              const Duration(hours: 5),
            ].map((duration) {
              return DropdownMenuItem<Duration>(
                value: duration,
                child: Text('${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}'),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedDuration = newValue!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.pop(context, {
                'carNumber': _controller.text.toUpperCase(),
                'duration': _selectedDuration,
              });
            }
          },
          child: const Text('Book'),
        ),
      ],
    );
  }
}