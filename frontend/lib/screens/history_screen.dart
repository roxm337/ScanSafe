import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock scan history data
    final scanHistory = [
      {
        'id': '1',
        'productName': 'Organic Apple Juice',
        'brand': 'Nature\'s Best',
        'date': 'Today, 14:32',
        'status': 'Safe',
        'imageUrl': 'https://via.placeholder.com/60x60',
      },
      {
        'id': '2',
        'productName': 'Gluten-Free Bread',
        'brand': 'Healthy Bakes',
        'date': 'Yesterday, 09:15',
        'status': 'Contains allergen',
        'imageUrl': 'https://via.placeholder.com/60x60',
      },
      {
        'id': '3',
        'productName': 'Protein Bar',
        'brand': 'Fit Snacks',
        'date': 'Oct 1, 18:45',
        'status': 'Safe',
        'imageUrl': 'https://via.placeholder.com/60x60',
      },
      {
        'id': '4',
        'productName': 'Baby Shampoo',
        'brand': 'Gentle Care',
        'date': 'Sep 30, 16:20',
        'status': 'Not recommended',
        'imageUrl': 'https://via.placeholder.com/60x60',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan History',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: scanHistory.isEmpty
          ? _buildEmptyState(context)
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: scanHistory.length,
                itemBuilder: (context, index) {
                  final scan = scanHistory[index];
                  return _buildHistoryItem(context, scan);
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8A2BE2), // Purple
                  Color(0xFF40E0D0), // Turquoise
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.history,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Scan History',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your scanned products will appear here',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8A2BE2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Scan a Product',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, Map<String, dynamic> scan) {
    bool isSafe = scan['status'] == 'Safe';
    Color statusColor = isSafe 
        ? const Color(0xFF4CAF50) // Green
        : scan['status'] == 'Contains allergen'
            ? const Color(0xFFF44336) // Red
            : const Color(0xFFFF9800); // Orange
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: Icon(
                Icons.image,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scan['productName'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    scan['brand'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scan['date'],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                scan['status'],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}