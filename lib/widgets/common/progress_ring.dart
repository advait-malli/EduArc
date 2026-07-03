import 'dart:math';
import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  final int completedDays;
  final int leaveDays;
  final int totalDays;
  final double size;

  const ProgressRing({
    super.key,
    required this.completedDays,
    this.leaveDays = 0,
    required this.totalDays,
    this.size = 200,
  }) : assert(
         completedDays + leaveDays <= totalDays,
         'Sum of completed and leave days cannot exceed total days',
       );

  @override
  Widget build(BuildContext context) {
    final progress = completedDays / totalDays;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _ProgressRingPainter(
              completedDays: completedDays,
              leaveDays: leaveDays,
              totalDays: totalDays,
              presentColor: Theme.of(context).colorScheme.primary,
              leaveColor: Theme.of(context).colorScheme.tertiary,
              absentColor: Theme.of(context).colorScheme.error,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  fontSize: size * 0.22,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: size * 0.02),
              Text(
                '$completedDays of $totalDays days',
                style: TextStyle(
                  fontSize: size * 0.08,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final int completedDays;
  final int leaveDays;
  final int totalDays;
  final Color presentColor;
  final Color leaveColor;
  final Color absentColor;

  _ProgressRingPainter({
    required this.completedDays,
    required this.leaveDays,
    required this.totalDays,
    required this.presentColor,
    required this.leaveColor,
    required this.absentColor,
  });

  double get progress => (completedDays + leaveDays) / totalDays;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth =
        size.width * 0.08; // Responsive stroke width (8% of size)
    final radius = (size.width - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    final startAngle = -pi / 2;
    final gapAngle = 0.15;

    final presentPaint = Paint()
      ..color = presentColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final leavePaint = Paint()
      ..color = leaveColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final absentPaint = Paint()
      ..color = absentColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final presentRatio = completedDays / totalDays;
    final leaveRatio = leaveDays / totalDays;

    final presentSweep = (2 * pi * presentRatio).clamp(
      0.0,
      2 * pi - 2 * gapAngle,
    );
    final leaveSweep = (2 * pi * leaveRatio).clamp(0.0, 2 * pi - gapAngle);
    final absentSweep = 2 * pi - presentSweep - leaveSweep - 2 * gapAngle;

    var currentAngle = startAngle;

    // Draw present segment
    if (presentSweep > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        presentSweep,
        false,
        presentPaint,
      );
      currentAngle += presentSweep + gapAngle;
    }

    // Draw leave segment
    if (leaveSweep > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        leaveSweep,
        false,
        leavePaint,
      );
      currentAngle += leaveSweep + gapAngle;
    }

    // Draw absent segment (if any)
    if (absentSweep > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        absentSweep,
        false,
        absentPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
