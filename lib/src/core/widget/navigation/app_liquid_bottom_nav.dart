import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

/// Single navigation item for [AppLiquidBottomNav].
@immutable
class AppLiquidNavItem {
  const AppLiquidNavItem({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.semanticLabel,
    this.badgeCount = 0,
  });

  /// Outlined icon used when unselected.
  final IconData icon;

  /// Filled icon used when selected or under the liquid bubble.
  final IconData? selectedIcon;

  /// Text label displayed below the icon.
  final String label;

  /// Optional accessibility label.
  final String? semanticLabel;

  /// Badge count (0 = no badge).
  final int badgeCount;
}

/// Visual and behavioral theme configuration for [AppLiquidBottomNav].
@immutable
class AppLiquidNavTheme {
  const AppLiquidNavTheme({
    this.height = 70,
    this.maxWidth = 430,
    this.horizontalMargin = 16,
    this.bottomGap = 12,
    this.innerHorizontalPadding = 8,
    this.blurSigma = 0,
    this.slideDuration = const Duration(milliseconds: 360),
    this.accentColor,
    this.selectedColor = Colors.white,
    this.unselectedColor,
    this.surfaceColor,
    this.borderColor,
    this.capsuleVerticalInset = 6,
    this.blobHorizontalInset = 5,
    this.capsuleGlow = 1.0,
    this.dragMagnify = 0.11,
    this.dragWiden = 0.34,
    this.dragStretch = 0.24,
    this.dragLift = 0,
    this.dragTopOverflow = 6,
    this.dragBottomOverflow = 6,
    this.bottomLiftHeadroom = 10,
    this.lensIconGain = 0.28,
    this.lensLabelGain = 0.12,
    this.iconSize = 22,
    this.labelFontSize = 10,
    this.pressDuration = const Duration(milliseconds: 120),
    this.iconSwitchDuration = const Duration(milliseconds: 200),
    this.styleDuration = const Duration(milliseconds: 300),
    this.standardCurve = Curves.easeOutCubic,
    this.emphasizedCurve = Curves.easeOutBack,
  })  : assert(height > 0, 'height must be positive'),
        assert(maxWidth > 0, 'maxWidth must be positive'),
        assert(blurSigma >= 0, 'blurSigma must not be negative'),
        assert(
          bottomLiftHeadroom < bottomGap,
          'bottomLiftHeadroom must be < bottomGap',
        );

  final double height;
  final double maxWidth;
  final double horizontalMargin;
  final double bottomGap;
  final double innerHorizontalPadding;
  final double blurSigma;
  final Duration slideDuration;
  final Color? accentColor;
  final Color selectedColor;
  final Color? unselectedColor;
  final Color? surfaceColor;
  final Color? borderColor;
  final double capsuleVerticalInset;
  final double blobHorizontalInset;
  final double capsuleGlow;
  final double dragMagnify;
  final double dragWiden;
  final double dragStretch;
  final double dragLift;
  final double dragTopOverflow;
  final double dragBottomOverflow;
  final double bottomLiftHeadroom;
  final double lensIconGain;
  final double lensLabelGain;
  final double iconSize;
  final double labelFontSize;
  final Duration pressDuration;
  final Duration iconSwitchDuration;
  final Duration styleDuration;
  final Curve standardCurve;
  final Curve emphasizedCurve;

  Color resolveAccent(BuildContext context) =>
      accentColor ?? Theme.of(context).colorScheme.primary;

  Color resolveUnselected(bool isDark) =>
      unselectedColor ?? (isDark ? Colors.white70 : Colors.black54);

  Color resolveSurface(bool isDark) =>
      surfaceColor ??
      (isDark
          ? const Color(0xFF1E293B)
          : Colors.white);

  Color resolveBorder(bool isDark) =>
      borderColor ??
      (isDark
          ? Colors.white.withValues(alpha: 0.14)
          : Colors.black.withValues(alpha: 0.08));
}

/// Floating Liquid Bottom Navigation Bar with solid active indicator and white active text/icon.
class AppLiquidBottomNav extends StatefulWidget {
  const AppLiquidBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.theme = const AppLiquidNavTheme(),
  }) : assert(items.length >= 2, 'Provide at least two items');

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AppLiquidNavItem> items;
  final AppLiquidNavTheme theme;

  @override
  State<AppLiquidBottomNav> createState() => _AppLiquidBottomNavState();
}

class _AppLiquidBottomNavState extends State<AppLiquidBottomNav>
    with TickerProviderStateMixin {
  static const double _dragVerticalSwell = 0.03;
  static const double _maxSquash = 0.06;
  static const double _refVelocity = 16;
  static const double _velRelax = 0.05;
  static const double _stretchEase = 0.06;
  static const double _actEase = 0.11;
  static const double _lensFalloff = 2.2;

  late final AnimationController _controller;
  late final Listenable _capsuleRepaint;

  late int _fromIndex;
  late int _toIndex;

  final ValueNotifier<double?> _dragLeft = ValueNotifier<double?>(null);
  bool _settling = false;
  double _settleFromLeft = 0;
  double _settleToLeft = 0;

  final ValueNotifier<_AppDragFx> _dragFx =
      ValueNotifier<_AppDragFx>(_AppDragFx.rest);
  late final Ticker _fxTicker;

  bool _dragging = false;
  double _vel = 0;
  double _fxActivation = 0;
  double _fxStretch = 0;
  int _lastTickMicros = 0;

  AppLiquidNavTheme get _t => widget.theme;

  @override
  void initState() {
    super.initState();
    _fromIndex = widget.currentIndex;
    _toIndex = widget.currentIndex;
    _controller = AnimationController(
      vsync: this,
      duration: _t.slideDuration,
      value: 1,
    )..addStatusListener(_onControllerStatus);
    _fxTicker = createTicker(_onFxTick);
    _capsuleRepaint = Listenable.merge([_controller, _dragLeft, _dragFx]);
  }

  void _onControllerStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) _settling = false;
  }

  @override
  void didUpdateWidget(covariant AppLiquidBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.theme.slideDuration != oldWidget.theme.slideDuration) {
      _controller.duration = widget.theme.slideDuration;
    }
    if (widget.currentIndex != _toIndex) {
      _flowTo(widget.currentIndex);
    }
  }

  void _flowTo(int target) {
    _settling = false;
    if (target == _toIndex) return;
    _fromIndex = _toIndex;
    _toIndex = target;
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _fxTicker.dispose();
    _controller.dispose();
    _dragLeft.dispose();
    _dragFx.dispose();
    super.dispose();
  }

  void _onFxTick(Duration elapsed) {
    final nowMicros = elapsed.inMicroseconds;
    if (_lastTickMicros == 0) _lastTickMicros = nowMicros;
    final dt = math.min((nowMicros - _lastTickMicros) / 1e6, 0.05);
    _lastTickMicros = nowMicros;
    if (dt <= 0) return;

    final targetAct = _dragging ? 1.0 : 0.0;
    _fxActivation += (targetAct - _fxActivation) * (1 - math.exp(-dt / _actEase));

    final targetStretch = (_vel / _refVelocity).clamp(-1.0, 1.0) * _t.dragStretch;
    _vel *= math.exp(-dt / _velRelax);
    _fxStretch += (targetStretch - _fxStretch) * (1 - math.exp(-dt / _stretchEase));

    if (!_dragging && _fxActivation < 0.001 && _fxStretch.abs() < 0.001) {
      _fxActivation = 0;
      _fxStretch = 0;
      _vel = 0;
      _lastTickMicros = 0;
      _fxTicker.stop();
      _dragFx.value = _AppDragFx.rest;
      return;
    }

    _dragFx.value = _AppDragFx(
      activation: _fxActivation,
      stretch: _fxStretch,
    );
  }

  void _onDragStart(DragStartDetails d, double itemWidth, double pillLeft) {
    _settling = false;
    _dragging = true;
    _vel = 0;
    _lastTickMicros = 0;
    if (!_fxTicker.isActive) _fxTicker.start();
    _updateDragPos(d.localPosition.dx, itemWidth, pillLeft);
  }

  void _onDragUpdate(DragUpdateDetails d, double itemWidth, double pillLeft) {
    _vel = _vel * 0.4 + d.delta.dx * 0.6;
    _updateDragPos(d.localPosition.dx, itemWidth, pillLeft);
  }

  void _updateDragPos(double touchX, double itemWidth, double pillLeft) {
    final localX = touchX - pillLeft - _t.innerHorizontalPadding;
    final minLeft = 0.0;
    final maxLeft = itemWidth * (widget.items.length - 1);
    final target = (localX - itemWidth / 2).clamp(minLeft, maxLeft);
    _dragLeft.value = target;
  }

  void _onDragEnd(DragEndDetails d, double itemWidth) {
    _dragging = false;
    final liveLeft = _dragLeft.value;
    _dragLeft.value = null;
    if (liveLeft == null) return;

    final targetIndex = (liveLeft / itemWidth).round().clamp(
      0,
      widget.items.length - 1,
    );

    _settleFromLeft = liveLeft;
    _settleToLeft = _slotLeft(targetIndex, itemWidth);
    _settling = true;
    _fromIndex = targetIndex;
    _toIndex = targetIndex;

    _controller.forward(from: 0);

    if (targetIndex != widget.currentIndex) {
      HapticFeedback.selectionClick();
      widget.onTap(targetIndex);
    }
  }

  void _onDragCancel() {
    _dragging = false;
    _dragLeft.value = null;
    _settling = false;
    _controller.value = 1;
  }

  double _slotLeft(int index, double itemWidth) => index * itemWidth;

  int _previewIndex(double itemWidth) {
    final drag = _dragLeft.value;
    if (drag == null) return widget.currentIndex;
    return (drag / itemWidth).round().clamp(0, widget.items.length - 1);
  }

  Rect _resolveCapsule(double itemWidth) {
    final t = _t;
    final liveDrag = _dragLeft.value;
    double left;
    double width;

    if (liveDrag != null) {
      left = liveDrag;
      width = itemWidth;
    } else if (_settling) {
      final v = _controller.value;
      final c = t.standardCurve.transform(v);
      left = _settleFromLeft + (_settleToLeft - _settleFromLeft) * c;
      width = itemWidth;
    } else {
      final v = _controller.value;
      if (v >= 1 || _fromIndex == _toIndex) {
        left = _slotLeft(_toIndex, itemWidth);
        width = itemWidth;
      } else {
        final movingRight = _toIndex > _fromIndex;
        final startLeft = _slotLeft(_fromIndex, itemWidth);
        final targetLeft = _slotLeft(_toIndex, itemWidth);
        final leadCurve = t.standardCurve.transform(v);
        final trailCurve = Curves.easeIn.transform(v);

        if (movingRight) {
          final rightEdge = startLeft + itemWidth + (targetLeft - startLeft) * leadCurve;
          left = startLeft + (targetLeft - startLeft) * trailCurve;
          width = rightEdge - left;
        } else {
          final targetRight = targetLeft + itemWidth;
          final startRight = startLeft + itemWidth;
          left = startLeft - (startLeft - targetLeft) * leadCurve;
          final rightEdge = startRight - (startRight - targetRight) * trailCurve;
          width = rightEdge - left;
        }
      }
    }

    final baseTop = t.capsuleVerticalInset;
    final baseHeight = t.height - t.capsuleVerticalInset * 2;

    final fx = _dragFx.value;
    final act = fx.activation;
    final stretch = fx.stretch;

    final widen = act * t.dragWiden;
    final extraStretch = stretch.abs();
    final stretchLeftBias = stretch < 0 ? extraStretch : 0.0;
    final stretchRightBias = stretch > 0 ? extraStretch : 0.0;

    final dynWidth = width * (1 + t.dragMagnify * act + widen + extraStretch);
    final widthDelta = dynWidth - width;
    final dynLeft = left - widthDelta * 0.5 - width * stretchLeftBias + width * stretchRightBias * 0.0;

    final squash = (stretch.abs() * _maxSquash).clamp(0.0, _maxSquash);
    final dynHeight = baseHeight * (1 + _dragVerticalSwell * act - squash);
    final dynTop = baseTop + (baseHeight - dynHeight) * 0.5 - t.dragLift * act;

    return Rect.fromLTWH(dynLeft, dynTop, dynWidth, dynHeight);
  }

  double _lensFactor(int index, double itemWidth) {
    if (itemWidth <= 0) return 0;
    final activation = _dragFx.value.activation;
    if (activation <= 0) return 0;
    final capsule = _resolveCapsule(itemWidth);
    final capsuleCenter = capsule.left + capsule.width / 2;
    final itemCenter = _slotLeft(index, itemWidth) + itemWidth / 2;
    final norm = (capsuleCenter - itemCenter).abs() / itemWidth;
    final proximity = math.exp(-norm * norm * _lensFalloff);
    return proximity * activation;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final items = widget.items;
    final t = _t;

    final fill = t.resolveSurface(isDark);
    final borderColor = t.resolveBorder(isDark);
    final accent = t.resolveAccent(context);
    final selectedColor = t.selectedColor;
    final unselectedColor = t.resolveUnselected(isDark);

    final capsuleColors = _AppLiquidCapsuleColors(
      color: accent,
    );

    final barRadius = BorderRadius.circular(t.height / 2);
    final liftHeadroom = t.dragLift + t.dragTopOverflow + 8;
    final bottomHeadroom = t.bottomLiftHeadroom;
    final bottomPadding = (t.bottomGap - bottomHeadroom).clamp(0.0, double.infinity);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          t.horizontalMargin,
          0,
          t.horizontalMargin,
          bottomPadding,
        ),
        child: Align(
          alignment: Alignment.center,
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: t.maxWidth),
            child: SizedBox(
              height: t.height + liftHeadroom + bottomHeadroom,
              child: RepaintBoundary(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final contentWidth = constraints.maxWidth - t.innerHorizontalPadding * 2;
                    final itemWidth = contentWidth / items.length;

                    final glassBar = DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: barRadius,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: barRadius,
                        child: t.blurSigma > 0
                            ? BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: t.blurSigma,
                                  sigmaY: t.blurSigma,
                                ),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: fill,
                                    borderRadius: barRadius,
                                    border: Border.all(color: borderColor, width: 1),
                                  ),
                                ),
                              )
                            : DecoratedBox(
                                decoration: BoxDecoration(
                                  color: fill,
                                  borderRadius: barRadius,
                                  border: Border.all(color: borderColor, width: 1),
                                ),
                              ),
                      ),
                    );

                    final itemsRow = Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: t.innerHorizontalPadding,
                        ),
                        child: Row(
                          children: [
                            for (var i = 0; i < items.length; i++)
                              Expanded(
                                child: _AppNavItem(
                                  item: items[i],
                                  theme: t,
                                  selected: i == widget.currentIndex,
                                  selectedColor: selectedColor,
                                  unselectedColor: unselectedColor,
                                  reduceMotion: reduceMotion,
                                  lensRepaint: _capsuleRepaint,
                                  lensFactor: () => _lensFactor(i, itemWidth),
                                  previewActive: () => _previewIndex(itemWidth) == i,
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    widget.onTap(i);
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    );

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: liftHeadroom,
                          height: t.height,
                          child: glassBar,
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: liftHeadroom,
                          height: t.height,
                          child: AnimatedBuilder(
                            animation: _capsuleRepaint,
                            builder: (context, staticItems) {
                              final cap = _resolveCapsule(itemWidth);
                              final glowBoost = _dragFx.value.activation;
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: t.innerHorizontalPadding + cap.left,
                                    top: cap.top,
                                    width: cap.width,
                                    height: cap.height,
                                    child: _AppLiquidCapsule(
                                      colors: capsuleColors,
                                      blobHorizontalInset: t.blobHorizontalInset,
                                      glowBoost: glowBoost,
                                    ),
                                  ),
                                  if (staticItems != null) staticItems,
                                ],
                              );
                            },
                            child: itemsRow,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: liftHeadroom,
                          height: t.height,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onHorizontalDragStart: (d) => _onDragStart(d, itemWidth, 0),
                            onHorizontalDragUpdate: (d) => _onDragUpdate(d, itemWidth, 0),
                            onHorizontalDragEnd: (d) => _onDragEnd(d, itemWidth),
                            onHorizontalDragCancel: _onDragCancel,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _AppDragFx {
  const _AppDragFx({required this.activation, required this.stretch});
  final double activation;
  final double stretch;
  static const _AppDragFx rest = _AppDragFx(activation: 0, stretch: 0);
}

@immutable
class _AppLiquidCapsuleColors {
  const _AppLiquidCapsuleColors({
    required this.color,
  });

  final Color color;
}

class _AppLiquidCapsule extends StatelessWidget {
  const _AppLiquidCapsule({
    required this.colors,
    required this.blobHorizontalInset,
    this.glowBoost = 0,
  });

  final _AppLiquidCapsuleColors colors;
  final double blobHorizontalInset;
  final double glowBoost;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: blobHorizontalInset),
      child: CustomPaint(
        painter: _AppLiquidBlobPainter(colors: colors, glowBoost: glowBoost),
      ),
    );
  }
}

class _AppLiquidBlobPainter extends CustomPainter {
  _AppLiquidBlobPainter({required this.colors, required this.glowBoost});

  final _AppLiquidCapsuleColors colors;
  final double glowBoost;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = Offset.zero & size;
    final bulge = glowBoost;
    final body = _squirclePath(rect, bulge: bulge);

    // 1) Soft shadow for subtle elevation
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.10 + 0.05 * glowBoost)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 + 4 * glowBoost);
    canvas.drawPath(
      _squirclePath(rect.shift(Offset(0, 2 + glowBoost)), bulge: bulge),
      shadowPaint,
    );

    // 2) Pure solid primary (teal) color — 100% solid fill, no gradient, no opacity
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = colors.color;
    canvas.drawPath(body, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _AppLiquidBlobPainter old) =>
      old.glowBoost != glowBoost || old.colors != colors;
}

const double _squircleN = 3.2;
const double _lensTaper = 0.24;
const double _restWaist = 0.05;
const double _squircleBulge = 0.08;

Path _squirclePath(Rect rect, {double bulge = 0}) {
  final cx = rect.center.dx;
  final cy = rect.center.dy;
  final a = rect.width / 2;
  final b = rect.height / 2;
  final exp = 2 / _squircleN;
  const steps = 64;
  final path = Path();
  for (var i = 0; i <= steps; i++) {
    final theta = (i / steps) * 2 * math.pi;
    final ct = math.cos(theta);
    final st = math.sin(theta);
    final sx = ct.sign * math.pow(ct.abs(), exp).toDouble();
    final sy = st.sign * math.pow(st.abs(), exp).toDouble();
    final taper = 1 - _lensTaper * sx * sx;
    final swell = 1 + (_restWaist + bulge * _squircleBulge) * (1 - sy.abs());
    final x = cx + a * sx * swell;
    final y = cy + b * sy * taper;
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  return path..close();
}

class _AppNavItem extends StatefulWidget {
  const _AppNavItem({
    required this.item,
    required this.theme,
    required this.selected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.reduceMotion,
    required this.lensRepaint,
    required this.lensFactor,
    required this.previewActive,
    required this.onTap,
  });

  final AppLiquidNavItem item;
  final AppLiquidNavTheme theme;
  final bool selected;
  final Color selectedColor;
  final Color unselectedColor;
  final bool reduceMotion;
  final Listenable lensRepaint;
  final double Function() lensFactor;
  final bool Function() previewActive;
  final VoidCallback onTap;

  @override
  State<_AppNavItem> createState() => _AppNavItemState();
}

class _AppNavItemState extends State<_AppNavItem> {
  bool _down = false;

  void _setDown(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final pressDuration = widget.reduceMotion ? Duration.zero : t.pressDuration;
    final switchDuration = widget.reduceMotion ? Duration.zero : t.iconSwitchDuration;
    final styleDuration = widget.reduceMotion ? Duration.zero : t.styleDuration;

    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.item.semanticLabel ?? widget.item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setDown(true),
        onTapUp: (_) => _setDown(false),
        onTapCancel: () => _setDown(false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _down ? 0.90 : 1.0,
          duration: pressDuration,
          curve: t.standardCurve,
          child: AnimatedBuilder(
            animation: widget.lensRepaint,
            builder: (context, _) {
              final active = widget.selected || widget.previewActive();
              final color = active ? widget.selectedColor : widget.unselectedColor;
              final iconData = active ? (widget.item.selectedIcon ?? widget.item.icon) : widget.item.icon;
              final lens = widget.lensFactor();

              Widget icon = AnimatedSwitcher(
                duration: switchDuration,
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: Icon(
                  iconData,
                  key: ValueKey(active),
                  size: t.iconSize,
                  color: color,
                ),
              );
              if (widget.item.badgeCount > 0) {
                icon = Badge(
                  label: Text('${widget.item.badgeCount}'),
                  child: icon,
                );
              }
              icon = AnimatedScale(
                scale: active ? 1.12 : 1.0,
                duration: styleDuration,
                curve: active ? t.emphasizedCurve : t.standardCurve,
                child: icon,
              );
              if (lens > 0) {
                icon = Transform.scale(
                  scale: 1 + t.lensIconGain * lens,
                  child: icon,
                );
              }

              Widget label = AnimatedDefaultTextStyle(
                duration: styleDuration,
                curve: t.standardCurve,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: t.labelFontSize,
                  height: 1.1,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
                child: Text(
                  widget.item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
              if (lens > 0) {
                label = Transform.scale(
                  scale: 1 + t.lensLabelGain * lens,
                  child: label,
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [icon, const SizedBox(height: 3), label],
              );
            },
          ),
        ),
      ),
    );
  }
}
