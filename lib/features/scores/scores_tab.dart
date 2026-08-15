import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/providers/app_providers.dart';
import '../../shared/models/match.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';

/// Scores tab — live matches + standings from API
class ScoresTab extends ConsumerStatefulWidget {
  const ScoresTab({super.key});

  @override
  ConsumerState<ScoresTab> createState() => _ScoresTabState();
}

class _ScoresTabState extends ConsumerState<ScoresTab> {
  String _sub = 'live'; // live | today | upcoming | results | standings

  static const _subs = [
    ('live', 'Live'),
    ('today', 'Today'),
    ('upcoming', 'Upcoming'),
    ('results', 'Results'),
    ('standings', 'Standings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(sub: _sub, onChanged: (s) => setState(() => _sub = s)),
        Expanded(
          child: _sub == 'standings'
              ? const _StandingsView()
              : _MatchesView(status: _mapStatus(_sub)),
        ),
      ],
    );
  }

  String? _mapStatus(String sub) {
    switch (sub) {
      case 'live':
        return 'live';
      case 'today':
        return 'today';
      case 'upcoming':
        return 'upcoming';
      case 'results':
        return 'finished';
      default:
        return null;
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.sub, required this.onChanged});
  final String sub;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.92),
        border: Border(bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.6))),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: 52,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('Scores', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Icon(Icons.filter_list, color: AppColors.mutedForeground, size: 22),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                itemCount: _ScoresTabState._subs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final (id, label) = _ScoresTabState._subs[i];
                  final active = sub == id;
                  return GestureDetector(
                    onTap: () => onChanged(id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
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
          ],
        ),
      ),
    );
  }
}

class _MatchesView extends ConsumerWidget {
  const _MatchesView({this.status});
  final String? status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(matchesProvider(status));

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Could not load matches', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            TextButton(onPressed: () => ref.invalidate(matchesProvider(status)), child: const Text('Retry')),
          ],
        ),
      ),
      data: (matches) {
        if (matches.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sports_soccer, size: 48, color: AppColors.mutedForeground.withValues(alpha: 0.5)),
                  const SizedBox(height: 12),
                  Text(
                    status == 'live' ? 'No live matches right now' : 'No matches found',
                    style: GoogleFonts.inter(color: AppColors.mutedForeground),
                  ),
                ],
              ),
            ),
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.backgroundSecondary,
          onRefresh: () async => ref.invalidate(matchesProvider(status)),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: matches.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) => _MatchCard(m: matches[i]),
          ),
        );
      },
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({required this.m});
  final MatchItem m;

  @override
  Widget build(BuildContext context) {
    final score = m.isFinished || m.isLive
        ? '${m.homeScore ?? 0}  -  ${m.awayScore ?? 0}'
        : 'vs';
    final statusLabel = m.isLive
        ? (m.minute != null ? "${m.minute}'" : 'LIVE')
        : m.isFinished
            ? 'FT'
            : (m.kickoff ?? m.status).toUpperCase();

    return GlassCard(
      borderRadius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              if (m.league != null)
                Text(m.league!, style: GoogleFonts.inter(fontSize: 10, color: AppColors.mutedForeground, fontWeight: FontWeight.w600)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: m.isLive
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: m.isLive ? AppColors.primary : AppColors.mutedForeground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(m.homeTeam, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
              ),
              Text(
                score,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: m.isLive ? AppColors.primary : AppColors.foreground,
                ),
              ),
              Expanded(
                child: Text(m.awayTeam, textAlign: TextAlign.right, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StandingsView extends ConsumerWidget {
  const _StandingsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(standingsProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
      error: (e, _) => Center(child: TextButton(onPressed: () => ref.invalidate(standingsProvider), child: const Text('Retry'))),
      data: (data) {
        final rows = data.rows;
        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.backgroundSecondary,
          onRefresh: () async => ref.invalidate(standingsProvider),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              Text(data.league, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              GlassCard(
                borderRadius: 14,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  children: [
                    _StandingsHeader(),
                    const Divider(height: 16, color: AppColors.border),
                    ...rows.map((r) => _StandingRowWidget(r: r)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StandingsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.mutedForeground);
    return Row(
      children: [
        SizedBox(width: 28, child: Text('#', style: style)),
        const Expanded(child: Text('Team', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.mutedForeground))),
        SizedBox(width: 28, child: Text('P', textAlign: TextAlign.center, style: style)),
        SizedBox(width: 28, child: Text('W', textAlign: TextAlign.center, style: style)),
        SizedBox(width: 28, child: Text('D', textAlign: TextAlign.center, style: style)),
        SizedBox(width: 28, child: Text('L', textAlign: TextAlign.center, style: style)),
        SizedBox(width: 36, child: Text('Pts', textAlign: TextAlign.center, style: style)),
      ],
    );
  }
}

class _StandingRowWidget extends StatelessWidget {
  const _StandingRowWidget({required this.r});
  final StandingRow r;

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${r.pos}',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                color: r.pos <= 3 ? AppColors.primary : AppColors.mutedForeground,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                if (r.badge != null && r.badge!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.network(r.badge!, width: 20, height: 20, errorBuilder: (_, __, ___) => const SizedBox(width: 20)),
                  ),
                Flexible(child: Text(r.team, overflow: TextOverflow.ellipsis, style: style)),
              ],
            ),
          ),
          SizedBox(width: 28, child: Text('${r.played}', textAlign: TextAlign.center, style: style)),
          SizedBox(width: 28, child: Text('${r.won}', textAlign: TextAlign.center, style: style)),
          SizedBox(width: 28, child: Text('${r.drawn}', textAlign: TextAlign.center, style: style)),
          SizedBox(width: 28, child: Text('${r.lost}', textAlign: TextAlign.center, style: style)),
          SizedBox(
            width: 36,
            child: Text('${r.pts}', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
