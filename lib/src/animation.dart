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

/// {@template app_icon_animation}
/// Defines the set of animations that can be applied to an [AppIcon].
///
/// Each value represents a self-contained animation that:
/// - can be triggered explicitly via [AppIconController],
/// - runs as a one-shot animation by default,
/// - optionally supports repetition,
/// - always returns the icon to its initial visual state.
///
/// Animations are intentionally declarative and stateless:
/// the enum only describes *what* animation to play, while
/// [AppIconController] controls *when* and *how* it runs.
/// {@endtemplate}
enum AppIconAnimation {
  /// No animation.
  ///
  /// The icon is rendered statically.
  none,

  /// Scales the icon up and back to its original size.
  ///
  /// Typically used for emphasis or focus.
  zoomIn,

  /// Scales the icon down and back to its original size.
  ///
  /// Useful for de-emphasizing or exit-like feedback.
  zoomOut,

  /// Rotates the icon counter-clockwise and returns to neutral.
  ///
  /// Often used for attention or subtle feedback.
  rotateLeft,

  /// Rotates the icon clockwise and returns to neutral.
  ///
  /// Symmetrical counterpart to [rotateLeft].
  rotateRight,

  /// Shakes the icon horizontally.
  ///
  /// Commonly used to indicate an error or invalid action.
  shakeX,

  /// Shakes the icon vertically.
  ///
  /// Typically used for alerts or attention-grabbing feedback.
  shakeY,

  /// Flips the icon horizontally to the left using a 3D transform.
  ///
  /// Creates a card-flip style effect.
  flipXLeft,

  /// Flips the icon horizontally to the right using a 3D transform.
  ///
  /// Symmetrical counterpart to [flipXLeft].
  flipXRight,

  /// Flips the icon vertically upward using a 3D transform.
  ///
  /// Often used for transitions or reveal effects.
  flipYUp,

  /// Flips the icon vertically downward using a 3D transform.
  ///
  /// Symmetrical counterpart to [flipYUp].
  flipYDown,

  /// Simulates a heartbeat-like pulse using scale animation.
  ///
  /// Ideal for “like”, “favorite”, or emotional feedback.
  heartBeat,

  /// Fades the icon in from transparent to visible.
  ///
  /// Typically used for entry or appearance animations.
  fadeIn,

  /// Fades the icon out and returns it to full opacity.
  ///
  /// Useful for dismissal or exit-like feedback.
  fadeOut,

  /// Displays a particle burst animation around the icon.
  ///
  /// Commonly used for reactions such as “like” or “success”.
  particle,

  /// Performs a subtle scale pulse.
  ///
  /// A lightweight alternative to [heartBeat] for general feedback.
  pulse,

  /// Plays a celebratory animation combining scale and rotation.
  ///
  /// Ideal for success states or achievements.
  tada,

  /// Swings the icon from the top, like a hanging pendulum.
  ///
  /// Often used for notifications or playful feedback.
  swingUp,

  /// Swings the icon from the bottom, inverted pendulum style.
  ///
  /// Counterpart to [swingUp].
  swingDown,

  /// Performs a short, punchy scale animation.
  ///
  /// Designed for click or tap feedback with strong visual impact.
  pop,
}
