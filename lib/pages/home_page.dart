import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../music_player.dart';
import '../widgets/wave_animation.dart';

class VerticalTextTape extends StatelessWidget {
  final List<String> slogans;
  final bool isLeft;

  const VerticalTextTape({super.key, required this.slogans, this.isLeft = true});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: isLeft ? 0 : null,
      right: isLeft ? null : 0,
      bottom: 0,
      child: Center(
        child: RotatedBox(
          quarterTurns: isLeft ? 1 : 3,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  slogans.map((slogan) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(slogan, style: TextStyle(fontSize: 14, color: Color(0xFF4A3F35).withAlpha(128), fontFamily: 'Montserrat', letterSpacing: 2)),
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

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
          // Vertical text tapes
          VerticalTextTape(
            slogans: [
              'NO REGISTRATION',
              'NO ACCOUNTS',
              'NO AUTHORIZATION',
              'NO LOGIN',
              'NO TRACKING',
              'NO COOKIES',
              'NO ADS',
              'NO DISTRACTIONS',
              'NO REGISTRATION',
              'NO ACCOUNTS',
              'NO AUTHORIZATION',
              'NO LOGIN',
              'NO TRACKING',
              'NO COOKIES',
              'NO ADS',
              'NO DISTRACTIONS',
            ],
            isLeft: true,
          ),
          VerticalTextTape(
            slogans: [
              'JUST PLAY',
              'JUST FOCUS',
              'JUST STUDY',
              'JUST RELAX',
              'JUST FLOW',
              'JUST ENJOY',
              'JUST PLAY',
              'JUST FOCUS',
              'JUST STUDY',
              'JUST RELAX',
              'JUST FLOW',
              'JUST ENJOY',
              'JUST PLAY',
              'JUST FOCUS',
              'JUST STUDY',
              'JUST RELAX',
            ],
            isLeft: false,
          ),
          // Volume control at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const VolumeDotsAnimation(isLeft: true),
                  const SizedBox(width: 16),
                  ...List.generate(5, (index) {
                    final volume = (index + 1) / 5.0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: StreamBuilder<double>(
                        stream: _musicPlayer.volumeStream,
                        builder: (context, snapshot) {
                          final currentVolume = snapshot.data ?? 1.0;
                          final isActive = currentVolume >= volume;
                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => _musicPlayer.setVolume(volume),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isActive ? Color(0xFF4A3F35) : Color(0xFF4A3F35).withAlpha(77),
                                  boxShadow: [BoxShadow(color: Color(0xFF4A3F35).withAlpha(51), blurRadius: 4, spreadRadius: 0)],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  const SizedBox(width: 16),
                  const VolumeDotsAnimation(isLeft: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VolumeDotsAnimation extends StatefulWidget {
  final bool isLeft;

  const VolumeDotsAnimation({super.key, required this.isLeft});

  @override
  State<VolumeDotsAnimation> createState() => _VolumeDotsAnimationState();
}

class _VolumeDotsAnimationState extends State<VolumeDotsAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat();

    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(32, 16),
          painter: VolumeDotsPainter(animation: _animation.value, color: const Color(0xFF4A3F35).withAlpha(77), isLeft: widget.isLeft),
        );
      },
    );
  }
}

class VolumeDotsPainter extends CustomPainter {
  final double animation;
  final Color color;
  final bool isLeft;

  VolumeDotsPainter({required this.animation, required this.color, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final centerY = size.height / 2;
    final spacing = size.width / 3;
    final radius = 2.0;

    for (int i = 0; i < 3; i++) {
      final x = isLeft ? i * spacing : size.width - (i * spacing);
      final y = centerY + math.sin(animation + (i * math.pi / 2)) * 3;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(VolumeDotsPainter oldDelegate) => true;
}
