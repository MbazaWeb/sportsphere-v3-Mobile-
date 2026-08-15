import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';

/// Create tab — Post / Poll / Prediction (UI ready; submit needs auth later)
class CreateTab extends StatefulWidget {
  const CreateTab({super.key});

  @override
  State<CreateTab> createState() => _CreateTabState();
}

class _CreateTabState extends State<CreateTab> {
  int _mode = 0; // 0 post, 1 poll, 2 prediction
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          Text('Create', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          Row(
            children: [
              _Chip(label: 'Post', active: _mode == 0, onTap: () => setState(() => _mode = 0)),
              const SizedBox(width: 8),
              _Chip(label: 'Poll', active: _mode == 1, onTap: () => setState(() => _mode = 1)),
              const SizedBox(width: 8),
              _Chip(label: 'Prediction', active: _mode == 2, onTap: () => setState(() => _mode = 2)),
            ],
          ),
          const SizedBox(height: 16),
          GlassCard(
            borderRadius: 16,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _text,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: _mode == 0
                        ? "What's happening in sports?"
                        : _mode == 1
                            ? 'Ask a question…'
                            : 'Your prediction notes…',
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.inter(color: AppColors.mutedForeground),
                  ),
                  style: GoogleFonts.inter(fontSize: 15, height: 1.4),
                ),
                if (_mode == 1) ...[
                  const Divider(color: AppColors.border),
                  _PollOptionField(label: 'Option A'),
                  _PollOptionField(label: 'Option B'),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add option'),
                  ),
                ],
                if (_mode == 2) ...[
                  const Divider(color: AppColors.border),
                  Row(
                    children: [
                      Expanded(child: TextField(decoration: const InputDecoration(labelText: 'Home'))),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 48,
                        child: TextField(keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: '0'), textAlign: TextAlign.center),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('-')),
                      SizedBox(
                        width: 48,
                        child: TextField(keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: '0'), textAlign: TextAlign.center),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(decoration: const InputDecoration(labelText: 'Away'))),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.image_outlined, color: AppColors.mutedForeground)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.videocam_outlined, color: AppColors.mutedForeground)),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sign in to publish — login coming next')),
                        );
                      },
                      child: Text(_mode == 0 ? 'Post' : _mode == 1 ? 'Create poll' : 'Predict'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: active ? AppColors.primaryForeground : AppColors.mutedForeground,
          ),
        ),
      ),
    );
  }
}

class _PollOptionField extends StatelessWidget {
  const _PollOptionField({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
