import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/layout/custom_card.dart';
import '../controllers/scan_history_controller.dart';
import '../models/product.dart';
import '../models/compliance.dart';
import '../controllers/product_controller.dart';
import '../controllers/preferences_controller.dart';

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scanHistoryController = Get.put(ScanHistoryController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan History',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (scanHistoryController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (scanHistoryController.scans.isEmpty) {
          return _buildEmptyState(context);
        }
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: scanHistoryController.scans.length,
            itemBuilder: (context, index) {
              final scan = scanHistoryController.scans[index];
              return _buildHistoryItem(context, scan);
            },
          ),
        );
      }),
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

  Widget _buildHistoryItem(BuildContext context, scan) {
    // Determine status based on compliance
    bool compliant = scan.product.compliance.compliant;
    List<Map<String, String>> issues = scan.product.compliance.issues;
    String status = compliant && issues.isEmpty ? 'Safe' : 'Not recommended';
    
    Color statusColor = status == 'Safe' 
        ? Theme.of(context).colorScheme.primary 
        : status == 'Contains allergen' 
            ? Theme.of(context).colorScheme.error 
            : Theme.of(context).colorScheme.secondary;
    
    Color statusContainerColor = status == 'Safe' 
        ? Theme.of(context).colorScheme.primaryContainer 
        : status == 'Contains allergen' 
            ? Theme.of(context).colorScheme.errorContainer 
            : Theme.of(context).colorScheme.secondaryContainer;

    // Format the scanned_at date
    String formattedDate = scan.scannedAt.isNotEmpty 
        ? DateTime.parse(scan.scannedAt).toString().split(' ')[0] 
        : 'Unknown date';
    String formattedTime = scan.scannedAt.isNotEmpty 
        ? DateTime.parse(scan.scannedAt).toString().split(' ')[1].substring(0, 5) 
        : 'Unknown time';

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
            child: scan.product.imageUrl != null && scan.product.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      scan.product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.image,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
          ),
          title: Text(
            scan.product.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                scan.product.brand,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '$formattedDate at $formattedTime',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusContainerColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            // Set the product in the product controller and navigate to product screen
            Get.find<ProductController>().product.value = scan.product;
            Get.toNamed('/product');
          },
        ),
      ),
    );
  }
}