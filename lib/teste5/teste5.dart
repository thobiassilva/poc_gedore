import 'package:flutter/material.dart';

import '../background.painter.dart';
import 'ferramenta.widget.dart';

class Teste5 extends StatefulWidget {
  const Teste5({super.key});

  @override
  State<Teste5> createState() => _Teste5State();
}

class _Teste5State extends State<Teste5> {
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
    this.pos = const Offset(200, 200),
    this.cor = Colors.red,
  });
}
