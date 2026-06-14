import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/widgets/custom_text_field.dart';

class SettingsScreen extends StatefulWidget {
  final AppState appState;

  const SettingsScreen({super.key, required this.appState});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final state = widget.appState;
    final isDark = state.isDarkMode;

    return ListenableBuilder(
      listenable: state,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
            centerTitle: true,
            title: Text(
              state.translate('settings'),
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: isDark ? Colors.indigo.shade300 : const Color(0xFF4F46E5),
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildSectionHeader('Preferences', isDark),
              const SizedBox(height: 12),
              
              // Dark Mode Toggle
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    width: 1,
                  ),
                ),
                child: SwitchListTile(
                  secondary: const Icon(
                    Icons.dark_mode_rounded,
                    color: Color(0xFF4F46E5),
                  ),
                  title: Text(
                    state.translate('dark_mode'),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  value: isDark,
                  activeColor: const Color(0xFF10B981),
                  activeTrackColor: const Color(0xFF10B981).withOpacity(0.3),
                  onChanged: (bool value) {
                    state.toggleTheme(value);
                  },
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionHeader('Localization', isDark),
              const SizedBox(height: 12),
              
              // Language Switcher Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.language_rounded, color: Color(0xFF4F46E5)),
                        const SizedBox(width: 16),
                        Text(
                          state.translate('language'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    DropdownButton<AppLanguage>(
                      value: state.language,
                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF4F46E5)),
                      items: const [
                        DropdownMenuItem(
                          value: AppLanguage.english,
                          child: Text('English (US)'),
                        ),
                        DropdownMenuItem(
                          value: AppLanguage.khmer,
                          child: Text('ភាសាខ្មែរ (Khmer)'),
                        ),
                      ],
                      onChanged: (AppLanguage? newLang) {
                        if (newLang != null) {
                          state.setLanguage(newLang);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionHeader('Security', isDark),
              const SizedBox(height: 12),
              
              // Change Password Button
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    width: 1,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.lock_reset_rounded, color: Color(0xFF4F46E5)),
                  title: Text(
                    state.translate('change_password'),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                  onTap: () => _showChangePasswordSheet(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
        letterSpacing: 1.0,
      ),
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    String? currentPassError;
    String? newPassError;
    String? confirmPassError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = widget.appState.isDarkMode;
        
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                    widget.appState.translate('change_password'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: currentPasswordController,
                    labelText: 'Current Password',
                    hintText: '••••••••',
                    prefixIcon: Icons.lock_outline_rounded,
                    isPassword: true,
                    errorText: currentPassError,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: newPasswordController,
                    labelText: 'New Password',
                    hintText: '••••••••',
                    prefixIcon: Icons.lock_open_rounded,
                    isPassword: true,
                    errorText: newPassError,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: confirmPasswordController,
                    labelText: 'Confirm New Password',
                    hintText: '••••••••',
                    prefixIcon: Icons.lock_clock_outlined,
                    isPassword: true,
                    errorText: confirmPassError,
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
                            widget.appState.translate('cancel'),
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
                            setModalState(() {
                              currentPassError = null;
                              newPassError = null;
                              confirmPassError = null;
                            });

                            bool hasErr = false;
                            if (currentPasswordController.text.isEmpty) {
                              currentPassError = widget.appState.translate('empty_fields_error');
                              hasErr = true;
                            }
                            if (newPasswordController.text.isEmpty) {
                              newPassError = widget.appState.translate('empty_fields_error');
                              hasErr = true;
                            }
                            if (confirmPasswordController.text.isEmpty) {
                              confirmPassError = widget.appState.translate('empty_fields_error');
                              hasErr = true;
                            } else if (newPasswordController.text != confirmPasswordController.text) {
                              confirmPassError = widget.appState.translate('passwords_dont_match');
                              hasErr = true;
                            }

                            if (hasErr) {
                              // Force re-draw of modal state
                              setModalState(() {});
                              return;
                            }

                            // Simulation save
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(widget.appState.translate('password_changed')),
                                backgroundColor: const Color(0xFF10B981),
                              ),
                            );
                          },
                          child: Text(
                            widget.appState.translate('save'),
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
      },
    );
  }
}
