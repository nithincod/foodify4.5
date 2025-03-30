import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodify2o/pages/foodify2oFoodSearchScreen.dart';
import 'package:foodify2o/utils/searchinput.dart';
import 'package:permission_handler/permission_handler.dart';
import 'foodify2opreviewPage.dart';

class SnapTrackPage extends StatefulWidget {
  final String appBarTitle;

  SnapTrackPage({required this.appBarTitle});

  @override
  _SnapTrackPageState createState() => _SnapTrackPageState();
}

class _SnapTrackPageState extends State<SnapTrackPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      _initializeCamera();
    } else {
      print('Camera permission denied');
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        if (!mounted) return;

        setState(() => _isCameraInitialized = true);
      } else {
        print('No cameras available');
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print('Camera is not initialized');
      return;
    }
    try {
      XFile image = await _cameraController!.takePicture();
      if (!mounted) return;

      // Navigate to PreviewPage with the captured image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewPage(imagePath: image.path),
        ),
      );
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.appBarTitle,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                _isCameraInitialized && _cameraController != null
                    ? CameraPreview(_cameraController!)
                    : Center(child: CircularProgressIndicator()),
                Positioned(
                  bottom: 40,
                  child: GestureDetector(
                    onTap: _isCameraInitialized ? _captureImage : null,
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt, color: Colors.black, size: 30),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Snap or Add from gallery',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FoodSearchScreen()),
                );
              },
              child: IgnorePointer(
                child: SearchInput(
                  textController: TextEditingController(),
                  hintText: 'Search for food',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}