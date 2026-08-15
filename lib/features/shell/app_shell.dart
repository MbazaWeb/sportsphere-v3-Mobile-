import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/glass_card.dart';

/// Main app shell with bottom navigation matching the original UX.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppTab _current = AppTab.home;
  bool _navVisible = true;
  bool _isAuthenticated = false; // demo toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background gradient (matches body radial gradient)
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

          // Content
          SafeArea(
            bottom: false,
            child: _buildTabContent(),
          ),

          // Bottom nav
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNav(
              currentTab: _current,
              isAuthenticated: _isAuthenticated,
              visible: _navVisible,
              onTabSelected: (tab) => setState(() => _current = tab),
              onLoginTap: () {
                // Demo: toggle auth for preview
                setState(() => _isAuthenticated = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged in (demo)')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_current) {
      case AppTab.home:
        return _HomePlaceholder(onToggleNav: () {
          setState(() => _navVisible = !_navVisible);
        });
      case AppTab.scores:
        return const _Placeholder(title: 'Scores', icon: Icons.emoji_events_rounded);
      case AppTab.create:
        return const _Placeholder(title: 'Create', icon: Icons.add_circle_rounded);
      case AppTab.activity:
        return const _Placeholder(title: 'Activity', icon: Icons.notifications_rounded);
      case AppTab.profile:
        return const _Placeholder(title: 'Profile', icon: Icons.person_rounded);
    }
  }
}

class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder({required this.onToggleNav});
  final VoidCallback onToggleNav;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        Text(
          'Home',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Design system preview — same UI/UX as web',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.mutedForeground,
              ),
        ),
        const SizedBox(height: 24),

        // Glass cards demo
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: AppColors.gradientGold),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.sports_soccer, color: AppColors.primaryForeground, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Glass Card', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          'Matches .glass-card CSS exactly',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Backdrop blur · 5% white fill · subtle border · hover lift + gold glow',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          glow: true,
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Gold glow enabled',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Color swatches
        Text('Color Tokens', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            _ColorSwatch('Primary', AppColors.primary),
            _ColorSwatch('Accent', AppColors.accent),
            _ColorSwatch('Background', AppColors.background),
            _ColorSwatch('Secondary', AppColors.backgroundSecondary),
            _ColorSwatch('Destructive', AppColors.destructive),
          ],
        ),
        const SizedBox(height: 24),

        ElevatedButton(
          onPressed: onToggleNav,
          child: const Text('Toggle Bottom Nav (auto-hide demo)'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Outlined Gold Button'),
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.title, required this.icon});
  final String title;
  final IconData icon;

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
            'Coming next',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.mutedForeground,
                ),
          ),
        ],
      ),
    );
  }
}
