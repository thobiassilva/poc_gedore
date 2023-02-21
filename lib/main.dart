import 'package:flutter/material.dart';
import 'package:poc_gedore/dxf.store.dart';

import 'teste13/teste13.dart';

class Constants {
  static const String API_URL =
      'https://1cc6-2804-108c-f8e6-bd01-598f-6c05-a8a7-3196.ngrok.io';
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
      body: const Teste13(),

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
