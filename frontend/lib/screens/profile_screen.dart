import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../components/layout/custom_card.dart';
import '../components/buttons/custom_elevated_button.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with gradient
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primaryContainer,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        color: Colors.white,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() => Text(
                          authController.user.value?.name ?? 'Guest User',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        )),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                          authController.user.value?.email ?? 'Not logged in',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                        )),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Settings and features card
                  CustomCard(
                    child: Column(
                      children: [
                        _buildProfileItem(
                          context: context,
                          icon: Icons.person_outline,
                          label: 'Full Name',
                          value: Obx(() => Text(
                            authController.user.value?.name ?? 'N/A',
                            style: Theme.of(context).textTheme.titleMedium,
                          )),
                        ),
                        const Divider(height: 24),
                        _buildProfileItem(
                          context: context,
                          icon: Icons.email_outlined,
                          label: 'Email Address',
                          value: Obx(() => Text(
                            authController.user.value?.email ?? 'N/A',
                            style: Theme.of(context).textTheme.titleMedium,
                          )),
                        ),
                        const Divider(height: 24),
                        _buildProfileItem(
                          context: context,
                          icon: Icons.history,
                          label: 'Scan History',
                          value: Text(
                            'View your scan history',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          onTap: () {
                            // Navigate to scan history
                            Get.toNamed('/scan-history');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Additional features
                  CustomCard(
                    child: Column(
                      children: [
                        _buildFeatureItem(
                          context: context,
                          icon: Icons.history,
                          title: 'Scan History',
                          subtitle: 'View your previous scans',
                          onTap: () {
                            Get.toNamed('/scan-history');
                          },
                        ),
                        const Divider(),
                        _buildFeatureItem(
                          context: context,
                          icon: Icons.person_pin,
                          title: 'Personal Profile',
                          subtitle: 'Set allergies & preferences',
                          onTap: () {
                            Get.toNamed('/preferences');
                          },
                        ),
                        const Divider(),
                        _buildFeatureItem(
                          context: context,
                          icon: Icons.settings,
                          title: 'Settings',
                          subtitle: 'App preferences and customization',
                          onTap: () {
                            Get.toNamed('/settings');
                          },
                        ),
                        const Divider(),
                        _buildFeatureItem(
                          context: context,
                          icon: Icons.info_outline,
                          title: 'About',
                          subtitle: 'Learn more about the app',
                          onTap: () {
                            Get.toNamed('/about');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Logout button
                  CustomElevatedButton(
                    text: 'Logout',
                    backgroundColor: Theme.of(context).colorScheme.error,
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Widget value,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
      subtitle: Container(
        margin: const EdgeInsets.only(top: 4),
        child: value,
      ),
      trailing: onTap != null ? Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ) : null,
      onTap: onTap,
    );
  }

  Widget _buildFeatureItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Logout',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Obx(() => CustomElevatedButton(
                text: authController.isLoading.value ? 'Logging out...' : 'Logout',
                backgroundColor: Theme.of(context).colorScheme.error,
                onPressed: () {
                  authController.logout();
                  Get.back();
                },
              )),
        ],
      ),
    );
  }
}
