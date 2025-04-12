import 'package:flutter/material.dart';
import '../models/parking_slot.dart';
import 'dart:math';

class NavigationStep {
  final String location;
  final String instruction;
  final double distance;
  final IconData icon;
  final String floorLevel;
  final String sectionIdentifier;
  final String landmark;

  NavigationStep(this.location, this.instruction, this.distance, this.icon, {this.floorLevel = '', this.sectionIdentifier = '', this.landmark = ''});
}

class DirectionScreen extends StatefulWidget {
  final ParkingSlot slot;

  const DirectionScreen({super.key, required this.slot});

  @override
  State<DirectionScreen> createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  bool _isLoading = true;
  List<NavigationStep> _navigationSteps = [];
  double _estimatedDistance = 0;
  String _estimatedTime = '';
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generateRandomDirections();
  }

  void _generateRandomDirections() {
    final directions = [
      'Go straight ahead',
      'Turn right at the corner',
      'Turn left at the junction',
      'Walk straight through',
      'Follow the corridor'
    ];
    final locations = [
      'Main Entrance',
      'Information Desk',
      'Elevator Area',
      'Food Court',
      'Parking Zone A',
      'Parking Zone B',
      'Central Plaza',
      'Rest Area'
    ];
    final landmarks = [
      'Near the blue pillar',
      'Next to the vending machines',
      'Past the security desk',
      'By the digital directory',
      'Near the emergency exit',
      'Beside the payment kiosk'
    ];
    
    final steps = <NavigationStep>[];
    var totalDistance = 0.0;
    var currentFloor = widget.slot.id.contains('B') ? 'B1' : 'G';
    var currentSection = widget.slot.id.substring(0, 1);

    // Generate 3-5 random steps
    final numberOfSteps = _random.nextInt(3) + 3;

    for (var i = 0; i < numberOfSteps; i++) {
      final direction = directions[_random.nextInt(directions.length)];
      final location = locations[_random.nextInt(locations.length)];
      final distance = (_random.nextInt(30) + 10).toDouble(); // 10-40 meters
      final landmark = landmarks[_random.nextInt(landmarks.length)];
      IconData icon;

      // Assign appropriate icon based on direction
      if (direction.contains('straight')) {
        icon = Icons.arrow_upward;
      } else if (direction.contains('right')) {
        icon = Icons.turn_right;
      } else if (direction.contains('left')) {
        icon = Icons.turn_left;
      } else {
        icon = Icons.arrow_forward;
      }

      steps.add(NavigationStep(
        location,
        direction,
        distance,
        icon,
        floorLevel: currentFloor,
        sectionIdentifier: 'Section $currentSection',
        landmark: landmark
      ));
      totalDistance += distance;
    }

    // Add final destination step
    steps.add(NavigationStep(
      'Destination',
      'Your slot ${widget.slot.id} is here',
      5,
      Icons.location_on,
      floorLevel: currentFloor,
      sectionIdentifier: 'Section ${widget.slot.id.substring(0, 1)}',
      landmark: 'Look for the slot number display'
    ));

    setState(() {
      _navigationSteps = steps;
      _estimatedDistance = totalDistance;
      _estimatedTime = _calculateEstimatedTime(totalDistance);
      _isLoading = false;
    });
  }

  String _calculateEstimatedTime(double distance) {
    // Assuming average walking speed of 1.4 meters per second (5 km/h)
    int seconds = (distance / 1.4).round();
    if (seconds < 60) {
      return '$seconds seconds';
    } else {
      int minutes = (seconds / 60).ceil();
      return '$minutes minutes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigate to Slot'),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFFF5F5F5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'ETA: $_estimatedTime',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        const Icon(Icons.directions_walk, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          '${_estimatedDistance.round()}m',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: _navigationSteps.length,
                      itemBuilder: (context, index) {
                        final step = _navigationSteps[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(step.icon, size: 32, color: Theme.of(context).primaryColor),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            step.instruction,
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${step.distance.round()}m away',
                                            style: TextStyle(color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (step.floorLevel.isNotEmpty || step.sectionIdentifier.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      children: [
                                        if (step.floorLevel.isNotEmpty)
                                          Chip(
                                            label: Text(step.floorLevel),
                                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                                          ),
                                        if (step.sectionIdentifier.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8),
                                            child: Chip(
                                              label: Text(step.sectionIdentifier),
                                              backgroundColor: Colors.orange.withOpacity(0.1),
                                              labelStyle: const TextStyle(color: Colors.orange),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                if (step.landmark.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Landmark: ${step.landmark}',
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                        ),
                                      ],
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
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}