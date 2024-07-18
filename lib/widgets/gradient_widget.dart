import 'package:flutter/material.dart';

Widget gradientWidget({
  required Gradient gradient,
  required Widget child,
}) {
  return ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (bounds) => gradient.createShader(
      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
    ),
    child: child,
  );
}
