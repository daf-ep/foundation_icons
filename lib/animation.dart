// Copyright (C) 2025 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

part of 'icons.dart';

/// {@template icon_controller}
/// A simple wrapper around Flutter's [AnimationController] designed specifically
/// for controlling icon animations.
///
/// [IconController] provides a clean and restricted API to:
/// - Trigger animations forward or in reverse.
/// - Play animations in a "ping-pong" manner (forward then reverse).
/// - Expose animation lifecycle status and values.
///
/// It is typically used in combination with [IconAnimation] to animate icons
/// declaratively in the UI.
///
/// ### Example usage:
/// ```dart
/// final controller = IconController(vsync: this, duration: Duration(milliseconds: 300));
///
/// controller.forward();
/// controller.playPingPong();
/// ```
/// {@endtemplate}
class IconController {
  /// {@macro icon_controller}
  ///
  /// Creates an [IconController] with the given [vsync] and [duration].
  ///
  /// - [vsync] is required to synchronize the animation with the widget lifecycle.
  /// - [duration] defines the total time for the animation to complete.
  IconController({required TickerProvider vsync, required Duration duration})
    : _controller = AnimationController(vsync: vsync, duration: duration);

  final AnimationController _controller;

  /// Starts the animation in the forward direction.
  ///
  /// Returns a [Future] that completes when the animation finishes.
  Future<void> forward() async {
    await _controller.forward();
    _controller.reset();
  }

  /// Starts the animation in the reverse direction.
  ///
  /// Returns a [Future] that completes when the reverse animation finishes.
  Future<void> reverse() async {
    await _controller.reverse();
    _controller.reset();
  }

  /// Plays the animation forward and then automatically reverses it.
  ///
  /// This is commonly used for simple "tap" or "toggle" effects.
  Future<void> playPingPong() async {
    await _controller.forward();
    await _controller.reverse();
    _controller.reset();
  }

  /// Disposes the internal [AnimationController].
  ///
  /// Must be called when no longer needed to release resources.
  void dispose() => _controller.dispose();

  /// Adds a listener that is called every time the animation’s value changes.
  void addListener(VoidCallback listener) => _controller.addListener(listener);

  /// Removes a previously added listener.
  void removeListener(VoidCallback listener) => _controller.removeListener(listener);

  /// Adds a listener that is called every time the animation’s status changes.
  void addStatusListener(AnimationStatusListener listener) => _controller.addStatusListener(listener);

  /// Removes a previously added status listener.
  void removeStatusListener(AnimationStatusListener listener) => _controller.removeStatusListener(listener);

  /// Returns `true` if the animation has completed (fully played forward).
  bool get isCompleted => _controller.status == AnimationStatus.completed;

  /// Returns `true` if the animation is currently playing forward or reversing.
  bool get isAnimating =>
      _controller.status == AnimationStatus.forward || _controller.status == AnimationStatus.reverse;

  /// Returns `true` if the animation is fully dismissed (reset to start).
  bool get isDismissed => _controller.status == AnimationStatus.dismissed;

  /// Returns the current animation progress as a value between 0.0 and 1.0.
  double get value => _controller.value;
}

/// {@template particle_animation}
/// A widget that renders a particle-style animation composed of:
///
/// - **bubbles** (`_BubblesPainter`) appearing around the child widget,
/// - **concentric circles** (`_CirclePainter`) expanding outward,
/// - **child scaling** (zoom in/out effect).
///
/// Typically used for "like", "favorite", or "reaction" buttons.
///
/// The animation is externally controlled via an [AnimationController]
/// passed in through the constructor, allowing the parent to start,
/// stop, or replay the animation.
/// {@endtemplate}
class _ParticleAnimation extends StatefulWidget {
  /// {@macro particle_animation}
  const _ParticleAnimation({
    required this.size,
    required this.child,
    required this.bubblesColor,
    required this.circleColor,
    required this.controller,
  });

  /// {@template particle_animation.size}
  /// The size (in logical pixels) of the animated widget.
  ///
  /// It defines:
  /// - the size of the [child] widget,
  /// - the drawing area for bubbles,
  /// - the drawing area for concentric circles.
  /// {@endtemplate}
  final double size;

  /// {@template particle_animation.bubbles_color}
  /// Defines the colors used for drawing the animated bubbles
  /// around the widget.
  ///
  /// Represented by a [BubblesColor] instance.
  /// {@endtemplate}
  final BubblesColor bubblesColor;

  /// {@template particle_animation.circle_color}
  /// Defines the colors used for drawing the concentric circles.
  ///
  /// Represented by a [CircleColor] instance.
  /// {@endtemplate}
  final CircleColor circleColor;

  /// {@template particle_animation.child}
  /// The child widget placed at the center of the animation
  /// (e.g., a heart icon).
  /// {@endtemplate}
  final Widget child;

  /// {@template particle_animation.controller}
  /// External [AnimationController] that drives the entire animation.
  ///
  /// This allows the parent widget to control when the animation
  /// starts, stops, or repeats.
  /// {@endtemplate}
  final AnimationController controller;

  @override
  State<StatefulWidget> createState() => _ParticleAnimationState();
}

/// Internal state for [_ParticleAnimation].
///
/// Handles animation setup, building, and rendering
/// of the different visual layers.
class _ParticleAnimationState extends State<_ParticleAnimation> with TickerProviderStateMixin {
  late Animation<double> _outerCircleAnimation;
  late Animation<double> _innerCircleAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bubblesAnimation;

  @override
  void initState() {
    super.initState();
    _initControlAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (BuildContext c, Widget? w) {
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            // --- Bubbles layer ---
            Positioned(
              top: (widget.size - (widget.size * 2)) / 2.0,
              left: (widget.size - (widget.size * 2)) / 2.0,
              child: CustomPaint(
                size: Size((widget.size * 2), (widget.size * 2)),
                painter: _BubblesPainter(
                  currentProgress: _bubblesAnimation.value,
                  color1: widget.bubblesColor.dotPrimaryColor,
                  color2: widget.bubblesColor.dotSecondaryColor,
                  color3: widget.bubblesColor.dotSecondaryColor,
                  color4: widget.bubblesColor.dotSecondaryColor,
                ),
              ),
            ),

            // --- Concentric circles layer ---
            Positioned(
              top: (widget.size - (widget.size * 0.8)) / 2.0,
              left: (widget.size - (widget.size * 0.8)) / 2.0,
              child: CustomPaint(
                size: Size((widget.size * 0.8), (widget.size * 0.8)),
                painter: _CirclePainter(
                  innerCircleRadiusProgress: _innerCircleAnimation.value,
                  outerCircleRadiusProgress: _outerCircleAnimation.value,
                  circleColor: widget.circleColor,
                ),
              ),
            ),

            // --- Main child with scaling ---
            Container(
              width: widget.size,
              height: widget.size,
              alignment: Alignment.center,
              child: Transform.scale(
                scale: widget.controller.isAnimating ? _scaleAnimation.value : 1.0,
                child: SizedBox(height: widget.size, width: widget.size, child: widget.child),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Initializes all the animations that control:
  /// - outer circle expansion,
  /// - inner circle expansion,
  /// - child scaling,
  /// - bubbles animation.
  void _initControlAnimation() {
    _outerCircleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.0, 0.3, curve: Curves.ease),
      ),
    );

    _innerCircleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.2, 0.5, curve: Curves.ease),
      ),
    );

    final Animation<double> animate = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.35, 0.7, curve: _OvershootCurve()),
      ),
    );

    _scaleAnimation = animate;

    _bubblesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.1, 1.0, curve: Curves.decelerate),
      ),
    );
  }
}

/// {@template deg_to_rad}
/// Converts an angle from degrees to radians.
///
/// Formula:
/// ```
/// radians = degrees * (π / 180)
/// ```
///
/// Commonly used for Flutter animations and custom painters
/// that require trigonometric functions.
/// {@endtemplate}
num _degToRad(num deg) => deg * (math.pi / 180.0);

/// {@template map_value_range}
/// Maps a [value] from one numeric range into another.
///
/// Example:
/// ```dart
/// _mapValueFromRangeToRange(5, 0, 10, 0, 100); // → 50
/// ```
///
/// This is useful for scaling animations or converting
/// values from one coordinate system to another.
/// {@endtemplate}
double _mapValueFromRangeToRange(double value, double fromLow, double fromHigh, double toLow, double toHigh) =>
    toLow + ((value - fromLow) / (fromHigh - fromLow) * (toHigh - toLow));

/// {@template clamp}
/// Restricts a [value] to be within the range `[low, high]`.
///
/// - If [value] < [low], returns [low].
/// - If [value] > [high], returns [high].
/// - Otherwise, returns [value].
///
/// Example:
/// ```dart
/// _clamp(15, 0, 10); // → 10
/// _clamp(-5, 0, 10); // → 0
/// _clamp(7, 0, 10);  // → 7
/// ```
/// {@endtemplate}
double _clamp(double value, double low, double high) => math.min(math.max(value, low), high);

/// {@template bubbles_color}
/// Defines the color scheme for the animated **bubbles**
/// in the particle animation.
///
/// - [dotPrimaryColor] → main bubble color
/// - [dotSecondaryColor] → secondary bubble color
///
/// Typically used inside the [_BubblesPainter].
/// {@endtemplate}
class BubblesColor {
  /// {@macro bubbles_color}
  const BubblesColor({required this.dotPrimaryColor, required this.dotSecondaryColor});

  /// Primary bubble color.
  final Color dotPrimaryColor;

  /// Secondary bubble color.
  final Color dotSecondaryColor;
}

/// {@template circle_color}
/// Defines the color scheme for the animated **concentric circles**.
///
/// - [start] → inner color
/// - [end] → outer color
///
/// Typically used inside the [_CirclePainter].
/// {@endtemplate}
class CircleColor {
  /// {@macro circle_color}
  const CircleColor({required this.start, required this.end});

  /// Color at the inner edge of the circle.
  final Color start;

  /// Color at the outer edge of the circle.
  final Color end;
}

/// {@template overshoot_curve}
/// A custom animation curve that produces an **overshoot effect**.
///
/// This means the value will briefly go beyond its target (greater than 1.0)
/// before settling back, giving a "springy" feel.
///
/// Formula (with constant `s = 2.5`):
/// ```dart
/// t = t - 1.0;
/// return t * t * ((s + 1) * t + s) + 1.0;
/// ```
///
/// Used in the particle animation for scaling the child widget.
/// {@endtemplate}
class _OvershootCurve extends Curve {
  /// {@macro overshoot_curve}
  const _OvershootCurve();

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    t -= 1.0;
    return t * t * ((2.5 + 1) * t + 2.5) + 1.0;
  }

  @override
  String toString() {
    return '$runtimeType(2.5)';
  }
}

/// {@template circle_painter}
/// A [CustomPainter] that draws an expanding **concentric circle stroke**.
///
/// The stroke width is dynamically calculated based on:
/// - [outerCircleRadiusProgress] → controls the circle’s outer radius.
/// - [innerCircleRadiusProgress] → controls the inner radius (used to
///   compute stroke thickness).
///
/// The color is interpolated between [circleColor.start] and [circleColor.end]
/// using linear interpolation, based on the circle expansion progress.
///
/// Typically used in the particle animation behind the child widget.
/// {@endtemplate}
class _CirclePainter extends CustomPainter {
  /// {@macro circle_painter}
  _CirclePainter({
    required this.outerCircleRadiusProgress,
    required this.innerCircleRadiusProgress,
    this.circleColor = const CircleColor(start: Color(0xFFFF5722), end: Color(0xFFFFC107)),
  }) {
    _circlePaint.style = PaintingStyle.stroke;
  }

  /// Paint object used for rendering the circle stroke.
  final Paint _circlePaint = Paint();

  /// Progress of the outer circle’s expansion.
  ///
  /// Value should be between `0.0` and `1.0`.
  final double outerCircleRadiusProgress;

  /// Progress of the inner circle’s expansion.
  ///
  /// Value should be between `0.0` and `1.0`.
  final double innerCircleRadiusProgress;

  /// Color configuration for the circle stroke.
  final CircleColor circleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width * 0.5;
    _updateCircleColor();

    final double strokeWidth = outerCircleRadiusProgress * center - (innerCircleRadiusProgress * center);

    if (strokeWidth > 0.0) {
      _circlePaint.strokeWidth = strokeWidth;
      canvas.drawCircle(Offset(center, center), outerCircleRadiusProgress * center, _circlePaint);
    }
  }

  /// Updates [_circlePaint.color] by interpolating between
  /// [circleColor.start] and [circleColor.end].
  ///
  /// The interpolation starts after 50% of the animation progress
  /// to create a delayed gradient effect.
  void _updateCircleColor() {
    double colorProgress = _clamp(outerCircleRadiusProgress, 0.5, 1.0);
    colorProgress = _mapValueFromRangeToRange(colorProgress, 0.5, 1.0, 0.0, 1.0);
    _circlePaint.color = Color.lerp(circleColor.start, circleColor.end, colorProgress)!;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate.runtimeType != runtimeType) return true;

    return oldDelegate is _CirclePainter &&
        (oldDelegate.outerCircleRadiusProgress != outerCircleRadiusProgress ||
            oldDelegate.innerCircleRadiusProgress != innerCircleRadiusProgress ||
            oldDelegate.circleColor.start != circleColor.start ||
            oldDelegate.circleColor.end != circleColor.end);
  }
}

/// {@template bubbles_painter}
/// A [CustomPainter] that draws **two rings of animated bubbles**
/// (outer ring + inner ring) around the particle animation’s center.
///
/// The animation behavior includes:
/// - **Position animation**: bubbles move outward based on [currentProgress].
/// - **Size animation**: bubble radius grows/shrinks at different phases.
/// - **Color transitions**: bubbles interpolate between multiple colors
///   ([color1], [color2], [color3], [color4]).
/// - **Alpha fading**: bubbles fade out towards the end of the animation.
///
/// This painter is typically used behind the main widget (e.g., a heart icon)
/// to create an explosive bubble effect during a "like" animation.
/// {@endtemplate}
class _BubblesPainter extends CustomPainter {
  /// {@macro bubbles_painter}
  _BubblesPainter({
    required this.currentProgress,
    this.color1 = const Color(0xFFFFC107),
    this.color2 = const Color(0xFFFF9800),
    this.color3 = const Color(0xFFFF5722),
    this.color4 = const Color(0xFFF44336),
  }) {
    _outerBubblesPositionAngle = 360.0 / 7; // 7 bubbles evenly spaced in a circle
    for (int i = 0; i < 4; i++) {
      _circlePaints.add(Paint()..style = PaintingStyle.fill);
    }
  }

  /// The current animation progress between `0.0` and `1.0`.
  final double currentProgress;

  /// Bubble color palette (cycled between 4 colors).
  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;

  /// Angle step between each outer bubble (7 bubbles → ~51.42° apart).
  double _outerBubblesPositionAngle = 51.42;

  /// Center coordinates (updated in [paint]).
  double _centerX = 0.0;
  double _centerY = 0.0;

  /// Paint objects for rendering bubble fills.
  final List<Paint> _circlePaints = <Paint>[];

  /// Maximum radii for inner and outer bubble rings.
  double _maxOuterDotsRadius = 0.0;
  double _maxInnerDotsRadius = 0.0;

  /// Maximum bubble size.
  double? _maxDotSize;

  /// Animated values for bubble rings.
  double _currentRadius1 = 0.0; // outer ring radius
  double? _currentDotSize1 = 0.0; // outer bubble size
  double? _currentDotSize2 = 0.0; // inner bubble size
  double _currentRadius2 = 0.0; // inner ring radius

  @override
  void paint(Canvas canvas, Size size) {
    _centerX = size.width * 0.5;
    _centerY = size.height * 0.5;
    _maxDotSize = size.width * 0.05;
    _maxOuterDotsRadius = size.width * 0.5 - _maxDotSize! * 2;
    _maxInnerDotsRadius = 0.8 * _maxOuterDotsRadius;

    // Update animation states before drawing
    _updateOuterBubblesPosition();
    _updateInnerBubblesPosition();
    _updateBubblesPaints();

    // Draw frames
    _drawOuterBubblesFrame(canvas);
    _drawInnerBubblesFrame(canvas);
  }

  /// Draws the outer ring of bubbles.
  void _drawOuterBubblesFrame(Canvas canvas) {
    final double start = _outerBubblesPositionAngle / 4.0 * 3.0;
    for (int i = 0; i < 7; i++) {
      final double cX = _centerX + _currentRadius1 * math.cos(_degToRad(start + _outerBubblesPositionAngle * i));
      final double cY = _centerY + _currentRadius1 * math.sin(_degToRad(start + _outerBubblesPositionAngle * i));
      canvas.drawCircle(Offset(cX, cY), _currentDotSize1!, _circlePaints[i % _circlePaints.length]);
    }
  }

  /// Draws the inner ring of bubbles (offset from the outer ring).
  void _drawInnerBubblesFrame(Canvas canvas) {
    final double start = _outerBubblesPositionAngle / 4.0 * 3.0 - _outerBubblesPositionAngle / 2.0;
    for (int i = 0; i < 7; i++) {
      final double cX = _centerX + _currentRadius2 * math.cos(_degToRad(start + _outerBubblesPositionAngle * i));
      final double cY = _centerY + _currentRadius2 * math.sin(_degToRad(start + _outerBubblesPositionAngle * i));
      canvas.drawCircle(Offset(cX, cY), _currentDotSize2!, _circlePaints[(i + 1) % _circlePaints.length]);
    }
  }

  /// Updates the radius and size of the **outer bubbles**
  /// based on [currentProgress].
  void _updateOuterBubblesPosition() {
    if (currentProgress < 0.3) {
      _currentRadius1 = _mapValueFromRangeToRange(currentProgress, 0.0, 0.3, 0.0, _maxOuterDotsRadius * 0.8);
    } else {
      _currentRadius1 = _mapValueFromRangeToRange(
        currentProgress,
        0.3,
        1.0,
        0.8 * _maxOuterDotsRadius,
        _maxOuterDotsRadius,
      );
    }

    if (currentProgress == 0) {
      _currentDotSize1 = 0;
    } else if (currentProgress < 0.7) {
      _currentDotSize1 = _maxDotSize;
    } else {
      _currentDotSize1 = _mapValueFromRangeToRange(currentProgress, 0.7, 1.0, _maxDotSize!, 0.0);
    }
  }

  /// Updates the radius and size of the **inner bubbles**
  /// based on [currentProgress].
  void _updateInnerBubblesPosition() {
    if (currentProgress < 0.3) {
      _currentRadius2 = _mapValueFromRangeToRange(currentProgress, 0.0, 0.3, 0.0, _maxInnerDotsRadius);
    } else {
      _currentRadius2 = _maxInnerDotsRadius;
    }

    if (currentProgress == 0) {
      _currentDotSize2 = 0;
    } else if (currentProgress < 0.2) {
      _currentDotSize2 = _maxDotSize;
    } else if (currentProgress < 0.5) {
      _currentDotSize2 = _mapValueFromRangeToRange(currentProgress, 0.2, 0.5, _maxDotSize!, 0.3 * _maxDotSize!);
    } else {
      _currentDotSize2 = _mapValueFromRangeToRange(currentProgress, 0.5, 1.0, _maxDotSize! * 0.3, 0.0);
    }
  }

  /// Updates the bubble colors with smooth interpolation and fading.
  ///
  /// - During the first half of the animation, colors transition from:
  ///   [color1] → [color2], [color2] → [color3], etc.
  /// - During the second half, the transitions continue cyclically.
  /// - Alpha decreases as [currentProgress] approaches `1.0`.
  void _updateBubblesPaints() {
    final double progress = _clamp(currentProgress, 0.6, 1.0);
    final int alpha = _mapValueFromRangeToRange(progress, 0.6, 1.0, 255.0, 0.0).toInt();

    if (currentProgress < 0.5) {
      final double progress = _mapValueFromRangeToRange(currentProgress, 0.0, 0.5, 0.0, 1.0);
      _circlePaints[0].color = Color.lerp(color1, color2, progress)!.withAlpha(alpha);
      _circlePaints[1].color = Color.lerp(color2, color3, progress)!.withAlpha(alpha);
      _circlePaints[2].color = Color.lerp(color3, color4, progress)!.withAlpha(alpha);
      _circlePaints[3].color = Color.lerp(color4, color1, progress)!.withAlpha(alpha);
    } else {
      final double progress = _mapValueFromRangeToRange(currentProgress, 0.5, 1.0, 0.0, 1.0);
      _circlePaints[0].color = Color.lerp(color2, color3, progress)!.withAlpha(alpha);
      _circlePaints[1].color = Color.lerp(color3, color4, progress)!.withAlpha(alpha);
      _circlePaints[2].color = Color.lerp(color4, color1, progress)!.withAlpha(alpha);
      _circlePaints[3].color = Color.lerp(color1, color2, progress)!.withAlpha(alpha);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate.runtimeType != runtimeType) return true;

    return oldDelegate is _BubblesPainter &&
        (oldDelegate.currentProgress != currentProgress ||
            oldDelegate.color1 != color1 ||
            oldDelegate.color2 != color2 ||
            oldDelegate.color3 != color3 ||
            oldDelegate.color4 != color4);
  }
}

/// {@template icon_animation_builder}
/// A widget that applies an animated transition to an icon based on a provided [IconAnimation].
///
/// [_IconAnimationBuilder] handles both simple animations (rotation, zoom, slide)
/// and icon switching with optional transition effects (fade, scale, rotation).
///
/// This widget is typically used to wrap an [Icon] or any widget that needs
/// animated state transitions driven by an [IconAnimation].
///
/// ### Example usage:
/// ```dart
/// _IconAnimationBuilder(
///   animation: IconAnimation.rotate(controller: myController),
///   child: Icon(Icons.refresh),
/// );
/// ```
/// {@endtemplate}
class _IconAnimationBuilder extends StatefulWidget {
  /// {@macro icon_animation_builder}
  const _IconAnimationBuilder({required this.animation, required this.child, required this.size, required this.color});

  /// The animation configuration that defines the type and behavior of the icon animation.
  final IconAnimation animation;

  /// The child widget (usually an [Icon]) to which the animation will be applied.
  final Widget child;

  final double size;

  final Color? color;

  @override
  State<_IconAnimationBuilder> createState() => __IconAnimationBuilderState();
}

class __IconAnimationBuilderState extends State<_IconAnimationBuilder> with SingleTickerProviderStateMixin {
  late final IconController _iconController;

  late final Animation<double> _scaleIn;
  late final Animation<double> _scaleOut;
  late final Animation<Offset> _slideUp;
  late final Animation<Offset> _slideDown;
  late final Animation<double> _fadeOut;

  bool _showForwardIcon = false;

  AnimationController get _controller => widget.animation.controller?._controller ?? _iconController._controller;

  @override
  void initState() {
    super.initState();

    _iconController =
        widget.animation.controller ?? IconController(vsync: this, duration: const Duration(milliseconds: 250));

    _scaleIn = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleOut = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInBack));

    _slideUp = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideDown = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.addStatusListener(_handleAnimationStatus);
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleAnimationStatus);
    _iconController.dispose();
    super.dispose();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (mounted && widget.animation.switchIcon != null) {
        setState(() => _showForwardIcon = true);
      }
    } else if (status == AnimationStatus.dismissed) {
      if (mounted && _showForwardIcon) {
        setState(() => _showForwardIcon = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animation.type == IconAnimationType.none) {
      return widget.child;
    }

    if (widget.animation.type == IconAnimationType.switchTo) {
      final destIcon = widget.animation.switchIcon!.icon.data.adaptive;
      final destColor = widget.animation.switchIcon!.color;
      final destSize = widget.animation.switchIcon!.size;
      final transition = widget.animation.transition;

      return AnimatedSwitcher(
        duration: _controller.duration ?? Duration.zero,
        transitionBuilder: (child, animation) {
          final rotationTween = child.key == const ValueKey('baseIcon')
              ? Tween<double>(begin: transition?.rotate?.end ?? 1, end: transition?.rotate?.begin ?? 1)
              : Tween<double>(begin: transition?.rotate?.begin ?? 1, end: transition?.rotate?.end ?? 1);

          final scaleTween = Tween<double>(begin: transition?.scale?.end ?? 1, end: transition?.scale?.begin ?? 1);

          final rotationAnimation = rotationTween.animate(animation);
          final scaleAnimation = scaleTween.animate(animation);

          return RotationTransition(
            turns: rotationAnimation,
            child: ScaleTransition(scale: scaleAnimation, child: child),
          );
        },
        child: _showForwardIcon
            ? Icon(destIcon, color: destColor, size: destSize, key: const ValueKey('switchIcon'))
            : KeyedSubtree(key: const ValueKey('baseIcon'), child: widget.child),
      );
    }

    switch (widget.animation.type) {
      case IconAnimationType.rotate:
        return RotationTransition(turns: _controller, child: widget.child);

      case IconAnimationType.zoomIn:
        return FadeTransition(
          opacity: _fadeOut,
          child: ScaleTransition(scale: _scaleIn, child: widget.child),
        );

      case IconAnimationType.zoomOut:
        return ScaleTransition(scale: _scaleOut, child: widget.child);

      case IconAnimationType.slideOutUp:
        return FadeTransition(
          opacity: _fadeOut,
          child: SlideTransition(position: _slideUp, child: widget.child),
        );

      case IconAnimationType.slideOutDown:
        return FadeTransition(
          opacity: _fadeOut,
          child: SlideTransition(position: _slideDown, child: widget.child),
        );
      case IconAnimationType.particle:
        final color = widget.color ?? Colors.black;

        return _ParticleAnimation(
          size: widget.size,
          controller: widget.animation.controller!._controller,
          bubblesColor: BubblesColor(dotPrimaryColor: color, dotSecondaryColor: Color.lerp(color, Colors.white, 0.5)!),
          circleColor: CircleColor(start: color, end: Color.lerp(color, Colors.white, 0.8)!),
          child: widget.child,
        );

      default:
        return widget.child;
    }
  }
}
