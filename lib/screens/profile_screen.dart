import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/widgets/custom_text_field.dart';

class ProfileScreen extends StatelessWidget {
  final AppState appState;

  const ProfileScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final student = appState.currentStudent;
    final isDark = appState.isDarkMode;

    if (student == null) return const SizedBox();

    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) {
        final currentStudent = appState.currentStudent!;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Profile Photo Header
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF4F46E5),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4F46E5).withOpacity(0.15),
                            blurRadius: 20,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(currentStudent.avatarUrl),
                        backgroundColor: Colors.indigo.shade50,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4F46E5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Full Name & ID
              Text(
                currentStudent.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${appState.translate('student_id')}: ${currentStudent.id}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.indigo.shade300 : Colors.indigo.shade600,
                ),
              ),
              const SizedBox(height: 24),
              
              // Detailed info cards list
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    _buildInfoTile(
                      icon: Icons.school_rounded,
                      label: appState.translate('major'),
                      value: currentStudent.major,
                      isDark: isDark,
                      isFirst: true,
                    ),
                    _buildInfoTile(
                      icon: Icons.calendar_today_rounded,
                      label: appState.translate('academic_year'),
                      value: currentStudent.academicYear,
                      isDark: isDark,
                    ),
                    _buildInfoTile(
                      icon: Icons.email_rounded,
                      label: 'Email',
                      value: currentStudent.email,
                      isDark: isDark,
                    ),
                    _buildInfoTile(
                      icon: Icons.phone_rounded,
                      label: appState.translate('phone_number'),
                      value: currentStudent.phoneNumber,
                      isDark: isDark,
                    ),
                    _buildInfoTile(
                      icon: Icons.star_rate_rounded,
                      label: 'Current GPA',
                      value: currentStudent.gpa.toStringAsFixed(2),
                      isDark: isDark,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Edit Profile Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 1,
                  ),
                  onPressed: () => _showEditProfileSheet(context),
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  label: Text(
                    appState.translate('edit_profile'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  width: 1.5,
                ),
              ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4F46E5), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context) {
    final student = appState.currentStudent!;
    final nameController = TextEditingController(text: student.name);
    final phoneController = TextEditingController(text: student.phoneNumber);
    final avatarController = TextEditingController(text: student.avatarUrl);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = appState.isDarkMode;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                appState.translate('edit_profile'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: nameController,
                labelText: appState.translate('full_name_hint'),
                hintText: 'John Doe',
                prefixIcon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: phoneController,
                labelText: appState.translate('phone_number'),
                hintText: '+855 12 345 678',
                prefixIcon: Icons.phone_android_rounded,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: avatarController,
                labelText: 'Avatar Image URL',
                hintText: 'https://images.unsplash.com/...',
                prefixIcon: Icons.image_search_rounded,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        appState.translate('cancel'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        if (nameController.text.trim().isNotEmpty && phoneController.text.trim().isNotEmpty) {
                          appState.updateStudentProfile(
                            name: nameController.text.trim(),
                            phoneNumber: phoneController.text.trim(),
                            avatarUrl: avatarController.text.trim(),
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(appState.translate('profile_updated')),
                              backgroundColor: const Color(0xFF10B981),
                            ),
                          );
                        }
                      },
                      child: Text(
                        appState.translate('save'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
