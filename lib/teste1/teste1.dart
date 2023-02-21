import 'package:flutter/material.dart';

import '../background.painter.dart';

class Teste1 extends StatefulWidget {
  const Teste1({super.key});

  @override
  State<Teste1> createState() => _Teste1State();
}

class _Teste1State extends State<Teste1> {
  double xAjust = 0;
  double yAjust = 0;

  final double tam = 25;

  final List<Objeto> objetos = [
    Objeto(),
    Objeto(cor: Colors.blue, radius: 50),
    Objeto(cor: Colors.green)
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        for (var obj in objetos) {
          obj.x = 150;
          obj.y = 250;
        }
      });
    });
  }

  void _onPanUpdate(DragUpdateDetails details, Objeto objeto) {
    setState(() {
      objeto.x = ((details.globalPosition.dx + tam) / tam).ceil() * tam;
      objeto.y = ((details.globalPosition.dy + tam) / tam).ceil() * tam;
    });
    //  ((maxTemp + 5) / 5).ceil() * 5
  }

  void _onPanDown(DragDownDetails details, Objeto objeto) {
    setState(() {
      objeto.x = ((details.globalPosition.dx + tam) / tam).ceil() * tam;
      objeto.y = ((details.globalPosition.dy + tam) / tam).ceil() * tam;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: 1000,
      height: 1000,
      color: Colors.transparent,
      child: CustomPaint(
        painter: BackgroundPainter(),
        child: LayoutBuilder(builder: (context, constraints) {
          xAjust = size.width - constraints.maxWidth;
          yAjust = size.height - constraints.maxHeight;

          return Stack(
            children: objetos
                .map((obj) => Positioned(
                      // left: obj.x - (xAjust + (obj.radius / 2)),
                      // top: obj.y - (yAjust + (obj.radius / 2)),
                      left: obj.x -
                          ((((xAjust + tam) / tam).ceil() * tam) + (tam)),
                      top: obj.y - ((yAjust + tam) / tam).ceil() * tam,
                      child: GestureDetector(
                        onPanUpdate: (details) => _onPanUpdate(details, obj),
                        onPanDown: (details) => _onPanDown(details, obj),
                        child: Container(
                          width: obj.radius,
                          height: obj.radius,
                          decoration: BoxDecoration(
                            color: obj.cor,
                            // shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          );
        }),
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
    this.radius = 25,
    this.cor = Colors.red,
  });
}
