import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/glass_card.dart';

/// Sportlights feed matching screenshots: match results, recent, top accounts, posts.
class SportlightsTab extends StatelessWidget {
  const SportlightsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: const [
        _FullTimeResultCard(),
        SizedBox(height: 12),
        _RecentResultsSection(),
        SizedBox(height: 12),
        _TopAccountsSection(),
        SizedBox(height: 12),
        _PostCard(
          name: 'David Martin',
          handle: '@davidmbazza',
          time: '1d ago',
          verified: true,
          role: 'FAN',
          body: 'SportSphere',
          hasImage: true,
          likes: 1,
          comments: 1,
          shares: 0,
        ),
        SizedBox(height: 12),
        _PostCard(
          name: 'David Martin',
          handle: '@davidmbazza',
          time: '1d ago',
          verified: true,
          role: 'FAN',
          body: 'New Here',
          likes: 1,
          comments: 0,
          shares: 0,
        ),
        SizedBox(height: 12),
        _VideoPostCard(),
        SizedBox(height: 12),
        _PollInFeedCard(),
        SizedBox(height: 12),
        _PredictionInFeedCard(),
      ],
    );
  }
}

class _FullTimeResultCard extends StatelessWidget {
  const _FullTimeResultCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'FULL TIME RESULT',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Text(
                'NBC PREMIER LEAGUE',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _TeamBadge(initials: 'PA', name: 'Pamba Jiji')),
              Column(
                children: [
                  Text(
                    '1  -  1',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.foreground,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'FT',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF22C55E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(child: _TeamBadge(initials: 'DO', name: 'Dodoma FC', alignEnd: true)),
            ],
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground),
              children: const [
                TextSpan(text: "17' ", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                TextSpan(text: 'Ngassa B   '),
                TextSpan(text: "24' ", style: TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.w700)),
                TextSpan(text: 'Mafie D.'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 10),
          Row(
            children: [
              _Action(Icons.favorite_border, 'Like'),
              const SizedBox(width: 20),
              _Action(Icons.chat_bubble_outline, 'Comment'),
              const SizedBox(width: 20),
              _Action(Icons.ios_share_outlined, 'Share'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TeamBadge extends StatelessWidget {
  const _TeamBadge({required this.initials, required this.name, this.alignEnd = false});
  final String initials;
  final String name;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.5),
            color: AppColors.surface,
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _RecentResultsSection extends StatelessWidget {
  const _RecentResultsSection();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'RECENT RESULTS',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Text(
                '1 matches',
                style: GoogleFonts.inter(fontSize: 11, color: AppColors.mutedForeground),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.foreground),
                      children: const [
                        TextSpan(text: 'Simba SC  '),
                        TextSpan(
                          text: '0 - 1',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(text: '  Young African...'),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'FT',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF22C55E),
                    ),
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

class _TopAccountsSection extends StatelessWidget {
  const _TopAccountsSection();

  static const _rows = [
    (1, 'Simba SC', 'Team', '2', true),
    (2, 'Zuberi Mkombozi', 'Player', '1', false),
    (3, 'Feisal Salum', 'Player', '1', false),
    (4, 'Ali Simba', 'Fan', '1', false),
    (5, 'Azam FC', 'Team', '1', true),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'TOP ACCOUNTS',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._rows.map((r) {
            final (rank, name, type, fans, isTeam) = r;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 22,
                    child: Text(
                      '$rank',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        color: rank <= 3 ? AppColors.primary : AppColors.mutedForeground,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.surfaceElevated,
                    child: Text(
                      name.substring(0, 2).toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
                        Text(type, style: GoogleFonts.inter(fontSize: 11, color: AppColors.mutedForeground)),
                      ],
                    ),
                  ),
                  Text(
                    '$fans fans',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.name,
    required this.handle,
    required this.time,
    required this.body,
    this.verified = false,
    this.role,
    this.hasImage = false,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
  });

  final String name, handle, time, body;
  final bool verified, hasImage;
  final String? role;
  final int likes, comments, shares;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF3B82F6),
                child: Icon(Icons.person, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
                        if (verified) ...[
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
                        if (role != null) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.favorite, size: 10, color: AppColors.mutedForeground),
                                const SizedBox(width: 3),
                                Text(role!, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.mutedForeground)),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '$handle · $time',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(body, style: GoogleFonts.inter(fontSize: 14, height: 1.4)),
          if (hasImage) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 180,
                width: double.infinity,
                color: const Color(0xFF030812),
                alignment: Alignment.center,
                child: const Icon(Icons.sports_soccer, size: 64, color: AppColors.primary),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              _Action(Icons.favorite_border, '$likes'),
              const SizedBox(width: 16),
              _Action(Icons.chat_bubble_outline, '$comments'),
              const SizedBox(width: 16),
              _Action(Icons.ios_share_outlined, '$shares'),
              const Spacer(),
              const Icon(Icons.bookmark_border, size: 18, color: AppColors.mutedForeground),
            ],
          ),
        ],
      ),
    );
  }
}

class _VideoPostCard extends StatelessWidget {
  const _VideoPostCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF3B82F6),
                child: Icon(Icons.person, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('David Martin', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('VERIFIED', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: const Color(0xFF22C55E))),
                        ),
                      ],
                    ),
                    Text('@davidmbazza · 1d ago', style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black87,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.play_circle_fill, size: 56, color: Colors.white70),
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Text('0:00 / 0:25', style: GoogleFonts.inter(fontSize: 11, color: Colors.white70)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Action(Icons.favorite_border, '1'),
              const SizedBox(width: 16),
              _Action(Icons.chat_bubble_outline, '0'),
              const SizedBox(width: 16),
              _Action(Icons.ios_share_outlined, '0'),
              const Spacer(),
              const Icon(Icons.bookmark_border, size: 18, color: AppColors.mutedForeground),
            ],
          ),
        ],
      ),
    );
  }
}

class _PollInFeedCard extends StatelessWidget {
  const _PollInFeedCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 20, backgroundColor: Color(0xFF3B82F6), child: Icon(Icons.person, color: Colors.white, size: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('David Martin', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
                    Text('@davidmbazza · 1d ago', style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('nani mshindi ?', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          _PollOption(label: 'Singida Black Stars SC', pct: 100, selected: true),
          const SizedBox(height: 8),
          _PollOption(label: 'Fountain', pct: 0),
          const SizedBox(height: 8),
          _PollOption(label: 'Draw', pct: 0),
          const SizedBox(height: 8),
          Text('1 vote · You voted', style: GoogleFonts.inter(fontSize: 11, color: AppColors.mutedForeground)),
          const SizedBox(height: 10),
          Row(
            children: [
              _Action(Icons.favorite_border, '1'),
              const SizedBox(width: 16),
              _Action(Icons.chat_bubble_outline, '0'),
              const SizedBox(width: 16),
              _Action(Icons.ios_share_outlined, '0'),
              const Spacer(),
              const Icon(Icons.bookmark_border, size: 18, color: AppColors.mutedForeground),
            ],
          ),
        ],
      ),
    );
  }
}

class _PollOption extends StatelessWidget {
  const _PollOption({required this.label, required this.pct, this.selected = false});
  final String label;
  final int pct;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF8B7355).withValues(alpha: 0.5) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: selected ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
          if (selected) const Icon(Icons.check, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text('$pct%', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: selected ? AppColors.primary : AppColors.mutedForeground)),
        ],
      ),
    );
  }
}

class _PredictionInFeedCard extends StatelessWidget {
  const _PredictionInFeedCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 20, backgroundColor: Color(0xFF3B82F6), child: Icon(Icons.person, color: Colors.white, size: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('David Martin', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
                    Text('@davidmbazza · 1d ago', style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '🎯 My prediction: Singida Black Stars SC 3 - 1 Fountain (medium confidence) #NBCPremierLeague',
            style: GoogleFonts.inter(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('PREDICTION', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.mutedForeground)),
                    const Spacer(),
                    Icon(Icons.edit_outlined, size: 14, color: AppColors.mutedForeground),
                    Text(' EDIT', style: GoogleFonts.inter(fontSize: 11, color: AppColors.mutedForeground)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Text('Singida Black Sta...', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600))),
                    Text('3', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('-', style: GoogleFonts.inter(color: AppColors.mutedForeground)),
                    ),
                    Text('1', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    Expanded(child: Text('Fountain', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600))),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                  ),
                  child: Text('Medium confidence', style: GoogleFonts.inter(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Action(Icons.favorite_border, '1'),
              const SizedBox(width: 16),
              _Action(Icons.chat_bubble_outline, '0'),
              const SizedBox(width: 16),
              _Action(Icons.ios_share_outlined, '0'),
              const Spacer(),
              const Icon(Icons.bookmark_border, size: 18, color: AppColors.mutedForeground),
            ],
          ),
        ],
      ),
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
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground)),
      ],
    );
  }
}
