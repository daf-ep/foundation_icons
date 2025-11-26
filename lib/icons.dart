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

// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'enums/icon_data.dart';
import 'extensions/platform_icon.dart';
import 'models/animation.dart';
import 'models/platform_icon.dart';
import 'models/platform_scale.dart';

part './extensions/icons.dart';
part 'animation.dart';

/// {@template app_icon}
/// A customizable and adaptive icon widget that automatically selects
/// the appropriate platform icon and optionally applies an animation.
///
/// [AppIcon] simplifies the use of platform-specific icons (Material or Cupertino)
/// while providing a consistent API for:
/// - Icon size
/// - Icon color
/// - Optional icon animations via [IconAnimation]
///
/// ### Example:
/// ```dart
/// AppIcon(
///   icon: AppIconData.settings,
///   size: 24,
///   color: Colors.blue,
///   animation: IconAnimation.slideOutUp(),
/// )
/// ```
/// {@endtemplate}
class AppIcon extends StatelessWidget {
  /// {@macro app_icon}
  const AppIcon({super.key, required this.icon, this.size, this.color, this.animation, this.scaleToFit = true});

  /// The platform-adaptive icon to display.
  ///
  /// See: [AppIconData] for predefined icons that adapt to Material or Cupertino.
  final AppIconData icon;

  /// The size of the icon in logical pixels.
  ///
  /// If null, defaults to the icon theme size.
  final double? size;

  /// The color to apply to the icon.
  ///
  /// If null, inherits the current [IconTheme] color.
  final Color? color;

  /// An optional [IconAnimation] to apply to the icon.
  ///
  /// If `null` or if [IconAnimationType.none] is used, the icon will appear static.
  final IconAnimation? animation;

  /// Whether to apply the platform-specific visual scale
  /// (e.g., to make Cupertino icons better fit their visual bounds).
  ///
  /// If false, no additional scaling is applied (scale = 1).
  final bool scaleToFit;

  @override
  Widget build(BuildContext context) {
    final s = size ?? 15;

    final iconWidget = Transform.scale(
      scale: scaleToFit ? (Platform.isAndroid ? icon._scale.material : icon._scale.cupertino) : 1,
      child: Icon(icon.data.cupertino, size: s, color: color),
    );

    if (animation == null) {
      return iconWidget;
    }

    return _IconAnimationBuilder(animation: animation!, size: s, color: color, child: iconWidget);
  }
}
