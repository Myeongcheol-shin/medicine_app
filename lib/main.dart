import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final FocusNode _focus = FocusNode();
  StreamController ctrl = StreamController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                textDirection: TextDirection.ltr,
                focusNode: _focus,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  ctrl.add(text);
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Padding(
                        padding: EdgeInsets.only(left: 13),
                        child: Icon(Icons.search))),
              ),
            ),
            StreamBuilder(
              stream: ctrl.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!,
                    textDirection: TextDirection.ltr,
                  );
                }
                return const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }
}
