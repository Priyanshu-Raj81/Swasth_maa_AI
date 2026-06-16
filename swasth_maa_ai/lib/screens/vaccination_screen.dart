import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/child.dart';
import '../services/data_store.dart';
import '../theme/typography.dart';
import '../theme/colors.dart';
import '../widgets/primary_button.dart';

class VaccinationScreen extends StatefulWidget {
  const VaccinationScreen({super.key});

  @override
  State<VaccinationScreen> createState() => _VaccinationScreenState();
}

class _VaccinationScreenState extends State<VaccinationScreen> {
  final DataStore _dataStore = DataStore();
  late List<Child> myChildren;

  @override
  void initState() {
    super.initState();
    _refreshChildren();
  }

  void _refreshChildren() {
    setState(() {
      myChildren = _dataStore.getChildrenForMother(_dataStore.currentMother.motherId);
    });
  }

  void _showAddChildForm(BuildContext context) {
    final nameController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedGender = 'Female';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24, right: 24, top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Add New Child (नया बच्चा जोड़ें)', style: AppTypography.titleLarge),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Child Name (बच्चे का नाम)', prefixIcon: Icon(Icons.child_care)),
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    title: const Text('Date of Birth (जन्म तिथि)'),
                    subtitle: Text(DateFormat('dd MMM yyyy').format(selectedDate)),
                    leading: const Icon(Icons.calendar_today, color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setModalState(() => selectedDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: const InputDecoration(labelText: 'Gender (लिंग)'),
                    items: ['Female', 'Male'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (val) => setModalState(() => selectedGender = val!),
                  ),
                  const SizedBox(height: 32),
                  
                  PrimaryButton(
                    text: 'Save (सुरक्षित करें)',
                    onPressed: () {
                      if (nameController.text.trim().isEmpty) return;
                      
                      final newChild = Child(
                        childId: 'C-${DateTime.now().millisecondsSinceEpoch}',
                        motherId: _dataStore.currentMother.motherId,
                        childName: nameController.text.trim(),
                        dateOfBirth: selectedDate,
                        gender: selectedGender,
                      );
                      
                      _dataStore.addChild(newChild);
                      _refreshChildren();
                      Navigator.pop(context);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Child linked successfully!')),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Overdue': return AppColors.alertRed;
      case 'Due Soon': return AppColors.alertYellow;
      case 'Upcoming': return AppColors.alertGreen;
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Overdue': return Icons.error;
      case 'Due Soon': return Icons.pending_actions;
      case 'Upcoming': return Icons.check_circle;
      default: return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Children (मेरे बच्चे)'),
      ),
      body: SafeArea(
        child: myChildren.isEmpty
          ? const Center(child: Text('No children registered yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: myChildren.length,
              itemBuilder: (context, index) {
                final child = myChildren[index];
                final vacDetails = child.nextVaccinationDetails;
                final status = child.currentStatus;
                final statusColor = _getStatusColor(status);

                return Card(
                  margin: const EdgeInsets.only(bottom: 24),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: statusColor.withOpacity(0.5), width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              child: Icon(
                                child.gender == 'Female' ? Icons.girl : Icons.boy, 
                                color: AppColors.primaryDark
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    child.childName,
                                    style: AppTypography.titleLarge,
                                  ),
                                  Text(
                                    '${child.ageInWeeks} Weeks old',
                                    style: AppTypography.bodyMedium.copyWith(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 32),
                        
                        // Vaccination Info
                        Text('Next Vaccine (अगला टीका):', style: AppTypography.bodyMedium),
                        const SizedBox(height: 4),
                        Text(
                          vacDetails['vaccine'],
                          style: AppTypography.titleLarge.copyWith(color: AppColors.primary),
                        ),
                        const SizedBox(height: 12),
                        
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_getStatusIcon(status), color: statusColor, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Status: $status',
                                style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Due Date: ${DateFormat('dd MMM yyyy').format(vacDetails['dueDate'])}',
                          style: AppTypography.bodyMedium.copyWith(color: Colors.grey.shade600),
                        ),
                        
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('View Full Schedule (पूरा चार्ट देखें)'),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddChildForm(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Child', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
