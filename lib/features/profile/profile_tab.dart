import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';

/// Profile tab — guest state fully usable; signed-in later
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, this.isAuthenticated = false, this.onSignIn});

  final bool isAuthenticated;
  final VoidCallback? onSignIn;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          // Cover
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF1A2A4A), Color(0xFF0A1628)],
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -28),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.surfaceElevated,
                  child: Icon(Icons.person, size: 40, color: AppColors.mutedForeground),
                ),
                const SizedBox(height: 12),
                Text(
                  isAuthenticated ? 'Athlete' : 'Guest',
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                Text(
                  isAuthenticated ? '@user' : 'Sign in to unlock your profile',
                  style: GoogleFonts.inter(color: AppColors.mutedForeground, fontSize: 13),
                ),
                if (!isAuthenticated) ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: onSignIn,
                    child: const Text('Sign in'),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          GlassCard(
            borderRadius: 14,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                _Tile(Icons.settings_outlined, 'Settings', () {}),
                _Tile(Icons.bookmark_border, 'Saved', () {}),
                _Tile(Icons.emoji_events_outlined, 'Achievements', () {}),
                _Tile(Icons.people_outline, 'Following', () {}),
                _Tile(Icons.help_outline, 'Help', () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.mutedForeground),
      title: Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.mutedForeground),
      onTap: onTap,
    );
  }
}
