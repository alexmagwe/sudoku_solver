import 'dart:io';
// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Solve extends StatefulWidget {
  final String picture;
  const Solve({Key? key, required this.picture}) : super(key: key);

  @override
  SolveState createState() => SolveState();
}

class SolveState extends State<Solve> {
  Future solve() async {
    print('the picture path:${widget.picture}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(child: Image.file(File(widget.picture))),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: solve,
          child: const Text(
            'Solve',
            style: TextStyle(color: Colors.white),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
