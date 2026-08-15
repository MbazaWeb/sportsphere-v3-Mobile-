import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';

class ActivityTab extends StatefulWidget {
  const ActivityTab({super.key, this.onSignIn});
  final VoidCallback? onSignIn;

  @override
  State<ActivityTab> createState() => _ActivityTabState();
}

class _ActivityTabState extends State<ActivityTab> {
  String _sub = 'all';

  static const _subs = [
    ('all', 'All'),
    ('social', 'Social'),
    ('sports', 'Sports'),
    ('messages', 'Messages'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Activity', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
          ),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _subs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                final (id, label) = _subs[i];
                final active = _sub == id;
                return GestureDetector(
                  onTap: () => setState(() => _sub = id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.15,
                        color: active ? AppColors.primaryForeground : AppColors.mutedForeground,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                        ),
                        child: const Icon(Icons.notifications_none_rounded, size: 32, color: AppColors.primary),
                      ),
                      const SizedBox(height: 18),
                      Text('Activity Feed', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to see likes, follows, match alerts and messages.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(fontSize: 14, height: 1.45, color: AppColors.mutedForeground, letterSpacing: -0.1),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.onSignIn,
                          child: const Text('Sign In'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
