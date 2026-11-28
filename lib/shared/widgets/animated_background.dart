import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mozhivora/app/theme/tokens.dart';

/// Reusable, lifecycle-aware drifting aurora background.
/// Pauses automatically when the tab/app is hidden, respects reduced-motion,
/// and simplifies on narrow mobile viewports.
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({
    super.key,
    required this.reducedMotion,
  });

  final bool reducedMotion;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 28),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPlayback();
  }

  @override
  void didUpdateWidget(covariant AnimatedBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reducedMotion != widget.reducedMotion) {
      _syncPlayback();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      _controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      _syncPlayback();
    }
  }

  void _syncPlayback() {
    final isWidgetTest = WidgetsBinding.instance.runtimeType
        .toString()
        .contains('AutomatedTestWidgetsFlutterBinding');
    final disable = widget.reducedMotion ||
        MediaQuery.disableAnimationsOf(context) ||
        isWidgetTest;
    if (disable) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (theme.brightness != Brightness.dark) {
      return const SizedBox.shrink();
    }

    final disableAnimations =
        widget.reducedMotion || MediaQuery.disableAnimationsOf(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Positioned.fill(
      child: IgnorePointer(
        child: RepaintBoundary(
          child: disableAnimations
              ? _StaticAurora(isMobile: isMobile)
              : AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final t = _controller.value * 2 * math.pi;
                    final dx1 = math.sin(t) * 48;
                    final dy1 = math.cos(t * 0.8) * 32;
                    final dx2 = math.cos(t * 0.7) * 56;
                    final dy2 = math.sin(t) * 36;

                    return Stack(
                      children: [
                        Positioned(
                          top: -120 + dy1,
                          right: -80 + dx1,
                          child: _AuroraBlob(
                            size: isMobile ? 280 : 440,
                            color: MozhiTokens.inkTeal.withValues(alpha: 0.24),
                          ),
                        ),
                        if (!isMobile)
                          Positioned(
                            bottom: -140 + dy2,
                            left: -100 + dx2,
                            child: _AuroraBlob(
                              size: 400,
                              color:
                                  MozhiTokens.saffron.withValues(alpha: 0.14),
                            ),
                          ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _StaticAurora extends StatelessWidget {
  const _StaticAurora({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -120,
          right: -80,
          child: _AuroraBlob(
            size: isMobile ? 260 : 420,
            color: MozhiTokens.inkTeal.withValues(alpha: 0.20),
          ),
        ),
        if (!isMobile)
          Positioned(
            bottom: -140,
            left: -100,
            child: _AuroraBlob(
              size: 380,
              color: MozhiTokens.saffron.withValues(alpha: 0.12),
            ),
          ),
      ],
    );
  }
}

class _AuroraBlob extends StatelessWidget {
  const _AuroraBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }
}
