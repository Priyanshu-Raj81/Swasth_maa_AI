import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/primary_button.dart';
import '../services/ai_service.dart';
import '../services/data_store.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASHA / Admin Dashboard'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Rampur Village Status', style: AppTypography.displayMedium),
              const SizedBox(height: 24),
              
              // Stats Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard('Total\nWomen', '42', Colors.blue),
                  _buildStatCard('High\nRisk', '3', AppColors.alertRed),
                  _buildStatCard('Medium\nRisk', '8', AppColors.alertYellow),
                  _buildStatCard('Due\nVaccines', '12', Colors.purple),
                ],
              ),
              
              const SizedBox(height: 32),
              Text('High Risk Cases (Urgent)', style: AppTypography.titleLarge),
              const SizedBox(height: 16),

              // Patient List
              _buildPatientCard('Sunita Devi', 'Age: 26 • 32 Weeks', RiskType.high),
              _buildPatientCard('Pooja Kumari', 'Age: 22 • 40 Weeks', RiskType.high),
              _buildPatientCard('Meena Sarkar', 'Age: 29 • 15 Weeks', RiskType.high),

              const SizedBox(height: 24),
              Text('Medium Risk Cases', style: AppTypography.titleLarge),
              const SizedBox(height: 16),
              _buildPatientCard('Radha Sharma', 'Age: 24 • 20 Weeks', RiskType.medium),
              _buildPatientCard('Kavita Verma', 'Age: 27 • 12 Weeks', RiskType.medium),

              // VACCINATION ALERTS 
              const SizedBox(height: 32),
              Row(
                children: [
                  const Icon(Icons.vaccines, color: AppColors.alertRed),
                  const SizedBox(width: 8),
                  Text('Child Vaccination Alerts (Overdue)', style: AppTypography.titleLarge.copyWith(color: AppColors.alertRed)),
                ]
              ),
              const SizedBox(height: 16),
              ...DataStore().allMothers
                  .where((m) => DataStore().hasOverdueVaccines(m.motherId))
                  .map((m) {
                    final overdueKids = DataStore().getChildrenForMother(m.motherId).where((c) => c.currentStatus == 'Overdue').toList();
                    if (overdueKids.isEmpty) return const SizedBox.shrink();

                    return _buildPatientCard(
                      m.name, 
                      'Overdue Vaccines for: ${overdueKids.map((c) => c.childName).join(', ')}', 
                      RiskType.high
                    );
                  }).toList(),

              const SizedBox(height: 32),
              Text('AI Chat Logs (Maa Se Baat)', style: AppTypography.titleLarge),
              const SizedBox(height: 16),
              _buildChatLogsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatLogsSection() {
    return FutureBuilder<List<String>>(
      future: AiService.getChatLogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('Abhi tak koi chat history nahi hai.');
        }

        final logs = snapshot.data!.reversed.toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length > 5 ? 5 : logs.length, // Show latest 5 logs
          itemBuilder: (context, index) {
            final logParts = logs[index].split('|');
            if (logParts.length < 3) return const SizedBox.shrink();

            final sender = logParts[1];
            final message = logParts[2];
            final lowercaseMsg = message.toLowerCase();

            // Emergency Trigger Flag Logic
            bool isFlagged = sender == 'User' && 
                (lowercaseMsg.contains('tez') || 
                 lowercaseMsg.contains('heavy') || 
                 lowercaseMsg.contains('severe') ||
                 lowercaseMsg.contains('emergency') ||
                 lowercaseMsg.contains('bleeding'));

            return Card(
              color: isFlagged ? AppColors.alertRed.withOpacity(0.1) : AppColors.cardWhite,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(
                  sender == 'User' ? Icons.person : Icons.smart_toy,
                  color: sender == 'User' ? AppColors.primary : Colors.purple,
                ),
                title: Row(
                  children: [
                    Text(sender, style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (isFlagged) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.warning, color: AppColors.alertRed, size: 16),
                      const Text(' Flagged', style: TextStyle(color: AppColors.alertRed, fontSize: 12, fontWeight: FontWeight.bold)),
                    ]
                  ],
                ),
                subtitle: Text(message),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            const Spacer(),
            Text(count, style: AppTypography.displayLarge.copyWith(color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(String name, String details, RiskType risk) {
    Color riskColor = risk == RiskType.high ? AppColors.alertRed : AppColors.alertYellow;
    IconData riskIcon = risk == RiskType.high ? Icons.warning : Icons.report_problem;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: riskColor.withOpacity(0.2),
          child: Icon(riskIcon, color: riskColor),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(details),
        trailing: IconButton(
          icon: const Icon(Icons.phone, color: AppColors.primary),
          onPressed: () {
            // Dummy Call
          },
        ),
      ),
    );
  }
}

enum RiskType { high, medium, low }
