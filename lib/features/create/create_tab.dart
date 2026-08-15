import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';

/// Single Create composer — one screen:
/// text + attach · poll · prediction (no type grid).
class CreateTab extends StatefulWidget {
  const CreateTab({super.key, this.onNeedLogin});

  final VoidCallback? onNeedLogin;

  @override
  State<CreateTab> createState() => _CreateTabState();
}

enum _Mode { post, poll, prediction }

class _CreateTabState extends State<CreateTab> {
  final _text = TextEditingController();
  final _pollQ = TextEditingController();
  final _pollOpts = <TextEditingController>[
    TextEditingController(),
    TextEditingController(),
  ];
  final _home = TextEditingController();
  final _away = TextEditingController();
  final _hs = TextEditingController();
  final _as = TextEditingController();

  _Mode _mode = _Mode.post;
  static const _max = 500;

  @override
  void dispose() {
    _text.dispose();
    _pollQ.dispose();
    for (final c in _pollOpts) {
      c.dispose();
    }
    _home.dispose();
    _away.dispose();
    _hs.dispose();
    _as.dispose();
    super.dispose();
  }

  void _publish() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign in to publish — login at the end')),
    );
    widget.onNeedLogin?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    // Clear / stay on create
                    setState(() {
                      _mode = _Mode.post;
                      _text.clear();
                    });
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      color: AppColors.mutedForeground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    _mode == _Mode.poll
                        ? 'Create poll'
                        : _mode == _Mode.prediction
                            ? 'Prediction'
                            : 'Create',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _publish,
                  child: Text(
                    'Post',
                    style: GoogleFonts.inter(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                GlassCard(
                  borderRadius: 22,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar + field
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.surfaceElevated,
                            child: Icon(Icons.person, color: AppColors.mutedForeground, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _mode == _Mode.poll ? _pollQ : _text,
                              maxLines: _mode == _Mode.prediction ? 2 : 6,
                              maxLength: _mode == _Mode.post ? _max : null,
                              style: GoogleFonts.inter(
                                fontSize: 16.5,
                                height: 1.45,
                                letterSpacing: -0.2,
                              ),
                              decoration: InputDecoration(
                                hintText: _mode == _Mode.poll
                                    ? 'Ask a question…'
                                    : _mode == _Mode.prediction
                                        ? 'Add a note (optional)…'
                                        : "What's happening in sports?",
                                border: InputBorder.none,
                                counterStyle: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.mutedForeground,
                                ),
                                hintStyle: GoogleFonts.inter(
                                  color: AppColors.mutedForeground,
                                  fontSize: 16.5,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (_mode == _Mode.poll) ...[
                        const Divider(color: AppColors.border, height: 20),
                        ...List.generate(_pollOpts.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TextField(
                              controller: _pollOpts[i],
                              decoration: InputDecoration(
                                labelText: 'Option ${String.fromCharCode(65 + i)}',
                                isDense: true,
                                filled: true,
                                fillColor: AppColors.surface,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: AppColors.border),
                                ),
                              ),
                            ),
                          );
                        }),
                        TextButton.icon(
                          onPressed: () {
                            if (_pollOpts.length >= 6) return;
                            setState(() => _pollOpts.add(TextEditingController()));
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add option'),
                        ),
                      ],

                      if (_mode == _Mode.prediction) ...[
                        const Divider(color: AppColors.border, height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _home,
                                decoration: InputDecoration(
                                  labelText: 'Home',
                                  isDense: true,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 48,
                              child: TextField(
                                controller: _hs,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: '0',
                                  isDense: true,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Text('-', style: GoogleFonts.outfit(fontSize: 18, color: AppColors.mutedForeground)),
                            ),
                            SizedBox(
                              width: 48,
                              child: TextField(
                                controller: _as,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: '0',
                                  isDense: true,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _away,
                                decoration: InputDecoration(
                                  labelText: 'Away',
                                  isDense: true,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 8),

                      // Action row: attach · poll · prediction
                      Row(
                        children: [
                          _Tool(
                            icon: Icons.attach_file_rounded,
                            label: 'Attach',
                            active: false,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Photo / video attach — next')),
                              );
                            },
                          ),
                          const SizedBox(width: 6),
                          _Tool(
                            icon: Icons.bar_chart_rounded,
                            label: 'Poll',
                            active: _mode == _Mode.poll,
                            onTap: () => setState(() {
                              _mode = _mode == _Mode.poll ? _Mode.post : _Mode.poll;
                            }),
                          ),
                          const SizedBox(width: 6),
                          _Tool(
                            icon: Icons.track_changes_rounded,
                            label: 'Predict',
                            active: _mode == _Mode.prediction,
                            onTap: () => setState(() {
                              _mode = _mode == _Mode.prediction ? _Mode.post : _Mode.prediction;
                            }),
                          ),
                          const Spacer(),
                          Material(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(22),
                            child: InkWell(
                              onTap: _publish,
                              borderRadius: BorderRadius.circular(22),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                child: Row(
                                  children: [
                                    const Icon(Icons.send_rounded, size: 16, color: AppColors.primaryForeground),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Post',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13.5,
                                        color: AppColors.primaryForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _Tool extends StatelessWidget {
  const _Tool({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.primary.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: active ? AppColors.primary : AppColors.mutedForeground,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                  color: active ? AppColors.primary : AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
