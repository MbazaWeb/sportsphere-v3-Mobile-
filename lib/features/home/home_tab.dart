import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';

/// Home feed skeleton matching web HomeTab (For You / Trending / Predictions / Polls).
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _subTab = 'for-you';

  // Exact labels from HomeHeader.tsx SUBTABS
  static const _tabs = [
    ('for-you', 'Sportlights'),
    ('trending', 'Trending'),
    ('predictions', 'Predictions'),
    ('polls', 'Polls'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Text(
                'SportSphere',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.foreground,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: AppColors.mutedForeground),
              ),
            ],
          ),
        ),

        // Sub-tabs
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _tabs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final (id, label) = _tabs[i];
              final active = _subTab == id;
              return GestureDetector(
                onTap: () => setState(() => _subTab = id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active
                          ? AppColors.primary.withValues(alpha: 0.4)
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: active ? AppColors.primary : AppColors.mutedForeground,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Feed skeleton
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            itemCount: 6,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                            child: Text(
                              String.fromCharCode(65 + (i % 26)),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Athlete ${i + 1}',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '@handle · 2h',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.more_horiz, color: AppColors.mutedForeground, size: 20),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _subTab == 'predictions'
                            ? 'Prediction: Home win vs Away · Confidence 78%'
                            : _subTab == 'polls'
                                ? 'Who wins the derby this weekend?'
                                : 'Matchday vibes. Who else is watching tonight?',
                        style: GoogleFonts.inter(fontSize: 14, height: 1.4),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.backgroundSecondary,
                              AppColors.primary.withValues(alpha: 0.08),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.image_outlined, color: AppColors.mutedForeground, size: 32),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _Action(Icons.favorite_border, '${12 + i * 3}'),
                          const SizedBox(width: 16),
                          _Action(Icons.chat_bubble_outline, '${2 + i}'),
                          const SizedBox(width: 16),
                          _Action(Icons.share_outlined, 'Share'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.mutedForeground),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground),
        ),
      ],
    );
  }
}
