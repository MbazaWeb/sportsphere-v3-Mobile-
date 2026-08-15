import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';

/// Create tab matching web CREATE_TYPES grid + composers.
class CreateTab extends StatefulWidget {
  const CreateTab({super.key, this.onNeedLogin});

  final VoidCallback? onNeedLogin;

  @override
  State<CreateTab> createState() => _CreateTabState();
}

class _CreateTabState extends State<CreateTab> {
  String? _activeType; // null = grid

  static const _types = [
    _CreateType('post', 'Post', Icons.article_outlined, Color(0xFF60A5FA), 'Share your thoughts'),
    _CreateType('photo', 'Photo', Icons.image_outlined, Color(0xFFF472B6), 'Share a moment'),
    _CreateType('video', 'Video', Icons.videocam_outlined, Color(0xFFA78BFA), 'Upload a clip'),
    _CreateType('spotlight', 'Spotlight', Icons.bolt_rounded, AppColors.primary, 'Short vertical reel'),
    _CreateType('poll', 'Poll', Icons.bar_chart_rounded, Color(0xFF22D3EE), 'Ask your fans'),
    _CreateType('prediction', 'Prediction', Icons.track_changes, Color(0xFF4ADE80), 'Predict a match'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: _activeType == null ? _buildGrid() : _buildComposer(_activeType!),
      ),
    );
  }

  Widget _buildGrid() {
    return ListView(
      key: const ValueKey('grid'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        Text('Create', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
        const SizedBox(height: 6),
        Text(
          'Share moments, polls, predictions and more',
          style: GoogleFonts.inter(fontSize: 13.5, color: AppColors.mutedForeground, letterSpacing: -0.1),
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.15,
          children: _types.map((t) {
            return GestureDetector(
              onTap: () => setState(() => _activeType = t.id),
              child: AnimatedGlassCard(
                index: _types.indexOf(t),
                borderRadius: 20,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: t.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: t.color.withValues(alpha: 0.25)),
                      ),
                      child: Icon(t.icon, color: t.color, size: 22),
                    ),
                    const Spacer(),
                    Text(
                      t.label,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15.5, letterSpacing: -0.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.desc,
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.mutedForeground, height: 1.3),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildComposer(String type) {
    final meta = _types.firstWhere((e) => e.id == type);
    return Column(
      key: ValueKey(type),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _activeType = null),
                icon: const Icon(Icons.chevron_left_rounded, size: 28),
              ),
              Text(
                meta.label,
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            children: [
              if (type == 'post' || type == 'photo' || type == 'video' || type == 'spotlight')
                _PostComposer(type: type, onPublish: _onPublish),
              if (type == 'poll') _PollComposer(onPublish: _onPublish),
              if (type == 'prediction') _PredictionComposer(onPublish: _onPublish),
            ],
          ),
        ),
      ],
    );
  }

  void _onPublish() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign in to publish — login phase next')),
    );
    widget.onNeedLogin?.call();
  }
}

class _CreateType {
  const _CreateType(this.id, this.label, this.icon, this.color, this.desc);
  final String id, label, desc;
  final IconData icon;
  final Color color;
}

class _PostComposer extends StatefulWidget {
  const _PostComposer({required this.type, required this.onPublish});
  final String type;
  final VoidCallback onPublish;

  @override
  State<_PostComposer> createState() => _PostComposerState();
}

class _PostComposerState extends State<_PostComposer> {
  final _ctrl = TextEditingController();
  static const maxLen = 500;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _ctrl,
            maxLines: 6,
            maxLength: maxLen,
            onChanged: (_) => setState(() {}),
            style: GoogleFonts.inter(fontSize: 16, height: 1.45, letterSpacing: -0.15),
            decoration: InputDecoration(
              hintText: widget.type == 'spotlight'
                  ? 'Caption your spotlight…'
                  : "What's happening in sports?",
              border: InputBorder.none,
              counterStyle: GoogleFonts.inter(fontSize: 11, color: AppColors.mutedForeground),
              hintStyle: GoogleFonts.inter(color: AppColors.mutedForeground, fontSize: 16),
            ),
          ),
          if (widget.type == 'photo' || widget.type == 'video' || widget.type == 'spotlight') ...[
            const SizedBox(height: 8),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.type == 'video' || widget.type == 'spotlight'
                        ? Icons.videocam_outlined
                        : Icons.add_photo_alternate_outlined,
                    size: 32,
                    color: AppColors.mutedForeground,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.type == 'video'
                        ? 'Tap to add video'
                        : widget.type == 'spotlight'
                            ? 'Tap to add vertical video'
                            : 'Tap to add photo',
                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.mutedForeground),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.tag, size: 18, color: AppColors.mutedForeground.withValues(alpha: 0.8)),
              const SizedBox(width: 12),
              Icon(Icons.location_on_outlined, size: 18, color: AppColors.mutedForeground.withValues(alpha: 0.8)),
              const Spacer(),
              ElevatedButton(
                onPressed: widget.onPublish,
                child: const Text('Publish'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PollComposer extends StatefulWidget {
  const _PollComposer({required this.onPublish});
  final VoidCallback onPublish;

  @override
  State<_PollComposer> createState() => _PollComposerState();
}

class _PollComposerState extends State<_PollComposer> {
  final _q = TextEditingController();
  final _opts = [TextEditingController(), TextEditingController()];

  @override
  void dispose() {
    _q.dispose();
    for (final o in _opts) {
      o.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _q,
            maxLines: 2,
            style: GoogleFonts.inter(fontSize: 16, letterSpacing: -0.15),
            decoration: InputDecoration(
              hintText: 'Ask a question…',
              border: InputBorder.none,
              hintStyle: GoogleFonts.inter(color: AppColors.mutedForeground),
            ),
          ),
          const Divider(color: AppColors.border),
          ...List.generate(_opts.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: _opts[i],
                decoration: InputDecoration(
                  labelText: 'Option ${String.fromCharCode(65 + i)}',
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            );
          }),
          TextButton.icon(
            onPressed: () {
              if (_opts.length >= 6) return;
              setState(() => _opts.add(TextEditingController()));
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add option'),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(onPressed: widget.onPublish, child: const Text('Create poll')),
          ),
        ],
      ),
    );
  }
}

class _PredictionComposer extends StatelessWidget {
  const _PredictionComposer({required this.onPublish});
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Pick a scoreline',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.mutedForeground),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: TextField(decoration: InputDecoration(labelText: 'Home team', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
              const SizedBox(width: 8),
              SizedBox(
                width: 52,
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: '0', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text('-', style: GoogleFonts.outfit(fontSize: 20, color: AppColors.mutedForeground)),
              ),
              SizedBox(
                width: 52,
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: '0', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: TextField(decoration: InputDecoration(labelText: 'Away team', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(onPressed: onPublish, child: const Text('Predict')),
          ),
        ],
      ),
    );
  }
}
