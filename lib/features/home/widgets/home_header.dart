import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

/// Matches HomeHeader.tsx + sub-tabs from screenshots.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.activeSubTab,
    required this.onSubTabChanged,
    this.onSearch,
    this.onNotifications,
    this.onLeaderboard,
  });

  final String activeSubTab; // for-you | trending | predictions | polls
  final ValueChanged<String> onSubTabChanged;
  final VoidCallback? onSearch;
  final VoidCallback? onNotifications;
  final VoidCallback? onLeaderboard;

  static const subTabs = [
    ('for-you', 'Sportlights'),
    ('trending', 'Trending'),
    ('predictions', 'Predictions'),
    ('polls', 'Polls'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.92),
        border: Border(
          bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.6)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top row: logo + actions
            SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      height: 28,
                      fit: BoxFit.contain,
                      placeholderBuilder: (_) => Text(
                        'S',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _IconBtn(Icons.emoji_events_outlined, onLeaderboard),
                    const SizedBox(width: 4),
                    _IconBtn(Icons.search, onSearch),
                    const SizedBox(width: 4),
                    _IconBtn(Icons.notifications_none_rounded, onNotifications),
                  ],
                ),
              ),
            ),
            // Sub-tabs
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                itemCount: subTabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final (id, label) = subTabs[i];
                  final active = activeSubTab == id;
                  return GestureDetector(
                    onTap: () => onSubTabChanged(id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: active
                              ? AppColors.primaryForeground
                              : AppColors.mutedForeground,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn(this.icon, this.onTap);
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: AppColors.mutedForeground),
        ),
      ),
    );
  }
}
