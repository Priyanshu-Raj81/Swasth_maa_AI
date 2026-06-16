import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/health_card.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swasth Maa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context, 
                '/auth', 
                (route) => false,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: const NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCfi9EgA5uC8gpM26ZSSJ4-hMMO4NDdA0LlZYhKYR9bq1jLUv04pLmESZPUAgtuT7BYbcehTqhd6rpO11jmNerlFfH29oKGmSBcTzVdZFu-_4t58T-Ts0kuh-w9A3lMYCWn5tx349F29TPTmS-jwpNcnfe2WKq8iutGlEN4tKM3A6oB2l8Ptgy_bx-8aBWwy1YY7hdA2DkNukwR__m6imdX5f3lIbrZcOw1tKatX9Ej_wM6-4p66Usy6VNEYsntxi7MeTYxwqd5cJA'
              ),
              backgroundColor: AppColors.primaryLight,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pregnancy Status Card
              Card(
                color: AppColors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text(
                        'Namaste, Sunita',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '12 Weeks Pregnant',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Zaroori Suvidhayein',
                style: AppTypography.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Quick Actions
              HealthCard(
                title: 'Health Check',
                subtitle: 'Apna daily risk analyse karein',
                icon: Icons.medical_services,
                onTap: () => Navigator.pushNamed(context, '/health_check'),
              ),
              HealthCard(
                title: 'Vaccination Reminder',
                subtitle: 'Agla teeka kab lagna hai',
                icon: Icons.vaccines,
                iconColor: Colors.blue,
                onTap: () => Navigator.pushNamed(context, '/vaccination'),
              ),
              HealthCard(
                title: 'Maa Se Baat (AI Chat)',
                subtitle: 'Apne sawaal AI se poochein',
                icon: Icons.chat_bubble,
                iconColor: Colors.purple,
                onTap: () => Navigator.pushNamed(context, '/chat'),
              ),
              HealthCard(
                title: 'Emergency Help',
                subtitle: 'Turant madad payein',
                icon: Icons.warning_amber_rounded,
                iconColor: AppColors.alertRed,
                onTap: () => Navigator.pushNamed(context, '/emergency'),
              ),

              const SizedBox(height: 24),
              // Daily Health Insight Card
              Card(
                color: AppColors.primaryLight,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb, color: AppColors.alertYellow, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Aaj ka Tip: Roz 8-10 glass paani piyein, yeh aapke aur bacche ke liye accha hai.',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
