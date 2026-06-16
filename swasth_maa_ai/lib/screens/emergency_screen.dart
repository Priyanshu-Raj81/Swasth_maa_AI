import 'package:flutter/material.dart';
import '../theme/typography.dart';
import '../theme/colors.dart';
import '../widgets/primary_button.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.alertRed, // Red theme for emergency
      appBar: AppBar(
        title: const Text('Emergency SOS'),
        backgroundColor: AppColors.alertRed,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.warning_rounded,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              const Text(
                'Apatkalin Sahayta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Agar aapko turant madad chahiye, toh neeche diye gaye button dabayein.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 48),
              
              PrimaryButton(
                text: '📞 Call Ambulance (108)',
                color: Colors.white,
                textColor: AppColors.alertRed,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calling 108 Ambulance...')),
                  );
                },
              ),
              const SizedBox(height: 16),
              
              PrimaryButton(
                text: '🏥 Najdiki Health Center',
                color: Colors.white,
                textColor: AppColors.alertRed,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Finding nearest center (Dummy: Primary Health Center, Rampur)...')),
                  );
                },
              ),
              const SizedBox(height: 16),

              PrimaryButton(
                text: '👩‍⚕️ ASHA Worker ko Bulao',
                color: Colors.white,
                textColor: AppColors.alertRed,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calling ASHA Worker (Kamla Devi)...')),
                  );
                },
              ),

              const Spacer(),
              PrimaryButton(
                text: 'Wapas Jayein',
                isOutlined: true,
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
