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

import '../animations/fade/fade_in.dart';
import '../animations/fade/fade_out.dart';
import '../animations/flip/flip_x_left.dart';
import '../animations/flip/flip_x_right.dart';
import '../animations/flip/flip_y_down.dart';
import '../animations/flip/flip_y_up.dart';
import '../animations/heart_beat.dart';
import '../animations/particle.dart';
import '../animations/pop.dart';
import '../animations/pulse.dart';
import '../animations/rotate/rotate_left.dart';
import '../animations/rotate/rotate_right.dart';
import '../animations/skake/shake_x.dart';
import '../animations/skake/shake_y.dart';
import '../animations/swing/swing_down.dart';
import '../animations/swing/swing_up.dart';
import '../animations/tada.dart';
import '../animations/zoom/zoom_in.dart';
import '../animations/zoom/zoom_out.dart';
import '../src/animation.dart';

extension AppIconAnimationExtension on AppIconAnimation {
  Widget apply({required Animation<double> animation, required Widget child, double? size, Color? color}) {
    return switch (this) {
      AppIconAnimation.none => child,
      AppIconAnimation.zoomIn => ZoomIn(animation: animation, child: child),
      AppIconAnimation.zoomOut => ZoomOut(animation: animation, child: child),
      AppIconAnimation.rotateLeft => RotateLeft(animation: animation, child: child),
      AppIconAnimation.rotateRight => RotateRight(animation: animation, child: child),
      AppIconAnimation.shakeX => ShakeX(animation: animation, child: child),
      AppIconAnimation.shakeY => ShakeY(animation: animation, child: child),
      AppIconAnimation.flipXLeft => FlipXLeft(animation: animation, child: child),
      AppIconAnimation.flipXRight => FlipXRight(animation: animation, child: child),
      AppIconAnimation.flipYUp => FlipYUp(animation: animation, child: child),
      AppIconAnimation.flipYDown => FlipYDown(animation: animation, child: child),
      AppIconAnimation.heartBeat => HeartBeat(animation: animation, child: child),
      AppIconAnimation.fadeIn => FadeIn(animation: animation, child: child),
      AppIconAnimation.fadeOut => FadeOut(animation: animation, child: child),
      AppIconAnimation.particle => _buildParticle(animation: animation, child: child, size: size, color: color),
      AppIconAnimation.pulse => Pulse(animation: animation, child: child),
      AppIconAnimation.tada => Tada(animation: animation, child: child),
      AppIconAnimation.swingUp => SwingUp(animation: animation, child: child),
      AppIconAnimation.swingDown => SwingDown(animation: animation, child: child),
      AppIconAnimation.pop => Pop(animation: animation, child: child),
    };
  }

  Widget _buildParticle({required Animation<double> animation, required Widget child, double? size, Color? color}) {
    assert(size != null && color != null, 'Particle animation requires size and color');

    return Particle(animation: animation, size: size!, color: color!, child: child);
  }
}
