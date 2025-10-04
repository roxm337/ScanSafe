import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../theme.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Scan to Discover',
      'subtitle': 'Quickly scan product barcodes to check ingredients and safety',
      'image': 'assets/images/onboarding1.png', // Placeholder for now
    },
    {
      'title': 'Know What You Consume',
      'subtitle': 'Get detailed information about ingredients and potential allergens',
      'image': 'assets/images/onboarding2.png',
    },
    {
      'title': 'AI-Powered Safety',
      'subtitle': 'Get personalized safety recommendations based on your needs',
      'image': 'assets/images/onboarding3.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.pastelPurple,
                  AppTheme.pastelPink,
                  AppTheme.pastelBlue,
                ],
              ),
            ),
          ),
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return _buildPage(
                index,
                _onboardingData[index]['title']!,
                _onboardingData[index]['subtitle']!,
                _onboardingData[index]['image']!,
              );
            },
          ),
          // Skip button
          Positioned(
            top: 60,
            right: 20,
            child: TextButton(
              onPressed: () {
                Get.offAllNamed('/login');
              },
              child: Text(
                'Skip',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Page indicator
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicators(),
            ),
          ),
          // Next button
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: _currentPage == _onboardingData.length - 1
                ? Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.secondaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Get.offAllNamed('/login');
                      },
                      child: Text(
                        'Get Started',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(
                        'Next',
                        style: GoogleFonts.poppins(
                          color: AppTheme.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index, String title, String subtitle, String image) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 1),
          // Image container with gradient background
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.pastelLavender,
                  AppTheme.pastelMint,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.qr_code_scanner,
                size: 180,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          Spacer(flex: 1),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicators() {
    return List.generate(
      _onboardingData.length,
      (index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        width: _currentPage == index ? 24 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: _currentPage == index
              ? Colors.white
              : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}