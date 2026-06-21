import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/services/auth_service.dart';
import 'package:project_flutter/widgets/custom_text_field.dart';
import 'package:project_flutter/screens/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final AuthService _authService = AuthService();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;

  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(_passwordController.text);
  bool get _hasLowercase => RegExp(r'[a-z]').hasMatch(_passwordController.text);
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_passwordController.text);
  bool get _hasSymbol =>
      RegExp(r'[^A-Za-z0-9\s]').hasMatch(_passwordController.text);
  bool get _isStrongPassword =>
      _hasUppercase && _hasLowercase && _hasNumber && _hasSymbol;

  int get _passwordScore {
    return [
      _hasUppercase,
      _hasLowercase,
      _hasNumber,
      _hasSymbol,
    ].where((hasRule) => hasRule).length;
  }

  bool _isValidGmail(String email) {
    return RegExp(
      r'^[A-Za-z0-9._%+-]+@gmail\.com$',
      caseSensitive: false,
    ).hasMatch(email);
  }

  String _passwordStrengthLabel() {
    switch (_passwordScore) {
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Very weak';
    }
  }

  Color _passwordStrengthColor() {
    switch (_passwordScore) {
      case 1:
        return Colors.redAccent;
      case 2:
        return const Color(0xFFF59E0B);
      case 3:
        return const Color(0xFF3B82F6);
      case 4:
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  void _handleRegister(AppState appState) async {
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    bool hasError = false;

    if (name.isEmpty) {
      _nameError = appState.translate('empty_fields_error');
      hasError = true;
    }

    if (email.isEmpty) {
      _emailError = appState.translate('empty_fields_error');
      hasError = true;
    } else if (!_isValidGmail(email)) {
      _emailError = 'Please use a valid Gmail address like example@gmail.com.';
      hasError = true;
    }

    if (password.isEmpty) {
      _passwordError = appState.translate('empty_fields_error');
      hasError = true;
    } else if (!_isStrongPassword) {
      _passwordError =
          'Password must include uppercase, lowercase, number, and symbol.';
      hasError = true;
    }

    if (confirmPassword.isEmpty) {
      _confirmPasswordError = appState.translate('empty_fields_error');
      hasError = true;
    } else if (password != confirmPassword) {
      _confirmPasswordError = appState.translate('passwords_dont_match');
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Please fix the Gmail and password requirements before registering.',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final student = await _authService.register(
        name,
        email,
        password,
        confirmPassword,
      );
      appState.loginStudent(student);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(appState.translate('profile_updated'))),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = appState.translate('error_loading');
        final errorMsg = e.toString();
        if (errorMsg.contains('fields_empty')) {
          errorMessage = appState.translate('empty_fields_error');
        } else if (errorMsg.contains('invalid_email')) {
          errorMessage = appState.translate('invalid_email');
        } else if (errorMsg.contains('passwords_dont_match')) {
          errorMessage = appState.translate('passwords_dont_match');
        } else if (errorMsg.contains('email_exists')) {
          errorMessage = 'This Gmail account is already registered.';
          setState(() => _emailError = errorMessage);
        } else if (errorMsg.contains('account_storage_failed')) {
          errorMessage = 'Could not save the account JSON file.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.appState;
    final isDark = appState.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  appState.translate('register'),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create a student portal account to get started.',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),

                // Form Card Container
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black38
                            : theme.primaryColor.withOpacity(0.04),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : theme.primaryColor.withOpacity(0.05),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        labelText: appState.translate('full_name_hint'),
                        hintText: 'John Doe',
                        prefixIcon: Icons.person_outline_rounded,
                        errorText: _nameError,
                        onChanged: (value) {
                          if (_nameError != null) {
                            setState(() => _nameError = null);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Gmail',
                        hintText: 'example@gmail.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        errorText: _emailError,
                        onChanged: (value) {
                          if (_emailError != null) {
                            setState(() => _emailError = null);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: appState.translate('password_hint'),
                        hintText: '••••••••',
                        prefixIcon: Icons.lock_outlined,
                        isPassword: true,
                        errorText: _passwordError,
                        onChanged: (value) {
                          setState(() {
                            if (_passwordError != null &&
                                (value.isEmpty || _isStrongPassword)) {
                              _passwordError = null;
                            }
                            if (_confirmPasswordError != null &&
                                _confirmPasswordController.text == value) {
                              _confirmPasswordError = null;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _PasswordStrengthMeter(
                        score: _passwordScore,
                        label: _passwordStrengthLabel(),
                        color: _passwordStrengthColor(),
                        requirements: [
                          _PasswordRequirement(
                            label: 'Uppercase',
                            isMet: _hasUppercase,
                          ),
                          _PasswordRequirement(
                            label: 'Lowercase',
                            isMet: _hasLowercase,
                          ),
                          _PasswordRequirement(
                            label: 'Number',
                            isMet: _hasNumber,
                          ),
                          _PasswordRequirement(
                            label: 'Symbol',
                            isMet: _hasSymbol,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        labelText: appState.translate('confirm_password_hint'),
                        hintText: '••••••••',
                        prefixIcon: Icons.lock_clock_outlined,
                        isPassword: true,
                        errorText: _confirmPasswordError,
                        onChanged: (value) {
                          if (_confirmPasswordError != null &&
                              value == _passwordController.text) {
                            setState(() => _confirmPasswordError = null);
                          }
                        },
                      ),
                      const SizedBox(height: 32),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () => _handleRegister(appState),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  appState.translate('register'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Navigation to Login
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      appState.translate('already_have_account'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordRequirement {
  final String label;
  final bool isMet;

  const _PasswordRequirement({required this.label, required this.isMet});
}

class _PasswordStrengthMeter extends StatelessWidget {
  final int score;
  final String label;
  final Color color;
  final List<_PasswordRequirement> requirements;

  const _PasswordStrengthMeter({
    required this.score,
    required this.label,
    required this.color,
    required this.requirements,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: score / 4,
                  minHeight: 8,
                  color: color,
                  backgroundColor: inactiveColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: requirements.map((requirement) {
            final itemColor = requirement.isMet
                ? const Color(0xFF10B981)
                : const Color(0xFF94A3B8);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  requirement.isMet
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 15,
                  color: itemColor,
                ),
                const SizedBox(width: 4),
                Text(
                  requirement.label,
                  style: TextStyle(
                    color: itemColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
