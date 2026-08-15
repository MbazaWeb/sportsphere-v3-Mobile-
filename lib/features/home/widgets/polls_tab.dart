import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/glass_card.dart';

class PollsTab extends StatelessWidget {
  const PollsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        Row(
          children: [
            const Icon(Icons.bar_chart_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Polls', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800)),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create Poll'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                minimumSize: Size.zero,
                textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlassCard(
          borderRadius: 16,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 18, backgroundColor: Color(0xFF3B82F6), child: Icon(Icons.person, size: 18, color: Colors.white)),
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
                        Text('@davidmbazza', style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground)),
                      ],
                    ),
                  ),
                  Text('1d ago', style: GoogleFonts.inter(fontSize: 11, color: AppColors.mutedForeground)),
                ],
              ),
              const SizedBox(height: 12),
              Text('nani mshindi ?', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _Opt(letter: 'A', label: 'Singida Black Stars SC', pct: 100, selected: true),
              const SizedBox(height: 8),
              _Opt(letter: 'B', label: 'Fountain', pct: 0),
              const SizedBox(height: 8),
              _Opt(letter: 'C', label: 'Draw', pct: 0),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.people_outline, size: 14, color: AppColors.mutedForeground),
                  const SizedBox(width: 4),
                  Text('1 votes', style: GoogleFonts.inter(fontSize: 11, color: AppColors.mutedForeground)),
                  const Spacer(),
                  const Icon(Icons.schedule, size: 14, color: AppColors.mutedForeground),
                  const SizedBox(width: 4),
                  Text('13h left', style: GoogleFonts.inter(fontSize: 11, color: AppColors.mutedForeground)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.favorite_border, size: 18, color: AppColors.mutedForeground),
                  const SizedBox(width: 4),
                  Text('1', style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground)),
                  const SizedBox(width: 16),
                  const Icon(Icons.chat_bubble_outline, size: 18, color: AppColors.mutedForeground),
                  const SizedBox(width: 4),
                  Text('0', style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground)),
                  const Spacer(),
                  const Icon(Icons.ios_share_outlined, size: 18, color: AppColors.mutedForeground),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Opt extends StatelessWidget {
  const _Opt({required this.letter, required this.label, required this.pct, this.selected = false});
  final String letter, label;
  final int pct;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF8B7355).withValues(alpha: 0.45) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: selected ? AppColors.primary.withValues(alpha: 0.35) : AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: selected ? AppColors.primaryForeground : AppColors.mutedForeground,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
          Text('$pct%', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: selected ? AppColors.primary : AppColors.mutedForeground)),
        ],
      ),
    );
  }
}
