import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';
import 'package:bookkepping/ultis/color.dart';

class CustomArcPainter extends CustomPainter {
  final double start;
  final double progress;
  final double width;
  final double blurWidth;

  CustomArcPainter({
    this.start = 0,
    required double budgetLimit,
    required double thisMonthTotal,
    this.width = 15,
    this.blurWidth = 6,
  }) : progress = thisMonthTotal / budgetLimit;

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);

    var gradientColor = LinearGradient(
        colors: [secondary, secondary],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);

    Paint activePaint = Paint();

    double actualEnd = progress * 270 > 270 ? 270 : progress * 270 ;

    if (actualEnd >= 270) {
      activePaint.color = Color(0xFFFF0000);
    } else {
      activePaint.shader = gradientColor.createShader(rect);
    }

    activePaint.style = PaintingStyle.stroke;
    activePaint.strokeWidth = width;
    activePaint.strokeCap = StrokeCap.round;

    Paint backgroundPaint = Paint();
    backgroundPaint.color = gray60;
    backgroundPaint.style = PaintingStyle.stroke;
    backgroundPaint.strokeWidth = width;
    backgroundPaint.strokeCap = StrokeCap.round;

    Paint shadowPaint = Paint()
      ..color = secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = width + blurWidth
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    var startVal = 135.0 + start;

    canvas.drawArc(
        rect, radians(startVal), radians(270), false, backgroundPaint);

    //Draw Shadow Arc
    Path path = Path();
    path.addArc(rect, radians(startVal), radians(actualEnd));
    canvas.drawArc(rect, radians(startVal), radians(actualEnd), false, activePaint);
  }

  @override
  bool shouldRepaint(CustomArcPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CustomArcPainter oldDelegate) => false;
}
