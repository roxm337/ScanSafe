import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final bool isFullWidth;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.isFullWidth = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : width,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? Colors.white,
                  ),
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor ?? Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
      ),
    );
  }
}