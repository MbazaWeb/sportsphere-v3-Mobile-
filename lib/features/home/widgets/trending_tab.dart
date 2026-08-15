import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/glass_card.dart';

class TrendingTab extends StatelessWidget {
  const TrendingTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = [
      ('#Trending', '1 likes', '0 comments'),
      ('#Trending', '1 likes', '0 comments'),
      ('#Trending', '1 likes', '0 comments'),
      ('##NBCPremierLeague', '1 likes', '0 comments'),
      ('#Trending', '1 likes', '0 comments'),
      ('#Trending', '1 likes', '0 comments'),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              'LIVE NOW',
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.mutedForeground, letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.trending_up, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text('TRENDING', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.mutedForeground, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 12),
        ...tags.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GlassCard(
                borderRadius: 14,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.local_fire_department, color: AppColors.primary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.$1, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
                          Text(t.$2, style: GoogleFonts.inter(fontSize: 11, color: AppColors.mutedForeground)),
                        ],
                      ),
                    ),
                    Text(t.$3, style: GoogleFonts.inter(fontSize: 11, color: AppColors.mutedForeground)),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 8),
        GlassCard(
          borderRadius: 14,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const CircleAvatar(radius: 18, backgroundColor: Color(0xFF3B82F6), child: Icon(Icons.person, size: 18, color: Colors.white)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('David Martin', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, size: 14, color: AppColors.primary),
                      ],
                    ),
                    Text('@davidmbazza', style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground)),
                  ],
                ),
              ),
              const Icon(Icons.favorite_border, size: 16, color: AppColors.mutedForeground),
              const SizedBox(width: 4),
              Text('1', style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground)),
            ],
          ),
        ),
      ],
    );
  }
}
