# Mall Parking Management System

A Flutter-based parking management solution with real-time slot tracking, navigation, and payment integration.

## Key Features
- **Real-Time Slot Availability**
  - Visual indicators for occupied/available slots
  - Filter by location, slot type (VIP/Public), and price range
- **Interactive Navigation**
  - Step-by-step directions to booked slots
  - Estimated time and distance calculations
- **Booking System**
  - Car number validation and entry
  - Immediate slot status updates
- **Payment Integration**
  - Duration-based cost calculation
  - Mock payment processing
- **Parking History**
  - Detailed session records with timestamps
  - Cost and duration tracking
- **Smart Slot Management**
  - Automatic status updates on entry/exit
  - Conflict prevention for occupied slots

## Technical Architecture

### Core Components
| Component          | Description                                  |
|--------------------|----------------------------------------------|
| `ParkingSlot`      | Slot status, location, and pricing details   |
| `MallLocation`     | Mall metadata and slot capacity              |
| `ParkingHistory`   | Historical parking session records           |
| `ParkingService`   | Business logic and mock data management      |

### System Flow
graph TD
A[User Entry] --> B(Select Mall)
B --> C{Filter Slots}
C --> D[VIP/Public]
C --> E[Price Range]
C --> F[Availability]
D --> G(Book Slot)
E --> G
F --> G
G --> H[Navigation]
H --> I{Mark Reached}
I --> J[Payment]
J --> K[Exit]

text

## Critical Code Logic

### 1. Slot Booking Mechanism
Future<void> _bookParkingSlot(ParkingSlot slot) async {
// State management ensures immediate UI update
setState(() => slot.isOccupied = true);
await _parkingService.bookSlot(slot.id, carNumber);
// Navigation with state preservation
Navigator.push(context, MaterialPageRoute(
builder: (context) => NavigationScreen(slot: slot)
));
}

text

### 2. Navigation System
void _generateNavigationPath() {
// AI-powered pathfinding algorithm
final steps = calculateOptimalPath(
start: currentLocation,
end: slot.coordinates
);
updateUI(steps);
}

text

### 3. Payment Calculation
double calculateCost(DateTime entry, DateTime exit) {
final duration = exit.difference(entry);
return duration.inHours * hourlyRate +
(duration.inMinutes % 60 > 0 ? 1 : 0);
}

text

## State Management Workflow
1. **Initial State**
ParkingSlot(
id: "A-101",
isOccupied: false,
hourlyRate: 50.0
)

text
2. **Booking Transition**
updateSlotStatus(slotId, 'occupied', carNumber: 'PB10AB1234')

text
3. **Navigation State**
Navigator.push(context, RouteArgs(
refresh: true,
updatedSlot: occupiedSlot
))

text
4. **Exit Transition**
validateExit(slotId).then((_) =>
updateSlotStatus(slotId, 'available')
)

text

## Setup Instructions

1. **Environment Setup**
flutter pub get
flutter pub upgrade

text

2. **Run Application**
flutter run -d chrome

text

3. **Test Scenarios**
flutter test test/parking_test.dart

text

## Mock Data Structure
{
"slotId": "B2-045",
"type": "VIP",
"rate": 75.0,
"coordinates": {
"lat": 30.7046,
"lng": 76.7179
},
"occupancyHistory": [
{
"entry": "2025-04-12T18:30:00Z",
"exit": "2025-04-12T20:45:00Z",
"vehicle": "PB10CD5678"
}
]
}

text

## Future Enhancements
- [ ] IoT Integration for real-time slot sensors
- [ ] License Plate Recognition (LPR) system
- [ ] Dynamic pricing based on demand
- [ ] Multi-language support
- [ ] Accessibility features for disabled parking

## Troubleshooting Guide

| Issue                          | Solution                                   |
|--------------------------------|--------------------------------------------|
| Slot not updating status       | Check `ParkingService.updateSlotStatus()`  |
| Navigation path errors         | Verify `calculateOptimalPath()` algorithm  |
| Payment calculation mismatch   | Audit `ParkingHistory.duration` logic      |
| UI not refreshing              | Ensure proper `setState()` implementation  |

**Contributors:** [Your Name]  
**License:** MIT License