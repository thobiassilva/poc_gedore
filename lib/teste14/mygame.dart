import 'dart:async';

import 'package:dxf/dxf.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/src/gestures/events.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:poc_gedore/teste14/ferramenta.dart';

class MyGame extends FlameGame with HasDraggables, HasTappables {
  final Ferramenta ferramenta;

  MyGame(this.ferramenta);

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    add(
      Player(
        RectangleHitbox(
          position: Vector2(
            0,
            -ferramenta.menorY! - 10,
          ),
          size: Vector2(
            ferramenta.size.width,
            ferramenta.size.height,
          ),
        ),
      ),
    );
  }

  // @override
  // void onPanUpdate(DragUpdateInfo info) {
  //   // TODO: implement onPanUpdate
  //   super.onPanUpdate(info);

  //   position.x += info.delta.viewport.x;
  //   position.y += info.delta.viewport.y;
  // }
}

Widget customPainterBuilder(Ferramenta ferramenta) {
  return GameWidget(
    game: MyGame(ferramenta),
  );
}

class PlayerCustomPainter extends CustomPainter {
  final List<AcDbEntity> entities;
  final double menorX;
  final double menorY;

  PlayerCustomPainter({
    required this.entities,
    required this.menorX,
    required this.menorY,
  });

  final paintt = Paint()
    ..color = Colors.red
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    for (var entity in entities) {
      final ajust = Offset(-menorX, menorY + size.height);

      if (entity is AcDbCircle) drawCircle(entity, ajust, canvas, paintt);
      if (entity is AcDbLine) drawLine(entity, ajust, canvas, paintt);
      if (entity is AcDbArc) drawArc(entity, ajust, canvas, paintt);
    }
  }

  void drawLine(AcDbLine entity, Offset ajust, Canvas canvas, Paint paint) {
    canvas.drawLine(
      Offset(entity.x, -entity.y) + ajust,
      Offset(entity.x1, -entity.y1) + ajust,
      paint,
    );
  }

  void drawCircle(AcDbCircle entity, Offset ajust, Canvas canvas, Paint paint) {
    canvas.drawCircle(
      Offset(entity.x, -entity.y) + ajust,
      entity.radius,
      paint,
    );
  }

  void drawArc(AcDbArc entity, Offset ajust, Canvas canvas, Paint paint) {
    final rect = Rect.fromCircle(
      center: Offset(entity.x, -entity.y) + ajust,
      radius: entity.radius,
    );

    if (entity.endAngle - entity.startAngle < 0) {
      canvas.drawArc(
        rect,
        -radians(entity.endAngle),
        radians(360 - entity.startAngle),
        false,
        paint,
      );

      canvas.drawArc(
        rect,
        -radians(entity.startAngle),
        -radians(entity.endAngle),
        false,
        paint..color,
      );
    } else {
      canvas.drawArc(
        rect,
        -radians(entity.startAngle),
        -radians(entity.endAngle - entity.startAngle),
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class Player extends CustomPainterComponent
    with HasGameRef<MyGame>, Tappable, Draggable, GestureHitboxes {
  final ShapeHitbox hitbox;

  Player(this.hitbox);

  @override
  Future<void> onLoad() async {
    painter = PlayerCustomPainter(
      entities: gameRef.ferramenta.entities,
      menorX: gameRef.ferramenta.menorX!,
      menorY: gameRef.ferramenta.menorY!,
    );
    size = Vector2.all(100);

    position = Vector2.all(200);

    hitbox.paint.color = Colors.blue;
    hitbox.renderShape = true;
    add(hitbox);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    // TODO: implement onTapDown
    print('onTapDown ${info.eventPosition.game.x}');
    return super.onTapDown(info);
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    // TODO: implement onDragUpdate
    print('onDragUpdate ${info.delta.game.x}');
    return super.onDragUpdate(info);
  }

  @override
  bool onDragStart(DragStartInfo info) {
    // TODO: implement onDragStart
    print('onDragStart ${info.eventPosition.game.x}');
    return super.onDragStart(info);
  }

  // @override
  // void update(double dt) {
  //   super.update(dt);

  //   x += speed * direction * dt;

  //   if ((x + width >= gameRef.size.x && direction > 0) ||
  //       (x <= 0 && direction < 0)) {
  //     direction *= -1;
  //   }
  // }
}
