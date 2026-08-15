import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// 1:1 port of `src/components/SplashScreen.tsx`
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
  late final AnimationController _fadeOutCtrl;
  late final AnimationController _spinCtrl;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _wordGlowCtrl;
  late final AnimationController _taglineCtrl;
  late final AnimationController _logoEnterCtrl;

  late final Animation<double> _progressAnim;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoDy;

  int _wordIndex = -1;
  bool _wordVisible = false;
  double _progressPct = 0;

  @override
  void initState() {
    super.initState();

    // Source: duration 3200, interval 30, ease 1-(1-t)^3
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _progressAnim = CurvedAnimation(
      parent: _progressCtrl,
      curve: Curves.easeOutCubic,
    )..addListener(() {
        final p = _progressAnim.value * 100;
        final idx = math.min(
          (p / 100 * _words.length).floor(),
          _words.length - 1,
        );
        setState(() => _progressPct = p);
        if (p > 3 && idx != _wordIndex) {
          setState(() => _wordVisible = false);
          Future.delayed(const Duration(milliseconds: 150), () {
            if (!mounted) return;
            setState(() {
              _wordIndex = idx;
              _wordVisible = true;
            });
          });
        }
      });

    // logoEnter 0.8s
    _logoEnterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoEnterCtrl, curve: const Interval(0, 0.75)),
    );
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.02), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _logoEnterCtrl, curve: Curves.easeOut));
    _logoDy = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 20.0, end: -2.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: -2.0, end: 0.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _logoEnterCtrl, curve: Curves.easeOut));

    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _wordGlowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _taglineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

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
    final pct = _progressPct.round().clamp(0, 100);

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
        return Opacity(
          opacity: 1.0 - exitT,
          child: Transform.scale(
            scale: 1.0 + exitT * 0.05,
            child: Container(
              width: double.infinity,
              height: double.infinity,
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
                  // Ambient gold orb
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
                  // Ambient sky orb
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

                  // Watermark S
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

                  // Content column — matches web flex center layout
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Opacity(
                          opacity: _logoOpacity.value,
                          child: Transform.translate(
                            offset: Offset(0, _logoDy.value),
                            child: Transform.scale(
                              scale: _logoScale.value,
                              child: SizedBox(
                                width: math.min(240.0, size.width * 0.55),
                                child: SvgPicture.asset(
                                  'assets/images/logo.svg',
                                  fit: BoxFit.contain,
                                  placeholderBuilder: (_) => const _FallbackS(),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Word area — source: height 10vh, marginBottom 3vh
                        // CRITICAL: text is WHITE, no background, no solid bar
                        SizedBox(height: size.height * 0.025),
                        SizedBox(
                          height: size.height * 0.08,
                          child: Center(
                            child: _wordIndex < 0
                                ? const SizedBox.shrink()
                                : AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                    opacity: _wordVisible ? 1.0 : 0.0,
                                    child: AnimatedSlide(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                      offset: _wordVisible
                                          ? Offset.zero
                                          : const Offset(0, 0.2),
                                      child: Text(
                                        _words[_wordIndex].toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.outfit(
                                          fontSize: (size.width * 0.055)
                                              .clamp(22.0, 40.0),
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 4,
                                          color: Colors.white,
                                          decoration: TextDecoration.none,
                                          shadows: [
                                            Shadow(
                                              color: Color.fromRGBO(
                                                245,
                                                197,
                                                24,
                                                0.2 +
                                                    0.3 * _wordGlowCtrl.value,
                                              ),
                                              blurRadius:
                                                  20 + 20 * _wordGlowCtrl.value,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),

                        // Progress block — width 75% max 280
                        SizedBox(
                          width: math.min(size.width * 0.75, 280),
                          child: Column(
                            children: [
                              // Spinner 28×28
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: RotationTransition(
                                  turns: _spinCtrl,
                                  child: CustomPaint(
                                    painter: _SpinnerPainter(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Thin progress track (height 4) — match web
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: SizedBox(
                                  height: 4,
                                  width: double.infinity,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      // Track
                                      ColoredBox(
                                        color: Colors.white.withValues(alpha: 0.06),
                                      ),
                                      // Fill with shimmer gradient
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: FractionallySizedBox(
                                          widthFactor:
                                              _progressAnim.value.clamp(0.0, 1.0),
                                          heightFactor: 1,
                                          child: AnimatedBuilder(
                                            animation: _shimmerCtrl,
                                            builder: (_, __) {
                                              // shimmer shifts background-position
                                              final t = _shimmerCtrl.value;
                                              return DecoratedBox(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  gradient: LinearGradient(
                                                    begin: Alignment(-1 + 2 * t, 0),
                                                    end: Alignment(1 + 2 * t, 0),
                                                    colors: const [
                                                      Color(0xFFF5C518),
                                                      Color(0xFFFFD700),
                                                      Color(0xFFFFFFFF),
                                                      Color(0xFFFFD700),
                                                      Color(0xFFF5C518),
                                                    ],
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromRGBO(
                                                        245,
                                                        197,
                                                        24,
                                                        0.35 +
                                                            0.25 *
                                                                math.sin(t *
                                                                    math.pi *
                                                                    2)
                                                                    .abs(),
                                                      ),
                                                      blurRadius: 8,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // LOADING ........ %
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'LOADING',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.2,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 2,
                                      color:
                                          Colors.white.withValues(alpha: 0.4),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    '$pct%',
                                    style: GoogleFonts.inter(
                                      fontSize: 15.2,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                      color: const Color(0xFFF5C518),
                                      decoration: TextDecoration.none,
                                      shadows: const [
                                        Shadow(
                                          color: Color(0x66F5C518),
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

                        // Push footer space — web uses absolute footer
                        SizedBox(height: size.height * 0.12),
                      ],
                    ),
                  ),

                  // Footer absolute
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: MediaQuery.paddingOf(context).bottom +
                        size.height * 0.03,
                    child: FadeTransition(
                      opacity: _taglineCtrl,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
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
                                  fontSize: 17.6,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 5,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  decoration: TextDecoration.none,
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
                                fontSize: 10.4,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                                color: Colors.white.withValues(alpha: 0.35),
                                decoration: TextDecoration.none,
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
  const _FallbackS();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
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
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 2.5;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - stroke) / 2;

    // Track ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    // Gold arc (top portion)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2 - 0.2,
      math.pi * 0.55,
      false,
      Paint()
        ..color = const Color(0xFFF5C518)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
