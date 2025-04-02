import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../music_player.dart';
import '../widgets/wave_animation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<ImageProvider> _noiseImageFuture;
  late MusicPlayer _musicPlayer;
  bool _isPlaying = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _noiseImageFuture = _loadNoiseImage();
    _musicPlayer = MusicPlayer();
    _setupMusicPlayerListener();
  }

  void _setupMusicPlayerListener() {
    _musicPlayer.isPlayingStream.listen((isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
    });
  }

  Future<ImageProvider> _loadNoiseImage() async {
    final ByteData data = await rootBundle.load('assets/images/light_noise_transparent.png');
    return MemoryImage(data.buffer.asUint8List());
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _musicPlayer.pause();
    } else {
      await _musicPlayer.play('assets/audio/lofi1.mp3');
    }
  }

  @override
  void dispose() {
    _musicPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Base gradient background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF8E9D2), // Warm beige
                  Color(0xFFE6D5B8), // Slightly darker beige
                ],
              ),
            ),
          ),
          // Decorative corner gradients
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                gradient: RadialGradient(center: Alignment.topLeft, radius: 1.0, colors: [Color(0xFF4A3F35).withAlpha(26), Colors.transparent]),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                gradient: RadialGradient(center: Alignment.bottomRight, radius: 1.0, colors: [Color(0xFF4A3F35).withAlpha(26), Colors.transparent]),
              ),
            ),
          ),
          // Secondary gradient overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF4A3F35).withAlpha(13), // ~0.05 opacity
                  Color(0xFF4A3F35).withAlpha(26), // ~0.1 opacity
                ],
              ),
            ),
          ),
          // Decorative circular gradient
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            right: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFF4A3F35).withAlpha(13), Colors.transparent])),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.3,
            left: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFF4A3F35).withAlpha(13), Colors.transparent])),
            ),
          ),
          // Noise effect overlay
          FutureBuilder<ImageProvider>(
            future: _noiseImageFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(image: DecorationImage(image: snapshot.data!, repeat: ImageRepeat.repeat, opacity: 0.5)),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Allrensys',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A3F35), // Warm brown
                          fontFamily: 'PlayfairDisplay',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Your Perfect Study Companion',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, color: Color(0xFF4A3F35), fontFamily: 'Montserrat'),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Focus • Relax • Flow',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Color(0xFF4A3F35).withAlpha(204), fontFamily: 'Montserrat'),
                      ),
                      const SizedBox(height: 60),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                        constraints: BoxConstraints(maxWidth: 120, maxHeight: 120),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => setState(() => _isHovered = true),
                          onExit: (_) => setState(() => _isHovered = false),
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                transform:
                                    Matrix4.identity()
                                      ..translate(60.0, 60.0) // Move to center (half of max width/height)
                                      ..scale(_isHovered ? 1.05 : 1.0)
                                      ..translate(-60.0, -60.0), // Move back
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF4A3F35),
                                  boxShadow: [
                                    BoxShadow(color: Color(0xFF4A3F35).withAlpha(77), blurRadius: _isHovered ? 25 : 20, spreadRadius: _isHovered ? 7 : 5),
                                    BoxShadow(color: Color(0xFFF8E9D2).withAlpha(128), blurRadius: _isHovered ? 15 : 10, spreadRadius: _isHovered ? -7 : -5),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 60, color: Color(0xFFF8E9D2)),
                                  onPressed: _togglePlay,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: 40, // Fixed height for both text and animation
                        child:
                            _isPlaying
                                ? const Center(child: WaveAnimation())
                                : Center(
                                  child: Text(
                                    'Press play to begin your journey',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16, color: Color(0xFF4A3F35).withAlpha(179), fontFamily: 'Montserrat'),
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
