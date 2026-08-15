import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';

/// Scores tab skeleton matching web ScoresTab (Matches / Standings).
class ScoresTab extends StatefulWidget {
  const ScoresTab({super.key});

  @override
  State<ScoresTab> createState() => _ScoresTabState();
}

class _ScoresTabState extends State<ScoresTab> {
  String _sub = 'matches'; // matches | standings

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
                'Scores',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Live',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Sub tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _Chip(
                label: 'Matches',
                active: _sub == 'matches',
                onTap: () => setState(() => _sub = 'matches'),
              ),
              const SizedBox(width: 8),
              _Chip(
                label: 'Standings',
                active: _sub == 'standings',
                onTap: () => setState(() => _sub = 'standings'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Filters row (skeleton)
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _FilterChip('All Sports'),
              _FilterChip('Football'),
              _FilterChip('Basketball'),
              _FilterChip('Today'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        Expanded(
          child: _sub == 'matches' ? _MatchesList() : _StandingsList(),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border,
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
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground),
      ),
    );
  }
}

class _MatchesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final demos = [
      ('Arsenal', 'Chelsea', '1', '1', 'LIVE 67\'', true),
      ('Liverpool', 'Man City', '2', '0', 'FT', false),
      ('Barcelona', 'Real Madrid', '-', '-', '20:00', false),
      ('Lakers', 'Celtics', '98', '102', 'Q4', true),
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: demos.length,
      itemBuilder: (context, i) {
        final (home, away, hs, ascore, status, live) = demos[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Premier League',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const Spacer(),
                    if (live)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF22C55E),
                          ),
                        ),
                      )
                    else
                      Text(
                        status,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        home,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                    Text(
                      hs,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: live ? AppColors.primary : AppColors.foreground,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '–',
                        style: GoogleFonts.inter(color: AppColors.mutedForeground),
                      ),
                    ),
                    Text(
                      ascore,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: live ? AppColors.primary : AppColors.foreground,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        away,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StandingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rows = [
      (1, 'Arsenal', 28, 45),
      (2, 'Man City', 27, 42),
      (3, 'Liverpool', 26, 40),
      (4, 'Chelsea', 24, 38),
      (5, 'Tottenham', 22, 35),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      children: [
        GlassCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: Text('#', style: _h()),
                    ),
                    Expanded(child: Text('Team', style: _h())),
                    SizedBox(width: 40, child: Text('P', style: _h(), textAlign: TextAlign.center)),
                    SizedBox(width: 40, child: Text('Pts', style: _h(), textAlign: TextAlign.center)),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.border),
              ...rows.map((r) {
                final (pos, team, played, pts) = r;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          '$pos',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: pos <= 3 ? AppColors.primary : AppColors.foreground,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          team,
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text('$played', textAlign: TextAlign.center, style: GoogleFonts.inter(color: AppColors.mutedForeground)),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '$pts',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle _h() => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.mutedForeground,
      );
}
