import 'package:flutter/material.dart';
import 'package:poc_gedore/dxf.store.dart';

import '../background.painter.dart';
import 'ferramenta.widget.dart';

class Teste6 extends StatefulWidget {
  final DXFStore store;

  const Teste6({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  State<Teste6> createState() => _Teste6State();
}

class _Teste6State extends State<Teste6> {
  double xAjust = 0;
  double yAjust = 0;

  final double tam = 25;

  Color color = Colors.white;

  final List<Ferramenta> ferramentas = [
    Ferramenta(),
    // Ferramenta(cor: Colors.blue),
    // Ferramenta(cor: Colors.green)
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InteractiveViewer(
      clipBehavior: Clip.none,
      // panEnabled: false,
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
              child: Stack(
                clipBehavior: Clip.none,
                children: ferramentas
                    .map(
                      (fer) => Positioned(
                        left: fer.pos.dx,
                        bottom: fer.pos.dy,
                        child: FerramentaWidget(
                          color: fer.cor,
                          pos: fer.pos,
                          onPanUpdate: (delta) {
                            setState(() {
                              fer.pos += Offset(delta.dx, -delta.dy);
                              widget.store.setState(
                                pos: fer.pos,
                                size: const Size(150, 75),
                              );
                            });
                          },
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

class Ferramenta {
  Offset pos;
  final Color cor;

  Ferramenta({
    this.pos = const Offset(0, 0),
    this.cor = Colors.green,
  });
}
