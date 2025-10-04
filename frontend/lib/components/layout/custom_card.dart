import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? color;
  final double? borderRadius;
  final BoxShadow? shadow;

  const CustomCard({
    Key? key,
    required this.child,
    this.margin,
    this.padding,
    this.color,
    this.borderRadius,
    this.shadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? const EdgeInsets.all(16),
      color: color ?? Theme.of(context).cardTheme.color,
      elevation: shadow != null ? 0 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: Container(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
      shadowColor: shadow?.color ?? Theme.of(context).shadowColor,
      surfaceTintColor: color ?? Theme.of(context).cardTheme.color,
    );
  }
}