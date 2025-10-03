import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/scan_controller.dart';
import '../components/inputs/custom_text_field.dart';
import '../components/buttons/custom_elevated_button.dart';


class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ScanController scanController = Get.put(ScanController());
  late final TextEditingController eanController;
  bool _showCameraScanner = false;
  bool _showManualEntry = false;

  @override
  void initState() {
    super.initState();
    eanController = TextEditingController();
  }

  @override
  void dispose() {
    eanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan Product',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _showCameraScanner
            ? _buildCameraScanner(context)
            : _showManualEntry
                ? _buildManualEntry(context)
                : _buildScanOptions(context),
      ),
    );
  }

  Widget _buildScanOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App logo/title area
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.qr_code_scanner,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Product Scanner',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Choose how you want to scan your product',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 48),
          // Option to scan with camera
          _buildOptionCard(
            context: context,
            title: 'Scan with Camera',
            subtitle: 'Use your camera to scan barcodes',
            icon: Icons.camera_alt_outlined,
            onPressed: () {
              setState(() {
                _showCameraScanner = true;
              });
            },
          ),
          const SizedBox(height: 16),
          // Option for manual entry
          _buildOptionCard(
            context: context,
            title: 'Manual Entry',
            subtitle: 'Enter EAN/UPC code manually',
            icon: Icons.edit_outlined,
            onPressed: () {
              setState(() {
                _showManualEntry = true;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
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
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraScanner(BuildContext context) {
    return Stack(
      children: [
        // Scanner preview
        MobileScanner(
          controller: scanController.scannerController,
          onDetect: scanController.onDetect,
        ),
        // Scanner overlay with animation
        Center(
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        // Animated scanning line
        Center(
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: 276,
            height: 4,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // Scanner instruction
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Text(
            'Align the barcode within the frame',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ],
                ),
          ),
        ),
        // Cancel button
        Positioned(
          top: 60,
          left: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _showCameraScanner = false;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManualEntry(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {
                  setState(() {
                    _showManualEntry = false;
                  });
                },
              ),
              const SizedBox(width: 8),
              Text(
                'Manual Entry',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Manual entry field
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.edit_note,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Enter Product Code',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(
                  'Enter the EAN/UPC code from the product packaging',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'EAN/UPC Code',
                  hint: 'Enter product code',
                  controller: eanController,
                  prefixIcon: Icon(
                    Icons.qr_code_scanner_outlined,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() => CustomElevatedButton(
                      text: 'Scan Product',
                      isLoading: scanController.isLoading.value,
                      onPressed: () {
                        if (eanController.text.isNotEmpty) {
                          scanController.manualScan(eanController.text);
                        }
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
