import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/services/auth_service.dart';
import 'package:project_flutter/widgets/custom_text_field.dart';
import 'package:project_flutter/screens/login_screen.dart';
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
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;

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
    } else if (!email.contains('@') || !email.contains('.')) {
      _emailError = appState.translate('invalid_email');
      hasError = true;
    }

    if (password.isEmpty) {
      _passwordError = appState.translate('empty_fields_error');
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
      return;
    }

    setState(() => _isLoading = true);

    try {
      final student = await _authService.register(name, email, password, confirmPassword);
      appState.loginStudent(student);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(appState.translate('profile_updated')),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MainScreen(appState: appState),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        String errorKey = 'error_loading';
        final errorMsg = e.toString();
        if (errorMsg.contains('fields_empty')) {
          errorKey = 'empty_fields_error';
        } else if (errorMsg.contains('invalid_email')) {
          errorKey = 'invalid_email';
        } else if (errorMsg.contains('passwords_dont_match')) {
          errorKey = 'passwords_dont_match';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(appState.translate(errorKey)),
            backgroundColor: Colors.redAccent,
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
    final appState = AppStateProvider.of(context);
    final isDark = appState.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appState.translate('register'),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create a student portal account to get started.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              
              // Register Fields
              CustomTextField(
                controller: _nameController,
                labelText: appState.translate('full_name_hint'),
                hintText: 'John Doe',
                prefixIcon: Icons.person_outline_rounded,
                errorText: _nameError,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _emailController,
                labelText: appState.translate('email_hint'),
                hintText: 'john.doe@edutrack.edu.kh',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                labelText: appState.translate('password_hint'),
                hintText: '••••••••',
                prefixIcon: Icons.lock_outlined,
                isPassword: true,
                errorText: _passwordError,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: appState.translate('confirm_password_hint'),
                hintText: '••••••••',
                prefixIcon: Icons.lock_clock_outlined,
                isPassword: true,
                errorText: _confirmPasswordError,
              ),
              const SizedBox(height: 32),
              
              // Register Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: const Color(0xFF4F46E5).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _isLoading ? null : () => _handleRegister(appState),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
              const SizedBox(height: 24),
              
              // Back to login
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    appState.translate('already_have_account'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.indigo.shade300 : Colors.indigo.shade600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
