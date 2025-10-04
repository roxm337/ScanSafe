import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../theme.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App bar with gradient
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.secondaryColor,
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
                          width: 4,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.pastelPurple,
                            AppTheme.pastelPink,
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(() => Text(
                          authController.user.value?.name ?? 'User',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )),
                    SizedBox(height: 8),
                    Obx(() => Text(
                          authController.user.value?.email ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Settings section
                  _buildSettingsCard(context),
                  SizedBox(height: 16),
                  // Preferences section
                  _buildPreferencesCard(context),
                  SizedBox(height: 16),
                  // Saved products section
                  _buildSavedProductsCard(context),
                  SizedBox(height: 16),
                  // Logout button
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.pastelPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.settings,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            title: Text(
              'Settings',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondaryColor,
            ),
            onTap: () => Get.toNamed('/settings'),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.pastelBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.notifications,
                color: AppTheme.secondaryColor,
                size: 20,
              ),
            ),
            title: Text(
              'Notifications',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: AppTheme.primaryColor,
              activeTrackColor: AppTheme.primaryColor.withOpacity(0.3),
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.pastelPink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.privacy_tip,
                color: AppTheme.accentColor,
                size: 20,
              ),
            ),
            title: Text(
              'Privacy Policy',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondaryColor,
            ),
            onTap: () => Get.toNamed('/privacy'),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.pastelTurquoise.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.favorite,
                color: AppTheme.secondaryColor,
                size: 20,
              ),
            ),
            title: Text(
              'Personal Preferences',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondaryColor,
            ),
            onTap: () => Get.toNamed('/preferences'),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.pastelMint.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.local_pharmacy,
                color: Colors.green,
                size: 20,
              ),
            ),
            title: Text(
              'Dietary Restrictions',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondaryColor,
            ),
            onTap: () => Get.toNamed('/preferences'),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.pastelLavender.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.warning,
                color: Colors.orange,
                size: 20,
              ),
            ),
            title: Text(
              'Allergen Alerts',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondaryColor,
            ),
            onTap: () => Get.toNamed('/preferences'),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedProductsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.pastelPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.bookmark,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            title: Text(
              'Saved Products',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            subtitle: Text(
              'View and manage your saved products',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondaryColor,
            ),
            onTap: () => Get.toNamed('/saved'),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.pastelBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.history,
                color: AppTheme.secondaryColor,
                size: 20,
              ),
            ),
            title: Text(
              'Scan History',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            subtitle: Text(
              'View your recent scans',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondaryColor,
            ),
            onTap: () => Get.toNamed('/history'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.secondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: () {
          authController.logout();
        },
        child: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}