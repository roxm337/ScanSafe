import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/layout/custom_card.dart';

class ScanHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock scan history data
    final scanHistory = [
      {
        'id': '1',
        'productName': 'Organic Apple Juice',
        'brand': 'Nature\'s Best',
        'date': '2023-06-15',
        'time': '14:32',
        'status': 'Safe',
        'image': 'https://via.placeholder.com/60x60',
      },
      {
        'id': '2',
        'productName': 'Gluten-Free Bread',
        'brand': 'Healthy Bakes',
        'date': '2023-06-14',
        'time': '09:15',
        'status': 'Contains allergen',
        'image': 'https://via.placeholder.com/60x60',
      },
      {
        'id': '3',
        'productName': 'Protein Bar',
        'brand': 'Fit Snacks',
        'date': '2023-06-13',
        'time': '18:45',
        'status': 'Safe',
        'image': 'https://via.placeholder.com/60x60',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan History',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
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
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.history,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Scan History',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Your scanned products will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Navigate to scan screen
              Get.toNamed('/scan');
            },
            child: Text('Scan a Product'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, Map<String, dynamic> scan) {
    bool isSafe = scan['status'] == 'Safe';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        child: ListTile(
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
            child: Icon(
              Icons.image,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          title: Text(
            scan['productName'],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                scan['brand'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '${scan['date']} at ${scan['time']}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSafe 
                  ? Theme.of(context).colorScheme.primaryContainer 
                  : Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              scan['status'],
              style: TextStyle(
                color: isSafe 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            // Navigate to product details
            Get.snackbar('Product Details', 'Product details for ${scan['productName']} would be shown here');
          },
        ),
      ),
    );
  }
}