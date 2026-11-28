import 'package:flutter/material.dart';
import 'package:mozhivora/app/theme/tokens.dart';

/// Subtle pulsing skeleton placeholder for streaming AI output & async loads.
class MozhiSkeleton extends StatefulWidget {
  const MozhiSkeleton({super.key, this.lines = 3});

  final int lines;

  @override
  State<MozhiSkeleton> createState() => _MozhiSkeletonState();
}

class _MozhiSkeletonState extends State<MozhiSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final alpha =
            disableAnimations ? 0.12 : 0.08 + (_controller.value * 0.10);
        final barColor = theme.colorScheme.onSurface.withValues(alpha: alpha);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(widget.lines, (index) {
            final isLast = index == widget.lines - 1;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : MozhiTokens.space8),
              child: FractionallySizedBox(
                widthFactor: isLast ? 0.62 : 1.0,
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(MozhiTokens.space4),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
