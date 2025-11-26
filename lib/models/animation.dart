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

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../enums/icon_data.dart';
import '../icons.dart';

/// {@template icon_animation_type}
/// Defines the different animation types that can be applied to icons,
/// providing visual feedback or interactive transitions when an icon changes state.
///
/// These animation types are used by [IconAnimation] to configure the visual behavior
/// of icons when they transition between different states or symbols.
///
/// ### Available types:
/// - [IconAnimationType.none] → No animation.
/// - [IconAnimationType.switchTo] → Direct icon switch, optionally with a visual transition.
/// - [IconAnimationType.rotate] → Rotational animation.
/// - [IconAnimationType.slideOutUp] → Slide upwards and disappear.
/// - [IconAnimationType.slideOutDown] → Slide downwards and disappear.
/// - [IconAnimationType.zoomIn] → Zoom in effect.
/// - [IconAnimationType.zoomOut] → Zoom out effect.
/// {@endtemplate}
enum IconAnimationType {
  /// {@macro icon_animation_type}
  /// No animation is applied. The icon changes instantly without any visual transition.
  none,

  /// {@macro icon_animation_type}
  /// Switches from one icon to another, optionally with a transition effect
  /// such as fade, scale, or rotation.
  ///
  /// This is typically used to visually change the icon itself rather than animate it.
  switchTo,

  /// {@macro icon_animation_type}
  /// Rotates the icon around its center axis.
  rotate,

  /// {@macro icon_animation_type}
  /// Slides the icon upwards out of view.
  slideOutUp,

  /// {@macro icon_animation_type}
  /// Slides the icon downwards out of view.
  slideOutDown,

  /// {@macro icon_animation_type}
  /// Applies a zoom-in effect, enlarging the icon.
  zoomIn,

  /// {@macro icon_animation_type}
  /// Applies a zoom-out effect, shrinking the icon.
  zoomOut,

  particle,
}

/// {@template switch_to_icon}
/// Defines an icon along with optional styling (color and size) to be used
/// when switching to a new icon after an animation completes.
///
/// This class is typically used in conjunction with [IconAnimation]
/// to provide a visual transition to a new icon appearance.
///
/// ### Example usage:
/// ```dart
/// final switchIcon = SwitchIcon(
///   icon: AppIconData.checkmark,
///   color: Colors.green,
///   size: 24,
/// );
/// ```
/// {@endtemplate}
class SwitchIcon {
  /// {@macro switch_to_icon}
  const SwitchIcon({required this.icon, this.color, this.size});

  /// The target icon to display after the animation finishes.
  final AppIconData icon;

  /// The optional color to apply to the target icon.
  final Color? color;

  /// The optional size to apply to the target icon.
  final double? size;
}

/// {@template switch_icon_transition}
/// Defines optional visual transition effects to apply when switching icons
/// using [IconAnimation.switchTo].
///
/// [SwitchIconTransition] allows you to specify:
/// - A rotation animation via [rotate] (as a [Tween] of angles in radians).
/// - A scaling animation via [scale] (as a [Tween] of scale factors).
///
/// These transitions control how the old icon visually morphs into the new one.
///
/// ### Example usage:
/// ```dart
/// final transition = SwitchIconTransition(
///   rotate: Tween<double>(begin: 0.0, end: pi),
///   scale: Tween<double>(begin: 1.0, end: 1.5),
/// );
///
/// final animation = IconAnimation.switchTo(
///   controller: myIconController,
///   icon: SwitchIcon(icon: AppIconData.checkmark),
///   transition: transition,
/// );
/// ```
/// {@endtemplate}
class SwitchIconTransition {
  /// {@macro switch_icon_transition}
  const SwitchIconTransition({this.rotate, this.scale});

  /// An optional rotation animation to apply during the icon switch.
  ///
  /// The [Tween] should define the range of rotation in radians (e.g., `0.0` to `pi` for a 180° flip).
  final Tween<double>? rotate;

  /// An optional scaling animation to apply during the icon switch.
  ///
  /// The [Tween] defines the scale factor (e.g., from `1.0` to `1.5` for a 50% zoom effect).
  final Tween<double>? scale;
}

/// {@template icon_animation_class}
/// A configuration object that defines how an icon should animate when its state changes.
///
/// [IconAnimation] encapsulates:
/// - The animation type ([type]) to apply.
/// - An optional target icon to switch to after the animation ([switchIcon]).
/// - An optional animation transition between icons ([transition]).
/// - An optional [IconController] to trigger and control the animation programmatically.
///
/// This class is typically used with widgets like [AppIcon] to create interactive, animated icons
/// that visually transition between different states.
///
/// ### Example usage:
/// ```dart
/// AppIcon(
///   icon: AppIconData.add,
///   animation: IconAnimation.rotate(
///     controller: myIconController,
///   ),
/// );
///
/// AppIcon(
///   icon: AppIconData.add,
///   animation: IconAnimation.switchTo(
///     controller: myIconController,
///     icon: SwitchIcon(icon: AppIconData.checkmark),
///     transition: SwitchIconTransition.fade,
///   ),
/// );
/// ```
/// {@endtemplate}
class IconAnimation extends Equatable {
  /// {@macro icon_animation_class}
  const IconAnimation._({required this.controller, required this.type, this.switchIcon, this.transition});

  /// Controls the animation externally (start, reverse, ping-pong).
  final IconController? controller;

  /// The type of animation to apply (rotation, zoom, slide, etc.).
  final IconAnimationType type;

  /// The optional target icon to display after the animation completes.
  final SwitchIcon? switchIcon;

  /// The optional visual transition to use when switching icons.
  final SwitchIconTransition? transition;

  /// {@template icon_animation_factory}
  /// Creates an [IconAnimation] configured with a specific animation type and
  /// optional icon replacement after the animation completes.
  ///
  /// Most animations require:
  /// - A non-null [IconController] to trigger and manage the animation.
  /// - An optional [switchIcon] to visually change to a new icon after the animation.
  /// {@endtemplate}

  /// {@macro icon_animation_factory}
  ///
  /// No animation is applied. The icon switches immediately without any visual effect.
  factory IconAnimation.none() => IconAnimation._(controller: null, type: IconAnimationType.none, switchIcon: null);

  /// {@macro icon_animation_factory}
  ///
  /// Switches to a new icon with an optional transition effect.
  ///
  /// This is used when you want to visually replace one icon with another
  /// without applying a transform (e.g., fade, scale, cross-fade).
  ///
  /// The [icon] parameter defines the target icon to switch to.
  /// The [transition] parameter specifies the transition effect (optional).
  factory IconAnimation.switchTo({
    required IconController controller,
    required SwitchIcon icon,
    SwitchIconTransition? transition,
  }) => IconAnimation._(
    controller: controller,
    type: IconAnimationType.switchTo,
    switchIcon: icon,
    transition: transition,
  );

  /// {@macro icon_animation_factory}
  ///
  /// Rotates the icon around its center axis.
  ///
  /// Typically used for refresh, reload, or "processing" indicators.
  factory IconAnimation.rotate({required IconController controller}) =>
      IconAnimation._(controller: controller, type: IconAnimationType.rotate, switchIcon: null);

  /// {@macro icon_animation_factory}
  ///
  /// Slides the icon upwards out of view.
  ///
  /// Commonly used to visually dismiss or hide the icon.
  factory IconAnimation.slideOutUp({required IconController controller}) =>
      IconAnimation._(controller: controller, type: IconAnimationType.slideOutUp, switchIcon: null);

  /// {@macro icon_animation_factory}
  ///
  /// Slides the icon downwards out of view.
  ///
  /// Useful for visual transitions where an icon is "closing" or "dropping".
  factory IconAnimation.slideOutDown({required IconController controller}) =>
      IconAnimation._(controller: controller, type: IconAnimationType.slideOutDown, switchIcon: null);

  /// {@macro icon_animation_factory}
  ///
  /// Applies a zoom-in effect, scaling the icon up.
  ///
  /// Useful to emphasize an icon appearing or becoming active.
  factory IconAnimation.zoomIn({required IconController controller}) =>
      IconAnimation._(controller: controller, type: IconAnimationType.zoomIn, switchIcon: null);

  /// {@macro icon_animation_factory}
  ///
  /// Applies a zoom-out effect, scaling the icon down.
  ///
  /// Typically used when removing or deactivating an icon.
  factory IconAnimation.zoomOut({required IconController controller}) =>
      IconAnimation._(controller: controller, type: IconAnimationType.zoomOut, switchIcon: null);

  factory IconAnimation.particle({required IconController controller}) =>
      IconAnimation._(controller: controller, type: IconAnimationType.particle, switchIcon: null);

  @override
  String toString() => 'IconAnimation(type: $type)';

  @override
  List<Object> get props => [type];
}
