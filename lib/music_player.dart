import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Stream controllers for state management
  final _isPlayingController = StreamController<bool>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _volumeController = StreamController<double>.broadcast();

  // Getters for streams
  Stream<bool> get isPlayingStream => _isPlayingController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<double> get volumeStream => _volumeController.stream;

  MusicPlayer() {
    _setupListeners();
    _audioPlayer.setLoopMode(LoopMode.all); // Set infinite loop
    _audioPlayer.setVolume(1.0); // Set initial volume to maximum
    _volumeController.add(1.0);
  }

  void _setupListeners() {
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      _isPlayingController.add(_isPlaying);
    });

    _audioPlayer.positionStream.listen((position) {
      _currentPosition = position;
      _positionController.add(position);
    });

    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        _totalDuration = duration;
        _durationController.add(duration);
      }
    });
  }

  Future<void> play(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.play();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
    _volumeController.add(volume);
  }

  void dispose() {
    _audioPlayer.dispose();
    _isPlayingController.close();
    _positionController.close();
    _durationController.close();
    _volumeController.close();
  }
}
