import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Demo',
      home: CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Get a list of available cameras
    final cameras = await availableCameras();
    // Choose the first camera in the list
    final firstCamera = cameras.first;

    // Initialize the CameraController with the chosen camera
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    // Call the .initialize() method to prepare the camera for use
    return _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the camera controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera Demo')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the CameraController has been initialized, return the CameraPreview
            return CameraPreview(_controller);
          } else {
            // Otherwise, return a loading indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            // Take a picture and store it as a file
            final picture = await _controller.takePicture();

            // Do something with the picture file (e.g. display it in a new screen)
          } catch (e) {
            print('Error taking picture: $e');
          }
        },
      ),
    );
  }
}
