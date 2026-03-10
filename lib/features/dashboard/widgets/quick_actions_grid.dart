import 'package:flutter/material.dart';

class QuickActionItem {
  const QuickActionItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key, required this.actions});

  final List<QuickActionItem> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) => _QuickActionTile(
        action: actions[index],
        accent: _accentPalette(index, theme),
      ),
    );
  }
}

Color _accentPalette(int index, ThemeData theme) {
  final palette = [
    const Color(0xFF38BDF8), // neon blue
    const Color(0xFFFB7185), // neon red
    const Color(0xFF4ADE80), // neon green
    const Color(0xFFFBBF24), // neon amber
    const Color(0xFFA78BFA), // neon violet
    const Color(0xFF2DD4BF), // neon teal
  ];
  return palette[index % palette.length];
}

class _QuickActionTile extends StatefulWidget {
  const _QuickActionTile({required this.action, required this.accent});

  final QuickActionItem action;
  final Color accent;

  @override
  State<_QuickActionTile> createState() => _QuickActionTileState();
}

class _QuickActionTileState extends State<_QuickActionTile> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.action.onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: accent.withValues(alpha: 0.12),
        highlightColor: accent.withValues(alpha: 0.08),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 120),
          scale: _pressed ? 0.97 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [const Color(0xFF22252D), const Color(0xFF12141B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _hovered ? 0.28 : 0.22),
                  blurRadius: _hovered ? 22 : 16,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: accent.withValues(alpha: _hovered ? 0.24 : 0.16),
                  blurRadius: _hovered ? 24 : 14,
                  spreadRadius: _hovered ? 0.5 : 0,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: RadialGradient(
                          center: const Alignment(-0.65, -0.78),
                          radius: 1.1,
                          colors: [
                            accent.withValues(alpha: _hovered ? 0.2 : 0.13),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ThreeDIcon(icon: widget.action.icon, accent: accent),
                      const SizedBox(height: 6),
                      Text(
                        widget.action.label,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.6,
                          color: Colors.white.withValues(alpha: 0.92),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThreeDIcon extends StatelessWidget {
  const _ThreeDIcon({required this.icon, required this.accent});

  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(-0.2, -0.2),
              colors: [
                accent.withValues(alpha: 0.58),
                accent.withValues(alpha: 0.06),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.46),
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF151A22), Color(0xFF0C1119)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: accent.withValues(alpha: 0.72), width: 1),
            boxShadow: [
              BoxShadow(color: accent.withValues(alpha: 0.2), blurRadius: 10),
            ],
          ),
        ),
        Positioned(
          top: 8,
          left: 12,
          right: 12,
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: Colors.white.withValues(alpha: 0.34),
            ),
          ),
        ),
        Icon(
          icon,
          size: 16,
          color: accent,
          shadows: [
            Shadow(color: accent.withValues(alpha: 0.85), blurRadius: 14),
          ],
        ),
      ],
    );
  }
}
