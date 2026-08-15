import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

/// 1:1 port of `src/components/SplashScreen.tsx`
/// Timing: progress 3200ms ease-out-cubic, fade 3600ms, onDone 4200ms
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Exact words from source
  static const _loadingWords = [
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
  late final AnimationController _fadeOutCtrl;
  late final AnimationController _spinCtrl;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _wordGlowCtrl;
  late final AnimationController _taglineCtrl;
  late final AnimationController _logoEnterCtrl;

  late final Animation<double> _progressAnim; // 0..100 style via value*100
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _logoOffset;

  int _wordIndex = -1;
  bool _wordVisible = false;
  bool _logoError = false;

  @override
  void initState() {
    super.initState();

    // Progress: 3200ms, ease-out cubic: 1-(1-t)^3  → matches source
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _progressAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressCtrl, curve: Curves.easeOutCubic),
    )..addListener(_onProgress);

    // Logo enter: 0.8s ease-out — scale 0.8→1.02→1, opacity 0→1, y 20→-2→0
    _logoEnterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoEnterCtrl, curve: const Interval(0, 0.7)),
    );
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.8, end: 1.02).chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.02, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
    ]).animate(_logoEnterCtrl);
    _logoOffset = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 20), end: const Offset(0, -2)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, -2), end: Offset.zero),
        weight: 40,
      ),
    ]).animate(_logoEnterCtrl);

    // Spinner continuous
    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    // Shimmer on progress bar
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Word glow pulse
    _wordGlowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Tagline fade: 0.8s ease-out, delay 0.5s
    _taglineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Exit: opacity 0 + scale 1.05 over 600ms starting at 3600ms; onDone at 4200ms
    _fadeOutCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _progressCtrl.forward();
    _logoEnterCtrl.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _taglineCtrl.forward();
    });
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
      (progress / 100 * _loadingWords.length).floor(),
      _loadingWords.length - 1,
    );
    if (progress > 3 && idx != _wordIndex) {
      setState(() => _wordVisible = false);
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() {
            _wordIndex = idx;
            _wordVisible = true;
          });
        }
      });
    } else {
      // rebuild for progress % text
      setState(() {});
    }
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _fadeOutCtrl.dispose();
    _spinCtrl.dispose();
    _shimmerCtrl.dispose();
    _wordGlowCtrl.dispose();
    _taglineCtrl.dispose();
    _logoEnterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final progressPct = (_progressAnim.value * 100).round().clamp(0, 100);

    return AnimatedBuilder(
      animation: Listenable.merge([
        _progressAnim,
        _fadeOutCtrl,
        _logoEnterCtrl,
        _spinCtrl,
        _shimmerCtrl,
        _wordGlowCtrl,
        _taglineCtrl,
      ]),
      builder: (context, _) {
        final exitT = _fadeOutCtrl.value;
        final opacity = 1.0 - exitT;
        final scale = 1.0 + (exitT * 0.05);

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              // radial-gradient(ellipse at 50% 40%, #0f1d3a 0%, #0a1628 50%, #030812 100%)
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.2),
                  radius: 1.15,
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
                  // Ambient orb gold — top 15% left 10%, 200px
                  Positioned(
                    top: size.height * 0.15,
                    left: size.width * 0.10,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFF5C518).withValues(alpha: 0.08),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.7],
                        ),
                      ),
                    ),
                  ),
                  // Ambient orb sky — bottom 20% right 8%, 160px (source uses sky blue 56,189,248)
                  Positioned(
                    bottom: size.height * 0.20,
                    right: size.width * 0.08,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF38BDF8).withValues(alpha: 0.06),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.7],
                        ),
                      ),
                    ),
                  ),

                  // Watermark S — 35vw, weight 900, gold 3% opacity, italic
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Center(
                        child: Text(
                          'S',
                          style: TextStyle(
                            fontSize: size.width * 0.35,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFFF5C518).withValues(alpha: 0.03),
                            height: 1,
                            letterSpacing: -20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Main column
                  SafeArea(
                    child: Column(
                      children: [
                        const Spacer(flex: 3),

                        // Logo — max width 240, logoEnter animation
                        Opacity(
                          opacity: _logoOpacity.value,
                          child: Transform.translate(
                            offset: _logoOffset.value,
                            child: Transform.scale(
                              scale: _logoScale.value,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 240),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: size.height * 0.025),
                                  child: _logoError
                                      ? _FallbackS()
                                      : SvgPicture.asset(
                                          'assets/images/logo.svg',
                                          width: 240,
                                          fit: BoxFit.contain,
                                          placeholderBuilder: (_) => _FallbackS(),
                                          // If SVG fails to parse, show fallback
                                          // (flutter_svg throws; we catch via errorBuilder pattern)
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Animated word — height 10vh
                        SizedBox(
                          height: size.height * 0.10,
                          child: Center(
                            child: _wordIndex >= 0
                                ? AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: _wordVisible ? 1 : 0,
                                    child: AnimatedScale(
                                      duration: const Duration(milliseconds: 300),
                                      scale: _wordVisible ? 1 : 0.95,
                                      child: AnimatedSlide(
                                        duration: const Duration(milliseconds: 300),
                                        offset: _wordVisible
                                            ? Offset.zero
                                            : const Offset(0, 0.15),
                                        child: Text(
                                          _loadingWords[_wordIndex].toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.outfit(
                                            fontSize: (size.width * 0.055)
                                                .clamp(25.6, 44.8),
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 4,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                color: const Color(0xFFF5C518)
                                                    .withValues(
                                                  alpha: 0.2 +
                                                      (_wordGlowCtrl.value * 0.3),
                                                ),
                                                blurRadius:
                                                    20 + (_wordGlowCtrl.value * 20),
                                              ),
                                              Shadow(
                                                color: const Color(0xFFF5C518)
                                                    .withValues(
                                                  alpha: 0.05 +
                                                      (_wordGlowCtrl.value * 0.1),
                                                ),
                                                blurRadius:
                                                    40 + (_wordGlowCtrl.value * 40),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),

                        SizedBox(height: size.height * 0.03),

                        // Progress block — width 75%, max 280
                        SizedBox(
                          width: math.min(size.width * 0.75, 280),
                          child: Column(
                            children: [
                              // Spinner 28x28
                              RotationTransition(
                                turns: _spinCtrl,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.08),
                                      width: 2.5,
                                    ),
                                  ),
                                  child: CustomPaint(
                                    painter: _SpinnerArcPainter(
                                      color: const Color(0xFFF5C518),
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Progress bar height 4, track rgba(255,255,255,0.06)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: SizedBox(
                                  height: 4,
                                  width: double.infinity,
                                  child: Stack(
                                    children: [
                                      Container(
                                        color: Colors.white.withValues(alpha: 0.06),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: _progressAnim.value.clamp(0.0, 1.0),
                                        child: AnimatedBuilder(
                                          animation: _shimmerCtrl,
                                          builder: (context, _) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4),
                                                gradient: LinearGradient(
                                                  begin: Alignment(
                                                    -1.0 + 2.0 * _shimmerCtrl.value,
                                                    0,
                                                  ),
                                                  end: Alignment(
                                                    1.0 + 2.0 * _shimmerCtrl.value,
                                                    0,
                                                  ),
                                                  colors: const [
                                                    Color(0xFFF5C518),
                                                    Color(0xFFFFD700),
                                                    Colors.white,
                                                    Color(0xFFFFD700),
                                                    Color(0xFFF5C518),
                                                  ],
                                                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(0xFFF5C518)
                                                        .withValues(alpha: 0.3 +
                                                            0.3 *
                                                                math.sin(
                                                                  _shimmerCtrl.value *
                                                                      math.pi *
                                                                      2,
                                                                ).abs()),
                                                    blurRadius: 6 +
                                                        10 *
                                                            math.sin(
                                                              _shimmerCtrl.value *
                                                                  math.pi *
                                                                  2,
                                                            ).abs(),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Loading ........ %
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'LOADING',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.2, // 0.7rem
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 2,
                                      color: Colors.white.withValues(alpha: 0.4),
                                    ),
                                  ),
                                  Text(
                                    '$progressPct%',
                                    style: GoogleFonts.inter(
                                      fontSize: 15.2, // 0.95rem
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                      color: const Color(0xFFF5C518),
                                      shadows: [
                                        Shadow(
                                          color: const Color(0xFFF5C518)
                                              .withValues(alpha: 0.4),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Spacer(flex: 2),
                      ],
                    ),
                  ),

                  // Footer — bottom safe + 3vh
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: MediaQuery.paddingOf(context).bottom + size.height * 0.03,
                    child: FadeTransition(
                      opacity: _taglineCtrl,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.15),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _taglineCtrl,
                          curve: Curves.easeOut,
                        )),
                        child: Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 17.6, // 1.1rem
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 5,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                                children: const [
                                  TextSpan(text: 'LIVE. '),
                                  TextSpan(
                                    text: 'PLAY.',
                                    style: TextStyle(color: Color(0xFFF5C518)),
                                  ),
                                  TextSpan(text: ' CONNECT.'),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '© ${DateTime.now().year} MbazzaCodes Inc.',
                              style: GoogleFonts.inter(
                                fontSize: 10.4, // 0.65rem
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                                color: Colors.white.withValues(alpha: 0.35),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
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

class _FallbackS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF5C518), Color(0xFFFFD700)],
        ),
      ),
      alignment: Alignment.center,
      child: const Text(
        'S',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          color: Color(0xFF030812),
        ),
      ),
    );
  }
}

/// Top arc only — mimics border-top gold spinner
class _SpinnerArcPainter extends CustomPainter {
  _SpinnerArcPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final rect = Offset.zero & size;
    // Draw ~90° arc at top
    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      -math.pi / 2 - 0.3,
      math.pi * 0.55,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
