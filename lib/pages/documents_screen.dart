import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class DocumentsScreen extends StatefulWidget {
  DocumentsScreen({Key? key}) : super(key: key);

  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  XFile? image;
  Size? size;

  @override
  void initState() {
    super.initState();
    _loadCameras();
  }

  Future<void> _loadCameras() async {
    try {
      cameras = await availableCameras();
      _startCamera();
    } on CameraException catch (e) {
      print(e.description);
    }
  }

  void _startCamera() {
    if (cameras.isEmpty) {
      print('Camera not found!');
    } else {
      _previewCamera(cameras.first);
    }
  }

  void _previewCamera(CameraDescription camera) async {
    final CameraController cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print(e.description);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Official Documents'),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        color: Colors.grey[900],
        child: Center(
          child: _fileWidget(),
        ),
      ),
      floatingActionButton: (image != null)
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.pop(context),
              label: Text('Finished'),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _fileWidget() {
    return Container(
      width: size!.width - 50,
      height: size!.height - (size!.height / 3),
      child: image == null
          ? _cameraPreviewWidget()
          : Image.file(
              File(image!.path),
              fit: BoxFit.contain,
            ),
    );
  }

  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return Text('Camera widget is not available!');
    } else {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          CameraPreview(controller!),
          _captureButtonWidget(),
        ],
      );
    }
  }

  Widget _captureButtonWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: CircleAvatar(
        radius: 32,
        backgroundColor: Colors.black.withOpacity(0.5),
        child: IconButton(
          onPressed: () => _takePicture(),
          icon: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  _takePicture() async {
    final CameraController? cameraController = controller;

    if (cameraController != null && cameraController.value.isInitialized) {
      try {
        XFile file = await cameraController.takePicture();

        if (mounted) setState(() => image = file);
      } on CameraException catch (e) {
        print(e.description);
      }
    }
  }
}
