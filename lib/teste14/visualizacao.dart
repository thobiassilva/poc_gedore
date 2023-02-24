import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import '../background.painter.dart';

class Visualizacao extends StatefulWidget {
  final String dxfString;
  const Visualizacao({
    Key? key,
    required this.dxfString,
  }) : super(key: key);

  @override
  State<Visualizacao> createState() => _VisualizacaoState();
}

class _VisualizacaoState extends State<Visualizacao> {
  List<AcDbEntity> entites = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final dxf = DXF.fromString(widget.dxfString);
        entites = dxf.entities;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(20),
      maxScale: 5,
      minScale: 0.5,
      child: Container(
        width: 800,
        height: 800,
        color: Colors.grey.shade300,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return CustomPaint(
              painter: BackgroundPainter(
                min: 0,
                max: 800,
                tam: 25,
              ),
              foregroundPainter: DXFPainter(entites),
            );
          },
        ),
      ),
    );
  }
}

class DXFPainter extends CustomPainter {
  final List<AcDbEntity> entities;

  DXFPainter(this.entities);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.square;

    for (var i = 0; i < entities.length; i++) {
      final entity = entities[i];

      if (entity is AcDbCircle) {
        canvas.drawCircle(
          Offset(entity.x, -entity.y + size.height),
          entity.radius,
          paint,
        );
      }

      if (entity is AcDbLine) {
        canvas.drawLine(Offset(entity.x, -entity.y + size.height),
            Offset(entity.x1, -entity.y1 + size.height), paint);
      }

      if (entity is AcDbArc) {
        if (entity.endAngle - entity.startAngle < 0) {
          canvas.drawArc(
            Rect.fromCircle(
              center: Offset(entity.x, -entity.y + size.height),
              radius: entity.radius,
            ),
            -radians(entity.endAngle),
            radians(360 - entity.startAngle),
            false,
            paint..color,
          );

          canvas.drawArc(
            Rect.fromCircle(
              center: Offset(entity.x, -entity.y + size.height),
              radius: entity.radius,
            ),
            -radians(entity.startAngle),
            -radians(entity.endAngle),
            false,
            paint..color,
          );
        } else {
          canvas.drawArc(
            Rect.fromCircle(
              center: Offset(entity.x, -entity.y + size.height),
              radius: entity.radius,
            ),
            -radians(entity.startAngle),
            -radians(entity.endAngle - entity.startAngle),
            false,
            paint..color,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
