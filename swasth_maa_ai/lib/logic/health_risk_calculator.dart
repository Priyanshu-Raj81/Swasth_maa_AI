enum RiskLevel { low, medium, high }

class HealthRiskCalculator {
  static RiskLevel calculateRisk({
    required int systolicBP,
    required bool hasSwelling,
    required bool hasFever,
    required bool hasHeadache,
  }) {
    // High BP > 140
    bool isHighBP = systolicBP > 140;

    if (isHighBP && hasSwelling) {
      return RiskLevel.high; // BP > 140 AND Swelling = Yes -> HIGH RISK
    } else if (isHighBP) {
      return RiskLevel.medium; // BP > 140 -> MEDIUM RISK
    } else if (hasFever && hasHeadache) {
      return RiskLevel.medium; // Fever + Headache -> MEDIUM RISK
    } else {
      return RiskLevel.low; // Otherwise -> LOW RISK
    }
  }

  static String getRiskMessage(RiskLevel risk) {
    switch (risk) {
      case RiskLevel.high:
        return 'Khatra (HIGH RISK) - Turant Doctor se milein!';
      case RiskLevel.medium:
        return 'Dhyan Rakhein (MEDIUM RISK) - ASHA worker se baat karein.';
      case RiskLevel.low:
        return 'Sab Theek Hai (LOW RISK) - Apna khayal rakhein.';
    }
  }
}
