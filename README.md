# Sportsphere Mobile (Flutter)

Premium sports social platform — Flutter port of the Sportsphere web app with **identical UI/UX**.

## Design System (v1)

Exact visual match to the Next.js design tokens:

| Token | Value |
|-------|-------|
| Background | `#0A1628` |
| Background Secondary | `#0F1D3A` |
| Primary (Gold) | `#F5C518` |
| Accent (Orange) | `#FF6B35` |
| Glass card | 5% white + 12px blur |
| Fonts | Outfit (headings) + Inter (body) |

### Implemented

- `AppColors` / `AppTypography` / `AppTheme`
- `GlassCard` (backdrop blur, hover lift, gold glow)
- `BottomNav` (active pill, create FAB-style button, login chip, auto-hide)
- `SplashScreen` (progress, rotating words, ambient orbs, fade-out)

### Run

```bash
flutter pub get
flutter run -d chrome          # web preview
flutter run                    # device / emulator
```

### Structure

```
lib/
├── main.dart
├── theme/
│   ├── app_colors.dart
│   ├── app_typography.dart
│   └── app_theme.dart
├── widgets/
│   ├── glass_card.dart
│   └── bottom_nav.dart
└── features/
    ├── splash/splash_screen.dart
    └── shell/app_shell.dart
```

## Roadmap

1. ✅ Design system + Splash + BottomNav
2. Auth (login / register / verify)
3. Home feed
4. Scores & standings
5. Create post
6. Activity
7. Multi-role profile system
