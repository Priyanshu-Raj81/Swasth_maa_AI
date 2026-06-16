import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_choice_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/home_dashboard.dart';
import 'screens/health_check_screen.dart';
import 'screens/risk_result_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'screens/vaccination_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/admin_dashboard.dart';

void main() {
  runApp(const SwasthMaaApp());
}

class SwasthMaaApp extends StatelessWidget {
  const SwasthMaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swasth Maa AI',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthChoiceScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/otp': (context) => const OtpScreen(),
        '/home': (context) => const HomeDashboard(),
        '/health_check': (context) => const HealthCheckScreen(),
        '/risk_result': (context) => const RiskResultScreen(),
        '/chat': (context) => const AiChatScreen(),
        '/vaccination': (context) => const VaccinationScreen(),
        '/emergency': (context) => const EmergencyScreen(),
        '/admin': (context) => const AdminDashboard(),
      },
      // Configure builder to clamp app width on web/desktop to simulate mobile view
      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480), // Mobile-first constraint
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
