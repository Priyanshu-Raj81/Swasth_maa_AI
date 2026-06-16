import 'package:flutter/material.dart';
import '../theme/typography.dart';
import '../theme/colors.dart';
import '../widgets/primary_button.dart';
import '../logic/health_risk_calculator.dart';

class RiskResultScreen extends StatelessWidget {
  const RiskResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments passed from previous screen
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    
    int bp = args['bp'] ?? 120;
    bool swelling = args['swelling'] ?? false;
    bool fever = args['fever'] ?? false;
    bool headache = args['headache'] ?? false;

    // Calculate Risk using the Logic class
    RiskLevel risk = HealthRiskCalculator.calculateRisk(
      systolicBP: bp,
      hasSwelling: swelling,
      hasFever: fever,
      hasHeadache: headache,
    );

    // Determine Colors based on Risk
    Color riskColor;
    IconData riskIcon;
    String riskTitle;
    
    switch (risk) {
      case RiskLevel.high:
        riskColor = AppColors.alertRed;
        riskIcon = Icons.warning_rounded;
        riskTitle = 'HIGH RISK';
        break;
      case RiskLevel.medium:
        riskColor = AppColors.alertYellow;
        riskIcon = Icons.report_problem_rounded;
        riskTitle = 'MEDIUM RISK';
        break;
      case RiskLevel.low:
        riskColor = AppColors.alertGreen;
        riskIcon = Icons.check_circle_outline_rounded;
        riskTitle = 'LOW RISK';
        break;
    }

    String hindiExplanation = HealthRiskCalculator.getRiskMessage(risk);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Result'),
        backgroundColor: riskColor, // Change AppBar color to match risk urgency
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: riskColor.withOpacity(0.1),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: riskColor, width: 2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
                  child: Column(
                    children: [
                      Icon(riskIcon, size: 80, color: riskColor),
                      const SizedBox(height: 24),
                      Text(
                        riskTitle,
                        style: AppTypography.displayLarge.copyWith(color: riskColor),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        hindiExplanation,
                        textAlign: TextAlign.center,
                        style: AppTypography.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              
              if (risk == RiskLevel.high || risk == RiskLevel.medium) ...[
                PrimaryButton(
                  text: 'Doctor se Sampark Karein',
                  color: riskColor,
                  onPressed: () {
                    // Action to call doctor
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Calling Doctor/ASHA...')),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
              
              PrimaryButton(
                text: 'Back to Home',
                isOutlined: true,
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                },
              ),

              const Spacer(),
              // Disclaimer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Yeh AI sirf salah deta hai. Doctor ki jagah nahi hai.',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
