import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/buttons/app_button.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onBack;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onBack,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              GestureDetector(
                onTap: widget.onBack,
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 32),
              Text('Welcome Back', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'Please enter your details to login.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.cardSm),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.cardSm),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              AppButton.primaryWithArrow(
                label: 'Login',
                onPressed: widget.onLoginSuccess,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
