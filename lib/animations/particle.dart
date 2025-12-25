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

import 'dart:math' as math;

import 'package:flutter/material.dart';

class Particle extends StatefulWidget {
  final Widget child;
  final double size;
  final Color color;
  final Animation<double> animation;

  const Particle({super.key, required this.animation, required this.child, required this.size, required this.color});

  @override
  State<Particle> createState() => _ParticleState();
}

class _ParticleState extends State<Particle> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _listener = () => _controller.value = widget.animation.value;
    widget.animation.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant Particle oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animation != widget.animation) {
      oldWidget.animation.removeListener(_listener);
      widget.animation.addListener(_listener);
    }
  }

  @override
  void dispose() {
    widget.animation.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ParticleAnimation(
      size: widget.size,
      controller: _controller,
      bubblesColor: BubblesColor(
        dotPrimaryColor: widget.color,
        dotSecondaryColor: Color.lerp(widget.color, Colors.white, 0.5)!,
      ),
      circleColor: CircleColor(start: widget.color, end: Color.lerp(widget.color, Colors.white, 0.8)!),
      child: widget.child,
    );
  }
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

num _degToRad(num deg) => deg * (math.pi / 180.0);

double _mapValueFromRangeToRange(double value, double fromLow, double fromHigh, double toLow, double toHigh) =>
    toLow + ((value - fromLow) / (fromHigh - fromLow) * (toHigh - toLow));

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
    _outerBubblesPositionAngle = 360.0 / 7;
    for (int i = 0; i < 4; i++) {
      _circlePaints.add(Paint()..style = PaintingStyle.fill);
    }
  }

  final double currentProgress;
  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;

  double _outerBubblesPositionAngle = 51.42;

  double _centerX = 0.0;
  double _centerY = 0.0;

  final List<Paint> _circlePaints = <Paint>[];

  double _maxOuterDotsRadius = 0.0;
  double _maxInnerDotsRadius = 0.0;
  double? _maxDotSize;
  double _currentRadius1 = 0.0;
  double? _currentDotSize1 = 0.0;
  double? _currentDotSize2 = 0.0;
  double _currentRadius2 = 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    _centerX = size.width * 0.5;
    _centerY = size.height * 0.5;
    _maxDotSize = size.width * 0.05;
    _maxOuterDotsRadius = size.width * 0.5 - _maxDotSize! * 2;
    _maxInnerDotsRadius = 0.8 * _maxOuterDotsRadius;

    _updateOuterBubblesPosition();
    _updateInnerBubblesPosition();
    _updateBubblesPaints();
    _drawOuterBubblesFrame(canvas);
    _drawInnerBubblesFrame(canvas);
  }

  void _drawOuterBubblesFrame(Canvas canvas) {
    final double start = _outerBubblesPositionAngle / 4.0 * 3.0;
    for (int i = 0; i < 7; i++) {
      final double cX = _centerX + _currentRadius1 * math.cos(_degToRad(start + _outerBubblesPositionAngle * i));
      final double cY = _centerY + _currentRadius1 * math.sin(_degToRad(start + _outerBubblesPositionAngle * i));
      canvas.drawCircle(Offset(cX, cY), _currentDotSize1!, _circlePaints[i % _circlePaints.length]);
    }
  }

  void _drawInnerBubblesFrame(Canvas canvas) {
    final double start = _outerBubblesPositionAngle / 4.0 * 3.0 - _outerBubblesPositionAngle / 2.0;
    for (int i = 0; i < 7; i++) {
      final double cX = _centerX + _currentRadius2 * math.cos(_degToRad(start + _outerBubblesPositionAngle * i));
      final double cY = _centerY + _currentRadius2 * math.sin(_degToRad(start + _outerBubblesPositionAngle * i));
      canvas.drawCircle(Offset(cX, cY), _currentDotSize2!, _circlePaints[(i + 1) % _circlePaints.length]);
    }
  }

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
