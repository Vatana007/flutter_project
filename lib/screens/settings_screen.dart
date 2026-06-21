import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/widgets/custom_text_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final state = context.appState;
    final isDark = state.isDarkMode;
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: state,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              state.translate('settings'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: theme.primaryColor,
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
              Card(
                margin: EdgeInsets.zero,
                child: SwitchListTile(
                  secondary: Icon(
                    Icons.dark_mode_rounded,
                    color: theme.primaryColor,
                  ),
                  title: Text(
                    state.translate('dark_mode'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  value: isDark,
                  activeColor: theme.primaryColor,
                  activeTrackColor: theme.primaryColor.withOpacity(0.3),
                  onChanged: (bool value) {
                    state.toggleTheme(value);
                  },
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionHeader('Localization', isDark),
              const SizedBox(height: 12),
              
              // Language Switcher Dropdown
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.language_rounded, color: theme.primaryColor),
                          const SizedBox(width: 16),
                          Text(
                            state.translate('language'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      DropdownButton<AppLanguage>(
                        value: state.language,
                        dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        underline: const SizedBox(),
                        icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.primaryColor),
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
              ),
              const SizedBox(height: 24),

              _buildSectionHeader('Security', isDark),
              const SizedBox(height: 12),
              
              // Change Password Button
              Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: Icon(Icons.lock_reset_rounded, color: theme.primaryColor),
                  title: Text(
                    state.translate('change_password'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                  onTap: () => _showChangePasswordSheet(context, state),
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

  void _showChangePasswordSheet(BuildContext context, AppState appState) {
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
        final isDark = appState.isDarkMode;
        final theme = Theme.of(context);
        
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
                    appState.translate('change_password'),
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
                            appState.translate('cancel'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
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
                              currentPassError = appState.translate('empty_fields_error');
                              hasErr = true;
                            }
                            if (newPasswordController.text.isEmpty) {
                              newPassError = appState.translate('empty_fields_error');
                              hasErr = true;
                            }
                            if (confirmPasswordController.text.isEmpty) {
                              confirmPassError = appState.translate('empty_fields_error');
                              hasErr = true;
                            } else if (newPasswordController.text != confirmPasswordController.text) {
                              confirmPassError = appState.translate('passwords_dont_match');
                              hasErr = true;
                            }

                            if (hasErr) {
                              setModalState(() {});
                              return;
                            }

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text(appState.translate('password_changed'))),
                                  ],
                                ),
                                backgroundColor: const Color(0xFF0D9488),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );
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
      },
    );
  }
}
