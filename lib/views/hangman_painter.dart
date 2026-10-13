import 'package:flutter/material.dart';

class HangmanPainter extends CustomPainter {
  final int errors;

  const HangmanPainter({required this.errors});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint woodPaint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Paint bodyPaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double w = size.width;
    final double h = size.height;

    final double baseY = h - 8.0;
    final double poleX = w * 0.2;
    const double beamY = 8.0;
    final double beamEndX = w * 0.7;
    const double ropeY = beamY + 24.0;

    // Base
    canvas.drawLine(Offset(poleX - 30.0, baseY), Offset(poleX + 30.0, baseY), woodPaint);
    // Poste vertical
    canvas.drawLine(Offset(poleX, baseY), Offset(poleX, beamY), woodPaint);
    // Trave superior
    canvas.drawLine(Offset(poleX, beamY), Offset(beamEndX, beamY), woodPaint);
    // Corda
    canvas.drawLine(Offset(beamEndX, beamY), Offset(beamEndX, ropeY), woodPaint);

    const double headRadius = 18.0;
    final Offset headCenter = Offset(beamEndX, ropeY + headRadius);
    const double chinY = ropeY + headRadius * 2.0;
    const double torsoEndY = chinY + 52.0;

    // 1. Cabeça
    if (errors >= 1) {
      canvas.drawCircle(headCenter, headRadius, bodyPaint);
    }
    // 2. Tronco
    if (errors >= 2) {
      canvas.drawLine(Offset(beamEndX, chinY), Offset(beamEndX, torsoEndY), bodyPaint);
    }
    // 3. Braço esquerdo
    if (errors >= 3) {
      canvas.drawLine(
        Offset(beamEndX, chinY + 14.0),
        Offset(beamEndX - 26.0, chinY + 34.0),
        bodyPaint,
      );
    }
    // 4. Braço direito
    if (errors >= 4) {
      canvas.drawLine(
        Offset(beamEndX, chinY + 14.0),
        Offset(beamEndX + 26.0, chinY + 34.0),
        bodyPaint,
      );
    }
    // 5. Perna esquerda
    if (errors >= 5) {
      canvas.drawLine(
        Offset(beamEndX, torsoEndY),
        Offset(beamEndX - 22.0, torsoEndY + 34.0),
        bodyPaint,
      );
    }
    // 6. Perna direita
    if (errors >= 6) {
      canvas.drawLine(
        Offset(beamEndX, torsoEndY),
        Offset(beamEndX + 22.0, torsoEndY + 34.0),
        bodyPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant HangmanPainter oldDelegate) {
    return oldDelegate.errors != errors;
  }
}

class HangmanFigure extends StatelessWidget {
  final int errors;

  const HangmanFigure({super.key, required this.errors});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220.0,
      height: 220.0,
      child: CustomPaint(
        painter: HangmanPainter(errors: errors),
      ),
    );
  }
}
