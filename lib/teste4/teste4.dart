import 'package:flutter/material.dart';

import '../background.painter.dart';

class Teste4 extends StatefulWidget {
  const Teste4({super.key});

  @override
  State<Teste4> createState() => _Teste4State();
}

class _Teste4State extends State<Teste4> {
  double xAjust = 0;
  double yAjust = 0;

  final double tam = 20;

  Color color = Colors.white;

  final List<Objeto> objetos = [
    Objeto(),
    Objeto(cor: Colors.blue, radius: 80),
    Objeto(cor: Colors.green)
  ];

  void _onPanUpdate(DragUpdateDetails details, Objeto objeto) {
    setState(() {
      objeto.x += details.delta.dx;
      objeto.y -= details.delta.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(100),
      maxScale: 5,
      minScale: 0.5,
      child: Container(
        width: 800,
        height: 800,
        color: color,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return CustomPaint(
              painter: BackgroundPainter(
                min: 0,
                max: 800,
                tam: tam,
              ),
              size: size,
              child: Stack(
                children: objetos
                    .map(
                      (obj) => Positioned(
                        left: obj.x,
                        bottom: obj.y,
                        child: GestureDetector(
                          onPanUpdate: (details) => _onPanUpdate(details, obj),
                          child: Container(
                            width: obj.radius,
                            height: obj.radius,
                            decoration: BoxDecoration(
                              color: obj.cor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child:
                                    Text('${obj.x.toInt()}, ${obj.y.toInt()}')),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Objeto {
  double radius;
  double x;
  double y;
  Color cor;

  Objeto({
    this.x = 0,
    this.y = 0,
    this.radius = 40,
    this.cor = Colors.red,
  });
}
