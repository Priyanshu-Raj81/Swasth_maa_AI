import 'package:flutter/material.dart';
import '../theme/colors.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  Widget _buildLabelRow(String label, {bool showSpeaker = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (showSpeaker)
            const Icon(Icons.volume_up, color: AppColors.primary, size: 20),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    IconData? prefixIcon,
    IconData? suffixIcon,
    String? suffixText,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey.shade400) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: AppColors.primary) : null,
          suffixText: suffixText,
          suffixStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildDropdown({required String hint, required IconData prefixIcon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Row(
            children: [
              Icon(prefixIcon, color: Colors.grey.shade400),
              const SizedBox(width: 12),
              Text(hint, style: TextStyle(color: Colors.grey.shade400)),
            ],
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: const [],
          onChanged: (val) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'पंजीकरण (Registration)',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Image Placeholder (Using splash image)
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCfi9EgA5uC8gpM26ZSSJ4-hMMO4NDdA0LlZYhKYR9bq1jLUv04pLmESZPUAgtuT7BYbcehTqhd6rpO11jmNerlFfH29oKGmSBcTzVdZFu-_4t58T-Ts0kuh-w9A3lMYCWn5tx349F29TPTmS-jwpNcnfe2WKq8iutGlEN4tKM3A6oB2l8Ptgy_bx-8aBWwy1YY7hdA2DkNukwR__m6imdX5f3lIbrZcOw1tKatX9Ej_wM6-4p66Usy6VNEYsntxi7MeTYxwqd5cJA',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: AppColors.primaryLight,
                    child: const Icon(Icons.image, size: 50, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              const Text(
                'नमस्ते! अपना खाता बनाएं',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Swasth Maa AI परिवार में आपका स्वागत है',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              // Form fields
              _buildLabelRow('पूरा नाम (Full Name)'),
              _buildTextField(
                hint: 'जैसे: सीता देवी', 
                prefixIcon: Icons.person,
                suffixIcon: Icons.mic,
              ),

              _buildLabelRow('रक्त समूह (Blood Group)'),
              _buildDropdown(
                hint: 'रक्त समूह चुनें...', 
                prefixIcon: Icons.bloodtype,
              ),

              Row(
                children: [
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         _buildLabelRow('वजन (Wt)', showSpeaker: false),
                         _buildTextField(
                            hint: '', 
                            prefixIcon: Icons.monitor_weight_outlined,
                            suffixText: 'kg',
                            keyboardType: TextInputType.number,
                         ),
                       ]
                     )
                   ),
                   const SizedBox(width: 16),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         _buildLabelRow('लंबाई (Ht)', showSpeaker: false),
                         _buildTextField(
                            hint: '', 
                            prefixIcon: Icons.height,
                            suffixText: 'cm',
                            keyboardType: TextInputType.number,
                         ),
                       ]
                     )
                   ),
                ],
              ),

              _buildLabelRow('मोबाइल नंबर (Mobile)'),
              _buildTextField(
                hint: '00000 00000', 
                prefixIcon: Icons.sim_card_outlined,
                keyboardType: TextInputType.phone,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                child: Text(
                  'हम सत्यापन के लिए एक ओटीपी (OTP) भेजेंगे',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),

              _buildLabelRow('गाँव का नाम (Village)'),
              _buildDropdown(
                hint: 'अपना गाँव चुनें...', 
                prefixIcon: Icons.location_on_outlined,
              ),

              const SizedBox(height: 32),

              // Pink Action Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/otp');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('आगे बढ़ें (Next)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('मदद चाहिए?', style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(width: 8),
                  const Icon(Icons.phone, color: AppColors.primary, size: 16),
                  const SizedBox(width: 4),
                  const Text('कॉल करें', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
