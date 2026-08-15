import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/providers/app_providers.dart';
import '../../../theme/app_colors.dart';
import 'sportlights_tab.dart';

class TrendingTab extends ConsumerWidget {
  const TrendingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider('trending'));

    return feedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
      error: (e, _) => Center(
        child: TextButton(
          onPressed: () => ref.invalidate(feedProvider('trending')),
          child: const Text('Retry'),
        ),
      ),
      data: (posts) {
        if (posts.isEmpty) {
          return Center(
            child: Text('No trending posts', style: GoogleFonts.inter(color: AppColors.mutedForeground)),
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.backgroundSecondary,
          onRefresh: () async => ref.invalidate(feedProvider('trending')),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: posts.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              if (i == 0) {
                return Row(
                  children: [
                    const Icon(Icons.trending_up, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text('TRENDING', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.mutedForeground)),
                  ],
                );
              }
              return LiveFeedCard(post: posts[i - 1]);
            },
          ),
        );
      },
    );
  }
}
