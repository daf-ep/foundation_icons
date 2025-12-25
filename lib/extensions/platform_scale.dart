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

import 'package:flutter/foundation.dart';

import '../src/icon_data.dart';

/// Extension that resolves the appropriate scale factor based on the current platform.
///
/// This allows using a [PlatformScale] instance directly without manually branching
/// on `TargetPlatform`, making the API more ergonomic in adaptive widgets.
///
/// ### Example
/// ```dart
/// final scale = PlatformScale(cupertino: 1.2, material: 1.0);
/// final iconSize = 24.0 * scale.adaptive;
/// ```
extension PlatformScaleExtension on PlatformScale {
  /// Returns the platform-adapted scale factor for the current device.
  ///
  /// Resolves to [cupertino] on iOS/macOS, [material] otherwise.
  double get adaptive => switch (defaultTargetPlatform) {
    TargetPlatform.iOS || TargetPlatform.macOS => cupertino,
    TargetPlatform.android || TargetPlatform.windows || TargetPlatform.fuchsia || TargetPlatform.linux => material,
  };
}
