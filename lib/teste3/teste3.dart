import 'package:flutter/material.dart';

import '../background.painter.dart';

class Teste3 extends StatefulWidget {
  const Teste3({super.key});

  @override
  State<Teste3> createState() => _Teste3State();
}

class _Teste3State extends State<Teste3> {
  double xAjust = 0;
  double yAjust = 0;

  // ValueNotifier<Offset> center = ValueNotifier<Offset>(Offset.zero);
  final store = MyStore();
  final double tam = 25;

  bool isFirstInit = true;

  Color color = Colors.white;

  final List<Objeto> objetos = [
    Objeto(),
    Objeto(cor: Colors.blue, radius: 50),
    Objeto(cor: Colors.green)
  ];

  @override
  void initState() {
    super.initState();
    // center.addListener(() {
    //   print(center.value);
    // });
  }

  void _onPanUpdate(DragUpdateDetails details, Objeto objeto) {
    setState(() {
      if (details.delta.dx > 0) {
        objeto.x += ((details.delta.dx + tam) / tam).ceil() * tam;
      }

      if (details.delta.dx < 0) {
        objeto.x -= ((details.delta.dx + tam) / tam).ceil() * tam;
      }

      if (details.delta.dy > 0) {
        objeto.y += ((details.delta.dy + tam) / tam).ceil() * tam;
      }

      if (details.delta.dy < 0) {
        objeto.y -= ((details.delta.dy + tam) / tam).ceil() * tam;
      }
      // objeto.x -= ((details.delta.dx + tam) / tam).ceil() * tam;
      // objeto.y += ((details.delta.dy + tam) / tam).ceil() * tam;

      // objeto.x += details.delta.dx;
      // objeto.y += details.delta.dy;
    });
    //  ((maxTemp + 5) / 5).ceil() * 5
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onPanUpdate: (details) => store.updateCenter(details.delta),
      child: Container(
        color: color,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (isFirstInit) {
              // store.setCenter(
              //     Offset(constraints.maxWidth / 2, constraints.maxHeight / 2));
              isFirstInit = false;
            }
            return ValueListenableBuilder(
                valueListenable: store,
                builder: (context, _, child) {
                  return CustomPaint(
                    // willChange: true,
                    // isComplex: true,
                    painter: BackgroundPainter(
                      min: -600,
                      max: 600,
                    ),
                    size: size,
                    child: Stack(
                      children: objetos
                          .map((obj) => Positioned(
                                // left: store.value.dx +
                                //     obj.x -
                                //     (xAjust + (obj.radius / 2)),
                                // top: store.value.dy +
                                //     obj.y -
                                //     (yAjust + (obj.radius / 2)),
                                // left: obj.x + store.value.dx - (xAjust / 1),
                                // top: obj.y + store.value.dy - (yAjust / 1),
                                left: obj.x + store.value.dx,
                                top: obj.y + store.value.dy,
                                // left: ((obj.x + tam) / tam).ceil() * tam +
                                //     store.value.dx,
                                // top: ((obj.y + tam) / tam).ceil() * tam +
                                //     store.value.dx,
                                child: GestureDetector(
                                  onPanUpdate: (details) =>
                                      _onPanUpdate(details, obj),
                                  child: Container(
                                    width: obj.radius,
                                    height: obj.radius,
                                    decoration: BoxDecoration(
                                      color: obj.cor,
                                      // shape: BoxShape.circle,
                                    ),
                                    child: Text(obj.x.toInt().toString()),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}

class MyStore extends ValueNotifier<Offset> {
  MyStore() : super(Offset.zero);

  void setCenter(Offset offset) => value = offset;
  void updateCenter(Offset offset) => value += offset;
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
