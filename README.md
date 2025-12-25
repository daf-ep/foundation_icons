<p align="center">
  <img src="https://fiberstudio.app/assets/images/fiber.png" alt="Fiber Logo" width="160" />
</p>

# fiber_foundation_icons

`fiber_firebase_annotation` is a Flutter widget for displaying adaptive icons (Material / Cupertino) with a fully controlled animation system designed for clarity, consistency, and extensibility.

The package provides:

- the AppIcon widget
- the AppIconController
- a curated set of reusable icon animations (pop, pulse, tada, particle, etc.)

## Features

- Adaptive icons (Material & Cupertino)
- Explicit, controller-driven animations
- One-shot or repeatable animations
- Animated icon transitions
- Clean, type-safe API
- Designed for design systems and production apps

## Installation

```yaml
dependencies:
  fiber_foundation_icons: ^1.0.1
```

## Basic Usage

```dart
AppIcon(
  icon: AppIconData.add,
  size: 30,
  color: Colors.black,
)
```

Without a controller, the icon is displayed statically.

## Using Animations

To animate an icon, create an `AppIconController`:

```dart
final AppIconController controller = AppIconController(
  duration: const Duration(milliseconds: 600),
  curve: Curves.easeOut,
);
```

Then attach it to the widget:

```dart
AppIcon(
  icon: AppIconData.zoom_in,
  size: 30,
  color: Colors.black,
  controller: controller,
)
```

## Playing an Animation

```dart
controller.play(AppIconAnimation.pop);
```

This triggers a one-shot animation that automatically returns to the initial state.

## Animation with Icon Transition

You can change the icon after the animation completes:

```dart
controller.playWithIconTransition(
  AppIconAnimation.particle,
  to: AppIconData.heart_fill,
  color: Colors.red,
);
```

This is ideal for:
- like buttons
- favorites
- visual confirmations

## Full Example

```dart
class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final AppIconController controller1 = AppIconController(
    duration: Duration(milliseconds: 2000),
    curve: Curves.bounceInOut,
  );

  final AppIconController controller2 = AppIconController(
    duration: Duration(milliseconds: 2000),
    curve: Curves.bounceInOut,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppIcon(icon: AppIconData.add, size: 30),
        const SizedBox(height: 40),

        AppIcon(
          icon: AppIconData.zoom_in,
          size: 30,
          controller: controller1,
        ),

        const SizedBox(height: 40),

        AppIcon(
          icon: AppIconData.heart,
          size: 30,
          controller: controller2,
        ),

        const SizedBox(height: 80),

        MaterialButton(
          onPressed: () => controller1.play(AppIconAnimation.pop),
          child: const Text('Animation 1'),
        ),

        const SizedBox(height: 20),

        MaterialButton(
          onPressed: () => controller2.playWithIconTransition(
            AppIconAnimation.particle,
            to: AppIconData.heart_fill,
            color: Colors.red,
          ),
          child: const Text('Animation 2'),
        ),
      ],
    );
  }
}
```

## Available Animations

```dart
  enum AppIconAnimation{
    none,
    pulse,
    pop,
    heartBeat,
    tada,
    wobble,
    swing,
    zoomIn,
    zoomOut,
    fadeIn,
    fadeOut,
    shakeX,
    shakeY,
    rotateLeft,
    rotateRight,
    flipXLeft,
    flipXRight,
    flipYUp,
    flipYDown,
    particle,
  }
```

All animations:
- are self-contained
- return to their initial visual state
- can be repeated using the controller