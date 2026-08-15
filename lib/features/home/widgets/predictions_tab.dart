import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/glass_card.dart';

class PredictionsTab extends StatelessWidget {
  const PredictionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        Row(
          children: [
            const Icon(Icons.adjust, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Predictions', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800)),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Predict'),
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
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.trending_up, size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text('Score Prediction', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.schedule, size: 12, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text('PENDING', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Text('Singida Black Stars SC', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600))),
                        Text('3', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.primary)),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('-', style: GoogleFonts.inter(color: AppColors.mutedForeground, fontSize: 20))),
                        Text('1', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.primary)),
                        Expanded(child: Text('Fountain', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('MEDIUM CONF.', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      ),
                    ),
                  ],
                ),
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
                  const SizedBox(width: 4),
                  Text('0', style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
