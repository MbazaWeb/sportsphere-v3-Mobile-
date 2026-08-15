import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/models/post.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/glass_card.dart';
import '../../../shared/widgets/ss_refresh.dart';

/// Live Sportlights feed from GET /api/feed
class SportlightsTab extends ConsumerWidget {
  const SportlightsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider(null));

    return feedAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
        ),
      ),
      error: (e, _) => _ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(feedProvider(null)),
      ),
      data: (posts) {
        if (posts.isEmpty) {
          return SsRefreshScroll(
            onRefresh: () async {
              ref.invalidate(feedProvider(null));
              await ref.read(feedProvider(null).future);
            },
            child: Center(
              child: Text(
                'No posts yet — pull to refresh',
                style: GoogleFonts.inter(color: AppColors.mutedForeground),
              ),
            ),
          );
        }
        return SsRefresh(
          onRefresh: () async {
            ref.invalidate(feedProvider(null));
            await ref.read(feedProvider(null).future);
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => LiveFeedCard(post: posts[i]),
          ),
        );
      },
    );
  }
}

class LiveFeedCard extends StatelessWidget {
  const LiveFeedCard({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    final u = post.user;
    final time = _relTime(post.createdAt);

    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(url: u.avatarUrl, name: u.name),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            u.name,
                            style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (u.isVerified) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'VERIFIED',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF22C55E),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${u.handle.startsWith('@') ? u.handle : '@${u.handle}'} · $time',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (post.content.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(post.content, style: GoogleFonts.inter(fontSize: 14, height: 1.4)),
          ],
          if (post.mediaUrls.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(
                  post.mediaUrls.first,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.surface,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported, color: AppColors.mutedForeground),
                  ),
                ),
              ),
            ),
          ],
          if (post.poll != null) ...[
            const SizedBox(height: 12),
            _PollBlock(poll: post.poll!),
          ],
          if (post.prediction != null) ...[
            const SizedBox(height: 12),
            _PredictionBlock(pred: post.prediction!),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              _Act(Icons.favorite_border, '${post.likeCount}'),
              const SizedBox(width: 16),
              _Act(Icons.chat_bubble_outline, '${post.commentCount}'),
              const SizedBox(width: 16),
              _Act(Icons.ios_share_outlined, '${post.shareCount}'),
              const Spacer(),
              const Icon(Icons.bookmark_border, size: 18, color: AppColors.mutedForeground),
            ],
          ),
        ],
      ),
    );
  }

  String _relTime(String iso) {
    try {
      final d = DateTime.parse(iso).toLocal();
      final diff = DateTime.now().difference(d);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return '';
    }
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.url, required this.name});
  final String? url;
  final String name;

  @override
  Widget build(BuildContext context) {
    if (url != null && url!.isNotEmpty) {
      return CircleAvatar(radius: 20, backgroundImage: NetworkImage(url!));
    }
    final initials = name.isNotEmpty
        ? name.trim().split(RegExp(r'\s+')).take(2).map((e) => e[0]).join().toUpperCase()
        : '?';
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.surfaceElevated,
      child: Text(initials, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primary)),
    );
  }
}

class _PollBlock extends StatelessWidget {
  const _PollBlock({required this.poll});
  final PollData poll;

  @override
  Widget build(BuildContext context) {
    final total = poll.totalVotes == 0 ? 1 : poll.totalVotes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(poll.question, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        ...List.generate(poll.options.length, (i) {
          final count = (poll.optionCounts != null && i < poll.optionCounts!.length)
              ? poll.optionCounts![i]
              : 0;
          final pct = ((count / total) * 100).round();
          final selected = poll.userVotedOption == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF8B7355).withValues(alpha: 0.45) : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppColors.primary.withValues(alpha: 0.35) : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(poll.options[i], style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
                  Text('$pct%', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: selected ? AppColors.primary : AppColors.mutedForeground)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _PredictionBlock extends StatelessWidget {
  const _PredictionBlock({required this.pred});
  final PredictionData pred;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text('PREDICTION', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.mutedForeground)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Text(pred.homeTeam, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600))),
              Text('${pred.predictedHome ?? '-'}', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.primary)),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('-', style: GoogleFonts.inter(color: AppColors.mutedForeground))),
              Text('${pred.predictedAway ?? '-'}', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.primary)),
              Expanded(child: Text(pred.awayTeam, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600))),
            ],
          ),
          if (pred.confidence != null) ...[
            const SizedBox(height: 8),
            Text(pred.confidence!, style: GoogleFonts.inter(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
          ],
        ],
      ),
    );
  }
}

class _Act extends StatelessWidget {
  const _Act(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.mutedForeground),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground)),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Could not load feed', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
