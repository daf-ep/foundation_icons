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

import 'package:fiber_foundation_icons/foundation_icons.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const _Main());
}

class _Main extends StatefulWidget {
  const _Main();

  @override
  State<_Main> createState() => _MainState();
}

class _MainState extends State<_Main> {
  final AppIconController _controller1 = AppIconController(
    duration: Duration(milliseconds: 2000),
    curve: Curves.bounceInOut,
  );

  final AppIconController _controller2 = AppIconController(
    duration: Duration(milliseconds: 2000),
    curve: Curves.bounceInOut,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppIcon(icon: AppIconData.add, color: Colors.black, size: 30),
              SizedBox(height: 50),
              AppIcon(icon: AppIconData.zoom_in, color: Colors.black, size: 30, controller: _controller1),
              SizedBox(height: 50),
              AppIcon(icon: AppIconData.heart, color: Colors.black, size: 30, controller: _controller2),
              SizedBox(height: 100),
              MaterialButton(onPressed: _onPressedForAnimation1, child: Text("Animation 1")),
              SizedBox(height: 40),
              MaterialButton(onPressed: _onPressedForAnimation2, child: Text("Animation 2")),
            ],
          ),
        ),
      ),
    );
  }

  void _onPressedForAnimation1() => _controller1.play(AppIconAnimation.pop, repeat: false);

  void _onPressedForAnimation2() => _controller2.playWithIconTransition(
    AppIconAnimation.particle,
    to: AppIconData.heart_fill,
    color: Colors.red,
    repeat: false,
  );
}
