import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../components/inputs/custom_text_field.dart';
import '../components/buttons/custom_elevated_button.dart';
import '../components/layout/custom_card.dart';
import '../utils/validation.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                'Welcome\nBack',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue to your account',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 40),
              CustomCard(
                child: Column(
                  children: [
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
                    const SizedBox(height: 32),
                    Obx(() => CustomElevatedButton(
                          text: 'Sign In',
                          isLoading: authController.isLoading.value,
                          onPressed: () {
                            authController.login(
                              emailController.text,
                              passwordController.text,
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
                    Get.toNamed('/register');
                  },
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      children: const [
                        TextSpan(text: 'Don\'t have an account? '),
                        TextSpan(
                          text: 'Sign Up',
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
