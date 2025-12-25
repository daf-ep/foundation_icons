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

import 'package:flutter/material.dart';

import '../extensions/icon_animation.dart';
import '../extensions/platform_icon.dart';
import '../extensions/platform_scale.dart';
import 'animation.dart';
import 'icon_data.dart';

part './controller.dart';

/// {@template app_icon}
/// A platform-adaptive icon widget with optional, explicit animations.
///
/// [AppIcon] automatically resolves the correct icon implementation
/// (Material or Cupertino) based on the current platform, while exposing
/// a simple and consistent API for:
///
/// - Icon data ([AppIconData])
/// - Icon size
/// - Icon color
/// - Explicit, controller-driven animations via [AppIconController]
///
/// Animations are not automatic: they must be triggered manually
/// through the provided controller, ensuring predictable and
/// intentional behavior.
///
/// ### Example
/// ```dart
/// final controller = AppIconController();
///
/// AppIcon(
///   icon: AppIconData.settings,
///   size: 24,
///   color: Colors.blue,
///   controller: controller,
/// )
///
/// controller.play(AppIconAnimation.pop);
/// ```
/// {@endtemplate}
class AppIcon extends StatefulWidget {
  /// {@macro app_icon}
  const AppIcon({super.key, required this.icon, this.size, this.color, this.controller, this.scaleToFit = true});

  /// The platform-adaptive icon to display.
  ///
  /// The icon automatically switches between Material and Cupertino
  /// implementations depending on the current platform.
  ///
  /// See also:
  /// - [AppIconData] for the full list of supported icons.
  final AppIconData icon;

  /// The size of the icon in logical pixels.
  ///
  /// If null, the icon inherits the size from the surrounding
  /// [IconTheme].
  final double? size;

  /// The color used to render the icon.
  ///
  /// If null, the color is inherited from the current [IconTheme].
  final Color? color;

  /// Whether the icon should be scaled to visually match platform
  /// icon proportions.
  ///
  /// When enabled (default), this ensures consistent perceived size
  /// between Material and Cupertino icons.
  final bool scaleToFit;

  /// Optional controller used to trigger and control icon animations.
  ///
  /// When provided, animations can be started explicitly via
  /// [AppIconController.play] or
  /// [AppIconController.playWithIconTransition].
  ///
  /// If null, the icon is rendered statically.
  final AppIconController? controller;

  @override
  State<AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  late AppIconData _icon;
  late Color? _color;

  @override
  void initState() {
    super.initState();

    _icon = widget.icon;
    _color = widget.color;

    final c = widget.controller;
    if (c == null) return;

    _controller = AnimationController(vsync: this, duration: c.duration, reverseDuration: c.reverseDuration);
    _animation = CurvedAnimation(parent: _controller!, curve: c.curve);

    c._attach(
      _controller!,
      onIconTransition: (to, {color}) {
        if (!mounted) return;
        setState(() {
          _icon = to;
          _color = color;
        });
      },
    );
    c.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    widget.controller?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() {});
  }

  Widget _buildIcon(AppIconData icon) {
    return Transform.scale(
      scale: widget.scaleToFit ? icon.scale.adaptive : 1,
      child: Icon(icon.data.adaptive, size: widget.size ?? 15, color: _color, key: ValueKey(icon)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final animation = _animation;
    final controllerAnimation = widget.controller?.animation;

    final content = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: Tween(begin: 0.85, end: 1.0).animate(animation), child: child),
        );
      },
      child: _buildIcon(_icon),
    );

    if (controller == null || animation == null || controllerAnimation == null) return content;

    return AnimatedBuilder(
      animation: animation,
      child: content,
      builder: (_, child) {
        return controllerAnimation.apply(
          animation: animation,
          child: child!,
          size: widget.size,
          color: _color ?? Colors.black,
        );
      },
    );
  }
}
