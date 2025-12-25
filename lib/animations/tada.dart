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

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Tada extends AnimatedWidget {
  final Widget child;

  static final Animatable<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: ConstantTween(1.0), weight: 10),
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 20),
    TweenSequenceItem(tween: Tween(begin: 1.1, end: 0.95).chain(CurveTween(curve: Curves.easeInOut)), weight: 20),
    TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.05).chain(CurveTween(curve: Curves.easeInOut)), weight: 20),
    TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0).chain(CurveTween(curve: Curves.easeInCubic)), weight: 30),
  ]);

  static final Animatable<double> _rotation = TweenSequence<double>([
    TweenSequenceItem(tween: ConstantTween(0.0), weight: 10),
    TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.04).chain(CurveTween(curve: Curves.easeOut)), weight: 10),
    TweenSequenceItem(tween: Tween(begin: -0.04, end: 0.04).chain(CurveTween(curve: Curves.easeInOut)), weight: 20),
    TweenSequenceItem(tween: Tween(begin: 0.04, end: -0.04).chain(CurveTween(curve: Curves.easeInOut)), weight: 20),
    TweenSequenceItem(tween: Tween(begin: -0.04, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 40),
  ]);

  const Tada({super.key, required Animation<double> animation, required this.child}) : super(listenable: animation);

  Animation<double> get _animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final scale = _scale.evaluate(_animation);
    final rotation = _rotation.evaluate(_animation);

    return Transform.rotate(
      angle: rotation,
      child: Transform.scale(scale: scale, child: child),
    );
  }
}
