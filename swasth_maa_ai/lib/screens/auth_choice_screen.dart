import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/primary_button.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.favorite,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 48),
              Text(
                'Swagat Hai',
                textAlign: TextAlign.center,
                style: AppTypography.displayLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Kripya apna vikalp chunein',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 48),
              Card(
                elevation: 4,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      PrimaryButton(
                        text: 'Nayi Registration',
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: 'Pehle Se User Hoon',
                        isOutlined: true,
                        onPressed: () {
                          // For prototype, just go to OTP screen to simulate login
                          Navigator.pushNamed(context, '/otp');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/admin');
                },
                child: Text(
                  'Admin/ASHA Login',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
