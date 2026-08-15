import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/providers/app_providers.dart';
import '../../core/security/biometric_lock.dart';
import 'presentation/edit_profile_sheet.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({
    super.key,
    this.isAuthenticated = false,
    this.onSignIn,
    this.onSignOut,
  });

  final bool isAuthenticated;
  final VoidCallback? onSignIn;
  final Future<void> Function()? onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    final authed = auth.isAuthenticated;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF1A2A4A), Color(0xFF0A1628)],
              ),
              image: user?.coverUrl != null && user!.coverUrl!.isNotEmpty
                  ? DecorationImage(image: NetworkImage(user.coverUrl!), fit: BoxFit.cover)
                  : null,
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -28),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.surfaceElevated,
                  backgroundImage: user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty
                      ? NetworkImage(user.avatarUrl!)
                      : null,
                  child: user?.avatarUrl == null || user!.avatarUrl!.isEmpty
                      ? Icon(Icons.person, size: 40, color: AppColors.mutedForeground)
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  authed ? (user?.name ?? 'Athlete') : 'Guest',
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                Text(
                  authed
                      ? (user?.handle.startsWith('@') == true ? user!.handle : '@${user?.handle ?? 'user'}')
                      : 'Sign in to unlock your profile',
                  style: GoogleFonts.inter(color: AppColors.mutedForeground, fontSize: 13),
                ),
                if (authed && user != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Stat('${user.followerCount}', 'Followers'),
                      const SizedBox(width: 24),
                      _Stat('${user.followingCount}', 'Following'),
                      const SizedBox(width: 24),
                      _Stat('${user.postCount}', 'Posts'),
                    ],
                  ),
                ],
                if (!authed) ...[
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
                _Tile(Icons.edit_outlined, 'Edit profile', () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const EditProfileSheet(),
                  );
                }),
                _Tile(Icons.settings_outlined, 'Settings', () {}),
                if (authed) const _BiometricTile(),
                _Tile(Icons.bookmark_border, 'Saved', () {}),
                _Tile(Icons.emoji_events_outlined, 'Achievements', () {}),
                _Tile(Icons.people_outline, 'Following', () {}),
                _Tile(Icons.help_outline, 'Help', () {}),
                if (authed)
                  _Tile(Icons.logout, 'Sign out', () async {
                    await onSignOut?.call();
                  }, danger: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 16)),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.mutedForeground)),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.label, this.onTap, {this.danger = false});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.destructive : AppColors.mutedForeground;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: danger ? AppColors.destructive : null,
        ),
      ),
      trailing: danger ? null : const Icon(Icons.chevron_right, color: AppColors.mutedForeground),
      onTap: onTap,
    );
  }
}


class _BiometricTile extends StatefulWidget {
  const _BiometricTile();

  @override
  State<_BiometricTile> createState() => _BiometricTileState();
}

class _BiometricTileState extends State<_BiometricTile> {
  final _lock = BiometricLock();
  bool _enabled = false;
  bool _available = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await _lock.isEnabled();
    final available = await _lock.canCheck();
    if (!mounted) return;
    setState(() {
      _enabled = enabled;
      _available = available;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const ListTile(
        leading: Icon(Icons.fingerprint, color: AppColors.mutedForeground),
        title: Text('Biometric lock'),
      );
    }
    return SwitchListTile(
      secondary: const Icon(Icons.fingerprint, color: AppColors.mutedForeground),
      title: Text('Biometric lock', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      subtitle: Text(
        _available
            ? 'Require Face ID / fingerprint when opening the app'
            : 'Not available on this device',
        style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground),
      ),
      value: _enabled && _available,
      activeColor: AppColors.primary,
      onChanged: !_available
          ? null
          : (v) async {
              if (v) {
                final ok = await _lock.authenticate(reason: 'Enable biometric lock');
                if (!ok) return;
              }
              await _lock.setEnabled(v);
              if (!mounted) return;
              setState(() => _enabled = v);
            },
    );
  }
}
