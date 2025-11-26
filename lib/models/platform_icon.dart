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

/// {@template platform_icon}
/// A platform-adaptive icon definition that provides both Material and Cupertino icons.
///
/// [PlatformIcon] allows building cross-platform UIs by specifying
/// two platform-specific [IconData] objects:
/// - One for Material (Android/web/desktop)
/// - One for Cupertino (iOS/macOS)
///
/// Consumers can use this model to build adaptive widgets that render
/// the appropriate icon based on the target platform.
///
/// ### Example:
/// ```dart
/// final settingsIcon = PlatformIcon(
///   material: Icons.settings,
///   cupertino: CupertinoIcons.settings,
/// );
///
/// Icon(Platform.isIOS ? settingsIcon.cupertino : settingsIcon.material);
/// ```
/// {@endtemplate}
class PlatformIcon extends Equatable {
  /// {@macro platform_icon}
  ///
  /// Creates a [PlatformIcon] instance by specifying both [cupertino] and [material] icons.
  ///
  /// Both values must be provided to ensure proper behavior on all platforms.
  const PlatformIcon({required this.cupertino, required this.material});

  /// The [IconData] to use on Cupertino (iOS/macOS) platforms.
  final IconData cupertino;

  /// The [IconData] to use on Material Design (Android/web/desktop) platforms.
  final IconData material;

  @override
  List<Object> get props => [cupertino, material];
}
