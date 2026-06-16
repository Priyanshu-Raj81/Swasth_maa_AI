import 'package:flutter/material.dart';
import '../theme/typography.dart';
import '../theme/colors.dart';
import '../widgets/primary_button.dart';

class HealthCheckScreen extends StatefulWidget {
  const HealthCheckScreen({super.key});

  @override
  State<HealthCheckScreen> createState() => _HealthCheckScreenState();
}

class _HealthCheckScreenState extends State<HealthCheckScreen> {
  final TextEditingController _bpController = TextEditingController();
  bool _hasSwelling = false;
  bool _hasFever = false;
  bool _hasHeadache = false;

  @override
  void dispose() {
    _bpController.dispose();
    super.dispose();
  }

  void _analyzeRisk() {
    int bp = int.tryParse(_bpController.text) ?? 120; // Default normal if empty for prototype

    Navigator.pushNamed(
      context,
      '/risk_result',
      arguments: {
        'bp': bp,
        'swelling': _hasSwelling,
        'fever': _hasFever,
        'headache': _hasHeadache,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Check'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Apne Lakshan Darj Karein',
                style: AppTypography.displayMedium,
              ),
              const SizedBox(height: 32),
              
              Text('Blood Pressure (Upar Wala / Systolic)', style: AppTypography.titleLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _bpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Jaise: 120, 145',
                  suffixText: 'mmHg',
                ),
              ),
              
              const SizedBox(height: 32),
              Text('Kya Soojan (Swelling) hai?', style: AppTypography.titleLarge),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Haan (Yes)'),
                      value: true,
                      groupValue: _hasSwelling,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _hasSwelling = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Nahi (No)'),
                      value: false,
                      groupValue: _hasSwelling,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _hasSwelling = val!),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Text('Kya Bukhar (Fever) hai?', style: AppTypography.titleLarge),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Haan (Yes)'),
                      value: true,
                      groupValue: _hasFever,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _hasFever = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Nahi (No)'),
                      value: false,
                      groupValue: _hasFever,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _hasFever = val!),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Text('Kya Sir Dard (Headache) hai?', style: AppTypography.titleLarge),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Haan (Yes)'),
                      value: true,
                      groupValue: _hasHeadache,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _hasHeadache = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Nahi (No)'),
                      value: false,
                      groupValue: _hasHeadache,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _hasHeadache = val!),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),
              PrimaryButton(
                text: 'Risk Analyse Karein',
                onPressed: _analyzeRisk,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
