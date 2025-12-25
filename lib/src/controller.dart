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

part of './icon.dart';

const Duration kDefaultDuration = Duration(milliseconds: 250);
const Duration kDefaultReverseDuration = Duration.zero;
const Curve kDefaultCurve = Curves.linear;

/// {@template app_icon_controller}
/// Controls animations applied to an [AppIcon].
///
/// [AppIconController] provides an explicit, imperative API to:
/// - trigger icon animations,
/// - repeat animations,
/// - optionally transition to another icon once an animation completes.
///
/// The controller itself does not render anything. It is attached
/// internally by [AppIcon] and drives an underlying [AnimationController].
///
/// This design ensures:
/// - predictable animation behavior,
/// - no implicit or automatic animations,
/// - full control from the calling code.
/// {@endtemplate}
class AppIconController extends ChangeNotifier {
  /// Duration of the forward animation.
  ///
  /// This value defines how long a single animation cycle takes
  /// when played normally via [play] or [playWithIconTransition].
  final Duration duration;

  /// Optional duration used when the animation runs in reverse.
  ///
  /// This is mainly useful for advanced or repeated animations.
  final Duration reverseDuration;

  /// Curve applied to the underlying animation.
  ///
  /// This curve affects how the animation progresses over time
  /// (e.g. ease-in, ease-out, bounce, etc.).
  final Curve curve;

  /// Internal [AnimationController] attached by [AppIcon].
  ///
  /// This controller is not exposed publicly and should never be
  /// accessed directly outside of the widget.
  AnimationController? _controller;

  /// The currently active icon animation.
  ///
  /// This value is observed by [AppIcon] to rebuild the widget
  /// with the correct animation.
  AppIconAnimation? _animation;

  /// Whether the current animation should repeat indefinitely.
  bool _repeat = false;

  /// Callback used internally to request an icon transition.
  ///
  /// This is set by [AppIcon] when the controller is attached
  /// and allows the controller to notify the widget when the
  /// displayed icon should change.
  void Function(AppIconData to, {Color? color})? _onIconTransition;

  /// Creates a controller used to drive [AppIcon] animations.
  ///
  /// All parameters are optional and have sensible defaults.
  AppIconController({
    this.duration = kDefaultDuration,
    this.reverseDuration = kDefaultReverseDuration,
    this.curve = kDefaultCurve,
  });

  /// Attaches the internal [AnimationController] used by [AppIcon].
  ///
  /// This method is called internally by [AppIcon] during its
  /// initialization phase and should not be invoked manually.
  void _attach(
    AnimationController controller, {
    required void Function(AppIconData to, {Color? color}) onIconTransition,
  }) {
    _controller = controller;
    _onIconTransition = onIconTransition;
  }

  /// The currently selected animation.
  ///
  /// Returns `null` if no animation is active.
  AppIconAnimation? get animation => _animation;

  /// Plays the given [animation].
  ///
  /// If [repeat] is set to `true`, the animation will loop indefinitely
  /// until [stop] is called.
  ///
  /// Calling this method automatically resets the animation before
  /// starting it.
  void play(AppIconAnimation animation, {bool repeat = false}) {
    final controller = _controller;
    if (controller == null) return;

    _animation = animation;
    _repeat = repeat;
    notifyListeners();

    controller
      ..reset()
      ..forward();

    if (_repeat) {
      controller.repeat();
    }
  }

  /// Plays the given [animation] and transitions to another icon.
  ///
  /// The icon transition is applied immediately after the animation
  /// completes (or immediately if [repeat] is enabled).
  ///
  /// This method is typically used for effects such as:
  /// - "like" buttons,
  /// - favorite toggles,
  /// - confirmation animations.
  void playWithIconTransition(
    AppIconAnimation animation, {
    required AppIconData to,
    Color? color,
    bool repeat = false,
  }) {
    final controller = _controller;
    if (controller == null) return;

    _animation = animation;
    _repeat = repeat;
    notifyListeners();

    controller
      ..reset()
      ..forward();

    if (_repeat) {
      controller.repeat();
      return;
    }

    _onIconTransition?.call(to, color: color);
  }

  /// Stops the currently running animation.
  ///
  /// This does not reset the animation state.
  void stop() => _controller?.stop();

  @override
  void dispose() {
    _controller = null;
    _onIconTransition = null;
    super.dispose();
  }
}
