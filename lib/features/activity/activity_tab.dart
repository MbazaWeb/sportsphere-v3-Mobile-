import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';

/// Activity tab structure (API requires auth — UI ready)
class ActivityTab extends StatefulWidget {
  const ActivityTab({super.key});

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
            child: Text('Activity', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800)),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _subs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final (id, label) = _subs[i];
                final active = _sub == id;
                return GestureDetector(
                  onTap: () => setState(() => _sub = id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: active ? AppColors.primaryForeground : AppColors.mutedForeground,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: [
                GlassCard(
                  borderRadius: 14,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(Icons.notifications_none, size: 40, color: AppColors.mutedForeground.withValues(alpha: 0.6)),
                      const SizedBox(height: 12),
                      Text('Your activity feed', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(
                        'Likes, comments, follows and sports alerts will appear here once you sign in.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.mutedForeground, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
