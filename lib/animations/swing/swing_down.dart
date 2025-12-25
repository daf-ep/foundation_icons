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

class SwingDown extends AnimatedWidget {
  final Widget child;

  static final Animatable<double> _rotation = TweenSequence<double>([
    TweenSequenceItem(tween: ConstantTween(0.0), weight: 10),
    TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.28).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 20),
    TweenSequenceItem(tween: Tween(begin: -0.28, end: 0.25).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 25),
    TweenSequenceItem(tween: Tween(begin: 0.25, end: -0.12).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 20),
    TweenSequenceItem(tween: Tween(begin: -0.12, end: 0.0).chain(CurveTween(curve: Curves.easeOutSine)), weight: 25),
  ]);

  const SwingDown({super.key, required Animation<double> animation, required this.child})
    : super(listenable: animation);

  Animation<double> get _animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final rotation = _rotation.evaluate(_animation);

    return Transform.rotate(alignment: Alignment.bottomCenter, angle: rotation, child: child);
  }
}
