import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = const [];
  int _cameraIndex = 0;
  String? _error;
  XFile? _capturedPhoto;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameras.isEmpty) return;

    if (state == AppLifecycleState.inactive) {
      final controller = _controller;
      _controller = null;
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed && _controller == null) {
      _initController(_cameras[_cameraIndex]);
    }
  }

  Future<void> _setupCamera() async {
    try {
      _cameras = await availableCameras();
    } on CameraException catch (e) {
      setState(() => _error = e.description ?? 'Tidak dapat mengakses kamera');
      return;
    }

    if (_cameras.isEmpty) {
      setState(() => _error = 'Kamera tidak tersedia di perangkat ini');
      return;
    }

    _cameraIndex = _cameras.indexWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );
    if (_cameraIndex < 0) _cameraIndex = 0;

    await _initController(_cameras[_cameraIndex]);
  }

  Future<void> _initController(CameraDescription description) async {
    final previous = _controller;
    _controller = null;
    if (mounted) setState(() {});
    await previous?.dispose();

    final controller = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      await controller.dispose();
      if (mounted) {
        setState(() => _error = e.description ?? 'Gagal membuka kamera');
      }
      return;
    }

    if (!mounted) {
      await controller.dispose();
      return;
    }
    setState(() => _controller = controller);
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2 || _capturedPhoto != null) return;
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _initController(_cameras[_cameraIndex]);
  }

  Future<void> _takePhoto() async {
    final controller = _controller;
    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture) {
      return;
    }

    try {
      final photo = await controller.takePicture();
      setState(() => _capturedPhoto = photo);
    } on CameraException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.description ?? 'Gagal mengambil foto')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _capturedPhoto != null ? _buildPhotoPreview() : _buildCamera(),
      ),
    );
  }

  Widget _buildCamera() {
    final controller = _controller;

    if (_error != null) {
      return _buildMessage(_error!);
    }
    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Center(child: CameraPreview(controller)),
        Positioned(
          top: 8,
          left: 8,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
          ),
        ),
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 56),
              GestureDetector(
                onTap: _takePhoto,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 5),
                  ),
                ),
              ),
              IconButton(
                onPressed: _cameras.length > 1 ? _flipCamera : null,
                icon: const Icon(
                  Icons.flip_camera_android,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoPreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: Image.file(File(_capturedPhoto!.path), fit: BoxFit.contain),
        ),
        Positioned(
          bottom: 24,
          left: 24,
          right: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: 'retake',
                backgroundColor: Colors.white24,
                onPressed: () => setState(() => _capturedPhoto = null),
                child: const Icon(Icons.refresh, color: Colors.white),
              ),
              FloatingActionButton(
                heroTag: 'confirm',
                backgroundColor: const Color(0xFF00A884),
                onPressed: () =>
                    Navigator.pop(context, _capturedPhoto!.path),
                child: const Icon(Icons.check, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessage(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.no_photography, color: Colors.white54, size: 64),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
