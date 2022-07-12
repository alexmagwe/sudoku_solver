import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'solve.dart';

class Home extends StatefulWidget {
  final String title;
  final List<CameraDescription> cameras;
  const Home({Key? key, required this.title, required this.cameras})
      : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  late CameraController _cameraController;

  Future _initCamera(CameraDescription cam) async {
    _cameraController = CameraController(cam, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  Future _takePicture() async {
    // XFile picture =await _takePicture();
    if (!_cameraController.value.isInitialized) return null;
    if (_cameraController.value.isTakingPicture) return null;
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile img = await _cameraController.takePicture();
      setState(() {});
      if (!mounted) return;
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Solve(picture: img.path)));
    } on CameraException catch (e) {
      // throw new Exception(e);
      debugPrint('error occured $e');
      return null;
    }
  }

  Future<List<CameraDescription>> getCameras() async {
    final cameras = await availableCameras();
    return cameras;
  }

  @override
  void initState() {
    super.initState();
    _initCamera(widget.cameras[0]);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      XFile img = XFile(image.path);
      setState(() {});
      if (!mounted) return;
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Solve(picture: img.path)));
    } on PlatformException catch (e) {
      // throw new Exception(e);
      debugPrint('Error occured:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Take a photo of a sudoku puzzle'),
              const SizedBox(height: 10.0),
              _cameraController.value.isInitialized
                  ? Expanded(
                      child: Center(child: CameraPreview(_cameraController)),
                    )
                  : Expanded(
                      child: Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
            ]),
      ),
      bottomSheet:
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        IconButton(
          icon: const Icon(Icons.image_outlined),
          onPressed: pickImage,
        ),
        IconButton(
          icon: const Icon(Icons.camera_alt_outlined),
          onPressed: _takePicture,
        ),
      ]),
    );
  }
}
