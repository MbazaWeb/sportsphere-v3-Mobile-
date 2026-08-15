import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bottom_nav.dart';
import '../auth/login_sheet.dart';
import '../auth/register_sheet.dart';
import '../home/home_tab.dart';
import '../scores/scores_tab.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppTab _current = AppTab.home;
  bool _navVisible = true;
  bool _isAuthenticated = false;
  bool _showLogin = false;
  bool _showRegister = false;

  void _openLogin() => setState(() {
        _showLogin = true;
        _showRegister = false;
      });

  void _openRegister() => setState(() {
        _showRegister = true;
        _showLogin = false;
      });

  void _closeAuth() => setState(() {
        _showLogin = false;
        _showRegister = false;
      });

  void _onAuthSuccess() => setState(() {
        _isAuthenticated = true;
        _showLogin = false;
        _showRegister = false;
        _current = AppTab.profile;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.4,
                colors: [
                  AppColors.backgroundSecondary,
                  AppColors.background,
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: _buildTabContent(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNav(
              currentTab: _current,
              isAuthenticated: _isAuthenticated,
              visible: _navVisible,
              onTabSelected: (tab) {
                if ((tab == AppTab.create ||
                        tab == AppTab.activity ||
                        tab == AppTab.profile) &&
                    !_isAuthenticated) {
                  _openLogin();
                  return;
                }
                setState(() => _current = tab);
              },
              onLoginTap: _openLogin,
            ),
          ),

          // Auth overlays
          if (_showLogin)
            LoginSheet(
              onClose: _closeAuth,
              onSuccess: _onAuthSuccess,
              onOpenRegister: _openRegister,
              onOpenForgot: () {
                // Placeholder for forgot password
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Forgot password — coming next')),
                );
              },
            ),
          if (_showRegister)
            RegisterSheet(
              onClose: _closeAuth,
              onSuccess: _onAuthSuccess,
              onOpenLogin: _openLogin,
            ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_current) {
      case AppTab.home:
        return const HomeTab();
      case AppTab.scores:
        return const ScoresTab();
      case AppTab.create:
        return const _Placeholder(title: 'Create', icon: Icons.add_circle_rounded);
      case AppTab.activity:
        return const _Placeholder(title: 'Activity', icon: Icons.notifications_rounded);
      case AppTab.profile:
        return _Placeholder(
          title: _isAuthenticated ? 'Profile' : 'Profile',
          icon: Icons.person_rounded,
          subtitle: _isAuthenticated ? 'You are signed in (demo)' : 'Sign in to view profile',
        );
    }
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.title,
    required this.icon,
    this.subtitle = 'Coming next',
  });
  final String title;
  final IconData icon;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: AppColors.primary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.mutedForeground,
                ),
          ),
        ],
      ),
    );
  }
}
