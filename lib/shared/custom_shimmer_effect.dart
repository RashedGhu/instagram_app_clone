import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget customRectangleShimmerEffect({
  required BuildContext context,
  required double height,
  required double width,
  ShapeBorder borderShape = const RoundedRectangleBorder(),
}) {
  final _shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
  Colors.grey[300]!;
  return Shimmer(
    child: Container(
      height: height,
      width: width,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: borderShape,
      ),
    ),
    gradient: _shimmerGradient,
  );
}

Widget customCircularShimmerEffect({
  required BuildContext context,
  required double height,
  required double width,
  ShapeBorder borderShape = const CircleBorder(),
}) {
  final _shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
  return Shimmer(
    child: Container(
      height: height,
      width: width,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: borderShape,
      ),
    ),
    gradient: _shimmerGradient,
  );
}

