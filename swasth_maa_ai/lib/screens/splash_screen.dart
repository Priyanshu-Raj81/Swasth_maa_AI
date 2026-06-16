import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/primary_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Spacer(),
              // Logo Image from Prototype
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
                  ],
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAdXWTNW_zo16qicAwJpV2sXmE-UoZgzAXFWgPCQt9eyEkXMDMHcvSzitnUzYt-S07VywIh7kSySy7e_5rxNpvm8FStp23eSRTR440WjxO_dnj9YPv2dLVjIvp0VdUvBf_qMF-ZdWxGG-pRp0aoKIZ5fA-3tYg5422QIPxP88wYz6jvYIjeap_gvE1x7xdcIr50pleVbR-sft50idZVVyJ91rAyQHJlUDXLMY1dIpCAR5rNOaB_6Du3jXRuTfgj6ZRpwqw6LMqZNww'
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '🌾 Swasth Maa AI',
                textAlign: TextAlign.center,
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'AI Powered Maa aur Baccha Suraksha',
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge.copyWith(
                  color: Colors.white70,
                ),
              ),
              const Spacer(),
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
