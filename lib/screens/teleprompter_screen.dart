import 'dart:async';
import 'package:flutter/material.dart';
import '../models/desafio.dart';

class TeleprompterScreen extends StatefulWidget {
  final Desafio desafio;
  const TeleprompterScreen({Key? key, required this.desafio}) : super(key: key);

  @override
  State<TeleprompterScreen> createState() => _TeleprompterScreenState();
}

class _TeleprompterScreenState extends State<TeleprompterScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  bool _isPlaying = false;
  double _velocidade = 1.0; 

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleScroll() {
    if (_isPlaying) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.offset + (2.0 * _velocidade));
        }
      });
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.desafio.titulo),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Fundo provisório (onde ficará a câmera)
          Container(
            color: const Color(0xFF1E1E1E),
            width: double.infinity,
            height: double.infinity,
            child: const Center(
              child: Text(
                '📷 [Câmera Frontal Aqui]',
                style: TextStyle(color: Colors.white24, fontSize: 20),
              ),
            ),
          ),

          // Texto do Teleprompter
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 100.0),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.white, Colors.white, Colors.transparent],
                    stops: [0.0, 0.1, 0.9, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Text(
                    widget.desafio.roteiro,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

          // Controles
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black.withOpacity(0.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Velocidade', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                            onPressed: () {
                              if (_velocidade > 0.5) setState(() => _velocidade -= 0.5);
                            },
                          ),
                          Text('${_velocidade}x', style: const TextStyle(color: Colors.white)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                            onPressed: () {
                              if (_velocidade < 3.0) setState(() => _velocidade += 0.5);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  FloatingActionButton(
                    backgroundColor: _isPlaying ? Colors.red : Colors.green,
                    onPressed: _toggleScroll,
                    child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 32),
                  ),
                  IconButton(
                    icon: const Icon(Icons.restart_alt, color: Colors.white, size: 32),
                    onPressed: () {
                      _timer?.cancel();
                      setState(() => _isPlaying = false);
                      _scrollController.jumpTo(0.0);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}