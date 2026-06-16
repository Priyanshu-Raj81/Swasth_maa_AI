class Child {
  final String childId;
  final String motherId; // Foreign Key linking to Mother
  final String childName;
  final DateTime dateOfBirth;
  final String gender;

  Child({
    required this.childId,
    required this.motherId,
    required this.childName,
    required this.dateOfBirth,
    required this.gender,
  });

  /// Calculates age in weeks from Date of Birth
  int get ageInWeeks {
    final now = DateTime.now();
    final difference = now.difference(dateOfBirth);
    return difference.inDays ~/ 7;
  }

  /// Calculates the next expected vaccine details dynamically
  Map<String, dynamic> get nextVaccinationDetails {
    final weeks = ageInWeeks;
    
    // Simplified logic: 
    // Birth -> BCG, OPV-0
    // 6 Weeks -> OPV-1, Pentavalent-1
    // 10 Weeks -> OPV-2, Pentavalent-2
    // 14 Weeks -> OPV-3, Pentavalent-3
    // 9 Months (36 weeks) -> Measles, Vitamin A
    
    if (weeks < 6) {
      return {
        'vaccine': 'OPV-1, Pentavalent-1',
        'dueDate': dateOfBirth.add(const Duration(days: 42)), // 6 weeks
      };
    } else if (weeks < 10) {
      return {
        'vaccine': 'OPV-2, Pentavalent-2',
        'dueDate': dateOfBirth.add(const Duration(days: 70)), // 10 weeks
      };
    } else if (weeks < 14) {
      return {
        'vaccine': 'OPV-3, Pentavalent-3',
        'dueDate': dateOfBirth.add(const Duration(days: 98)), // 14 weeks
      };
    } else {
      return {
        'vaccine': 'Measles, Vitamin A',
        'dueDate': dateOfBirth.add(const Duration(days: 252)), // ~9 months
      };
    }
  }

  /// Returns the UI Status of the currently due vaccine
  /// Green (Good), Yellow (Due in < 3 Days), Red (Overdue)
  String get currentStatus {
    final dueDetails = nextVaccinationDetails;
    final DateTime dueDate = dueDetails['dueDate'];
    final now = DateTime.now();
    
    // Normalize to dates
    final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final today = DateTime(now.year, now.month, now.day);
    
    final differenceDays = dueDay.difference(today).inDays;
    
    if (differenceDays < 0) {
      return 'Overdue';
    } else if (differenceDays <= 3) {
      return 'Due Soon';
    } else {
      return 'Upcoming';
    }
  }
}
