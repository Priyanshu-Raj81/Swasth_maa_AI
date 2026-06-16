import '../models/mother.dart';
import '../models/child.dart';

/// A mock centralized in-memory database to manage relational states.
class DataStore {
  // Singleton Pattern
  static final DataStore _instance = DataStore._internal();
  factory DataStore() => _instance;
  DataStore._internal();

  // Mock Active Logged-in User
  Mother currentMother = Mother(
    motherId: 'M-101',
    name: 'Sita Devi',
    age: 26,
    phone: '9876543210',
    village: 'Raipur',
    pregnancyWeeks: 0, // Post-partum
    lastRiskLevel: 'Low',
  );

  // Relational Table of Children
  List<Child> children = [
    Child(
      childId: 'C-001',
      motherId: 'M-101',
      childName: 'Raju',
      dateOfBirth: DateTime.now().subtract(const Duration(days: 44)), // ~6 weeks, OVERDUE 
      gender: 'Male',
    ),
    Child(
      childId: 'C-002',
      motherId: 'M-101',
      childName: 'Gudiya',
      dateOfBirth: DateTime.now().subtract(const Duration(days: 10)), // Recently born, Upcoming
      gender: 'Female',
    ),
  ];

  // Global pool of Mothers for Admin Dashboard
  List<Mother> allMothers = [
    Mother(
      motherId: 'M-101',
      name: 'Sita Devi',
      age: 26,
      phone: '9876543210',
      village: 'Raipur',
      pregnancyWeeks: 0,
      lastRiskLevel: 'Low',
    ),
    Mother(
      motherId: 'M-102',
      name: 'Gita Verma',
      age: 24,
      phone: '8765432109',
      village: 'Sonpur',
      pregnancyWeeks: 32,
      lastRiskLevel: 'High',
    ),
  ];

  /// Get children associated with a specific mother_id
  List<Child> getChildrenForMother(String motherId) {
    return children.where((child) => child.motherId == motherId).toList();
  }

  /// Add a new child to the database
  void addChild(Child child) {
    children.add(child);
  }
  
  /// Helper method for Admin: Check if a mother has any overdue vaccines across her children
  bool hasOverdueVaccines(String motherId) {
    final kids = getChildrenForMother(motherId);
    return kids.any((child) => child.currentStatus == 'Overdue');
  }
}
