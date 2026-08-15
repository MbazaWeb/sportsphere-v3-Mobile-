import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Ultra glassmorphism — iPhone-level depth.
/// Multi-layer blur, soft specular edge, deep shadow.
class GlassCard extends StatefulWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 18,
    this.onTap,
    this.enableHover = true,
    this.glow = false,
    this.borderColor,
    this.blur = 24,
    this.opacity = 0.07,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool enableHover;
  final bool glow;
  final Color? borderColor;
  final double blur;
  final double opacity;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.enableHover && _hovered;
    final pressed = _pressed;

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap?.call();
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: pressed ? 0.985 : (active ? 1.01 : 1.0),
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              transform: active
                  ? (Matrix4.identity()..translate(0.0, -3.0))
                  : Matrix4.identity(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: [
                  // Deep ambient
                  BoxShadow(
                    color: Colors.black.withValues(alpha: active ? 0.45 : 0.35),
                    blurRadius: active ? 48 : 36,
                    offset: const Offset(0, 14),
                    spreadRadius: -4,
                  ),
                  // Soft gold rim light
                  if (widget.glow || active)
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: active ? 0.18 : 0.08),
                      blurRadius: active ? 40 : 24,
                      spreadRadius: 0,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: widget.blur,
                    sigmaY: widget.blur,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      // Layered glass fill
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: widget.opacity + 0.04),
                          Colors.white.withValues(alpha: widget.opacity),
                          Colors.white.withValues(alpha: widget.opacity - 0.01),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                      border: Border.all(
                        width: 1,
                        color: widget.borderColor ??
                            Colors.white.withValues(alpha: active ? 0.18 : 0.10),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Specular top highlight (iOS glass edge)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 1.2,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(widget.borderRadius),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.0),
                                  Colors.white.withValues(alpha: 0.22),
                                  Colors.white.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: widget.padding,
                          child: widget.child,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Staggered entrance — soft scale + fade + rise (posts “grow” in).
class AnimatedGlassCard extends StatefulWidget {
  const AnimatedGlassCard({
    super.key,
    required this.child,
    this.index = 0,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 18,
    this.onTap,
    this.glow = false,
  });

  final Widget child;
  final int index;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool glow;

  @override
  State<AnimatedGlassCard> createState() => _AnimatedGlassCardState();
}

class _AnimatedGlassCardState extends State<AnimatedGlassCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    final delayMs = (widget.index * 55).clamp(0, 400);
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    final curved = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    _opacity = Tween<double>(begin: 0, end: 1).animate(curved);
    _scale = Tween<double>(begin: 0.94, end: 1.0).animate(curved);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(curved);

    Future.delayed(Duration(milliseconds: delayMs), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          child: GlassCard(
            padding: widget.padding,
            borderRadius: widget.borderRadius,
            onTap: widget.onTap,
            glow: widget.glow,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
