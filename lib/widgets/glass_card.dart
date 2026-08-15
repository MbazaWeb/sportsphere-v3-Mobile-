import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Glassmorphism card matching the original `.glass-card` CSS.
/// Supports hover elevation and optional gold glow.
class GlassCard extends StatefulWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 12,
    this.onTap,
    this.enableHover = true,
    this.glow = false,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool enableHover;
  final bool glow;
  final Color? borderColor;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.enableHover && _hovered;

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            transform: isActive
                ? (Matrix4.identity()..translate(0.0, -2.0))
                : Matrix4.identity(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isActive ? 0.3 : 0.2),
                  blurRadius: isActive ? 40 : 32,
                  offset: const Offset(0, 8),
                ),
                if (widget.glow || isActive)
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: isActive ? 0.25 : 0.15),
                    blurRadius: isActive ? 50 : 30,
                    spreadRadius: 0,
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: widget.padding,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.cardHover : AppColors.card,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: isActive
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : (widget.borderColor ?? AppColors.cardBorder),
                      width: 1,
                    ),
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
