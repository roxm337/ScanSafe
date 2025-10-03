import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../components/inputs/custom_text_field.dart';
import '../components/buttons/custom_elevated_button.dart';
import '../components/layout/custom_card.dart';
import '../utils/validation.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Create\nAccount',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Join ScanSafe to start scanning products',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 40),
              CustomCard(
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      controller: nameController,
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      validator: ValidationUtils.validateName,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Email',
                      hint: 'Enter your email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      validator: ValidationUtils.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: passwordController,
                      obscureText: true,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      validator: ValidationUtils.validatePassword,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Confirm Password',
                      hint: 'Confirm your password',
                      controller: confirmPasswordController,
                      obscureText: true,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      validator: (value) => ValidationUtils.validateConfirmPassword(
                        value, 
                        passwordController.text,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Obx(() => CustomElevatedButton(
                          text: 'Create Account',
                          isLoading: authController.isLoading.value,
                          onPressed: () {
                            authController.register(
                              nameController.text,
                              emailController.text,
                              passwordController.text,
                              confirmPasswordController.text,
                            );
                          },
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      children: const [
                        TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
