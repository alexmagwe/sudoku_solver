import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black)),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: Colors.purple),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        primarySwatch: Colors.purple,
      ),
      home: FutureBuilder(
          future: availableCameras(),
          builder: (context, AsyncSnapshot<List<CameraDescription>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Home(title: 'SudoKing', cameras: snapshot.data!);
              }
            }

            if (snapshot.hasError) {
              return Text('error occured $snapshot.error');
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
