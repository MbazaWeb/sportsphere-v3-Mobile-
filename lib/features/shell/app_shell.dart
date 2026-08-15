import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bottom_nav.dart';
import '../auth/login_sheet.dart';
import '../auth/register_sheet.dart';
import '../home/home_tab.dart';
import '../scores/scores_tab.dart';
import '../create/create_tab.dart';
import '../activity/activity_tab.dart';
import '../profile/profile_tab.dart';

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
                colors: [AppColors.backgroundSecondary, AppColors.background],
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
                // Allow browsing all tabs; create/activity/profile show guest-friendly UI
                setState(() => _current = tab);
              },
              onLoginTap: _openLogin,
            ),
          ),
          if (_showLogin)
            LoginSheet(
              onClose: _closeAuth,
              onSuccess: _onAuthSuccess,
              onOpenRegister: _openRegister,
              onOpenForgot: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Forgot password — wire with login')),
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
        return CreateTab(onNeedLogin: _openLogin);
      case AppTab.activity:
        return ActivityTab(onSignIn: _openLogin);
      case AppTab.profile:
        return ProfileTab(
          isAuthenticated: _isAuthenticated,
          onSignIn: _openLogin,
        );
    }
  }
}
