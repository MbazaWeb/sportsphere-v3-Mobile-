import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _words = [
    'Player',
    'Sport',
    'Game',
    'Team',
    'Community',
    'Competition',
    'Content',
    'Reputation',
    'Opportunities',
  ];

  late final AnimationController _progressCtrl;
  late final AnimationController _logoCtrl;
  late final AnimationController _fadeOutCtrl;
  late final Animation<double> _progressAnim;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  int _wordIndex = -1;
  bool _wordVisible = false;

  @override
  void initState() {
    super.initState();

    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    // Ease-out cubic matching original: 1 - (1 - t)^3
    _progressAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressCtrl, curve: Curves.easeOutCubic),
    );

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.02), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut));
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoCtrl, curve: const Interval(0, 0.7)),
    );

    _fadeOutCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _progressCtrl.addListener(_onProgress);
    _progressCtrl.forward();
    _logoCtrl.forward();

    Future.delayed(const Duration(milliseconds: 3600), () {
      if (mounted) _fadeOutCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 4200), () {
      if (mounted) widget.onDone();
    });
  }

  void _onProgress() {
    final progress = _progressAnim.value * 100;
    final idx = math.min(
      (progress / 100 * _words.length).floor(),
      _words.length - 1,
    );
    if (progress > 3 && idx != _wordIndex) {
      setState(() {
        _wordVisible = false;
      });
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() {
            _wordIndex = idx;
            _wordVisible = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _logoCtrl.dispose();
    _fadeOutCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_progressAnim, _logoCtrl, _fadeOutCtrl]),
      builder: (context, _) {
        final opacity = 1.0 - _fadeOutCtrl.value;
        final scale = 1.0 + (_fadeOutCtrl.value * 0.05);

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.2),
                  radius: 1.2,
                  colors: [
                    Color(0xFF0F1D3A),
                    Color(0xFF0A1628),
                    Color(0xFF030812),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  // Ambient orbs
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.12,
                    left: MediaQuery.of(context).size.width * 0.08,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.18,
                    right: MediaQuery.of(context).size.width * 0.05,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.accent.withValues(alpha: 0.07),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Content
                  SafeArea(
                    child: Column(
                      children: [
                        const Spacer(flex: 3),

                        // Logo
                        Opacity(
                          opacity: _logoOpacity.value,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: Column(
                              children: [
                                // Logo mark
                                Container(
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: AppColors.gradientGold,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.35),
                                        blurRadius: 32,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.sports_soccer_rounded,
                                    size: 44,
                                    color: AppColors.primaryForeground,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'SPORTSPHERE',
                                  style: GoogleFonts.outfit(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 3,
                                    color: AppColors.foreground,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Where Sport Meets Opportunity',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.mutedForeground,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(flex: 2),

                        // Rotating word
                        SizedBox(
                          height: 36,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: _wordVisible ? 1 : 0,
                            child: Text(
                              _wordIndex >= 0 ? _words[_wordIndex] : '',
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                                shadows: [
                                  Shadow(
                                    color: AppColors.primary.withValues(alpha: 0.4),
                                    blurRadius: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Progress bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 64),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: _progressAnim.value,
                                  minHeight: 4,
                                  backgroundColor: AppColors.surfaceBorder,
                                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${(_progressAnim.value * 100).round()}%',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
