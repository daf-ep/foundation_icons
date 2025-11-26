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

/// {@template platform_scale}
/// Defines a platform-specific scale factor for sizing UI elements (e.g. icons).
///
/// [PlatformScale] helps normalize visual size differences between
/// Material and Cupertino icons, which often have different default sizing
/// and visual weight.
///
/// This allows you to render icons at consistent perceived sizes across platforms.
///
/// ### Example
/// ```dart
/// final scale = PlatformScale(cupertino: 1.2, material: 1.0);
///
/// final icon = Icon(
///   platformIcon.material,
///   size: baseSize * (Platform.isIOS ? scale.cupertino : scale.material),
/// );
/// ```
/// {@endtemplate}
class PlatformScale {
  /// {@macro platform_scale}
  const PlatformScale({required this.cupertino, required this.material});

  /// Scale factor applied on Cupertino platforms (iOS/macOS).
  final double cupertino;

  /// Scale factor applied on Material platforms (Android/web/desktop).
  final double material;
}
