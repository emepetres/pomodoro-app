import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'main.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _isRunning = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAlarmPlaying = false;

  @override
  void initState() {
    super.initState();
    // Initialize with the default value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<MyAppState>(context, listen: false);
      setState(() {
        _remainingSeconds = appState.pomodoroDuration * 60;
      });
    });
  }

  void _startTimer() {
    if (_isRunning) {
      // Pause
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    } else {
      // Start or Resume
      setState(() {
        _isRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _timer?.cancel();
            _isRunning = false;
            _playAlarm();
          }
        });
      });
    }
  }

  void _resetTimer() {
    final appState = Provider.of<MyAppState>(context, listen: false);
    _timer?.cancel();
    _stopAlarm();
    setState(() {
      _remainingSeconds = appState.pomodoroDuration * 60;
      _isRunning = false;
    });
  }

  String _formatTime() {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _playAlarm() async {
    if (!_isAlarmPlaying) {
      final appState = Provider.of<MyAppState>(context, listen: false);
      setState(() {
        _isAlarmPlaying = true;
      });
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('sounds/${appState.selectedSound}'));
    }
  }

  void _stopAlarm() async {
    if (_isAlarmPlaying) {
      await _audioPlayer.stop();
      setState(() {
        _isAlarmPlaying = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            color: theme.colorScheme.primary,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Text(_formatTime(), style: style),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: _resetTimer,
                child: const Text('Reset'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _startTimer,
                child: Text(_isRunning ? 'Pause' : 'Start'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
