import 'package:flutter/material.dart';
import 'package:poc_gedore/dxf.store.dart';

import 'teste14/teste14.dart';

class Constants {
  static const String API_URL =
      'https://f3eb-2804-108c-f899-7401-6032-793a-410a-1cfc.ngrok.io';
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final store = DXFStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: const Teste14(),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // store.lineDxf();
      //     // store.squareDxf();
      //     // store.circleDxf(radius: 25);
      //     store.generateDxf(radius: 25);
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
