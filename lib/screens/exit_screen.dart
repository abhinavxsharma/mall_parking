import 'package:flutter/material.dart';
import '../models/parking_slot.dart';
import '../services/parking_service.dart';
import '../models/parking_history.dart';

class ExitScreen extends StatefulWidget {
  final ParkingSlot slot;

  const ExitScreen({super.key, required this.slot});

  @override
  State<ExitScreen> createState() => _ExitScreenState();
}

class _ExitScreenState extends State<ExitScreen> {
  final ParkingService _parkingService = ParkingService();
  bool _isLoading = false;
  String _duration = '';

  @override
  void initState() {
    super.initState();
    _calculateDuration();
  }

  void _calculateDuration() {
    if (widget.slot.entryTime != null) {
      final duration = DateTime.now().difference(widget.slot.entryTime!);
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      setState(() {
        _duration = '$hours hours ${minutes} minutes';
      });
    }
  }

  Future<void> _handleExit() async {
    setState(() => _isLoading = true);
    try {
      final exitTime = DateTime.now();
      final duration = exitTime.difference(widget.slot.entryTime!);
      final hours = duration.inHours + (duration.inMinutes % 60 > 0 ? 1 : 0);
      final cost = widget.slot.hourlyRate * hours;
      
      // Create parking history entry with mall location
      // Get the current mall location from the parking service
      final mallLocations = _parkingService.getMallLocations();
      final mallLocation = mallLocations.first; // Using first mall as default for now
      
      final history = ParkingHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        slotId: widget.slot.id,
        entryTime: widget.slot.entryTime!,
        exitTime: exitTime,
        cost: cost,
        mallLocation: mallLocation,
        vehicleNumber: widget.slot.carNumber!,
      );
      
      await _parkingService.validateExit(widget.slot.id, history: history);
      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exit Parking'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF5F5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions_car,
                          size: 64,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Ready to Exit',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: const Color(0xFF1976D2),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Slot ${widget.slot.id}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey.shade800,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Car Number: ${widget.slot.carNumber}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Please proceed to the exit gate',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _handleExit,
                icon: const Icon(Icons.exit_to_app),
                label: Text(_isLoading ? 'Processing...' : 'Confirm Exit'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Slots'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  side: const BorderSide(color: Color(0xFF1976D2)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
