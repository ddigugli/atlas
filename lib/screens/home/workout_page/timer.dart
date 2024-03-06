import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final int seconds;

  TimerWidget({required this.seconds});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  int _currentSeconds = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _currentSeconds = widget.seconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          if (_currentSeconds > 0) {
            _currentSeconds--;
          } else {
            _timer.cancel();
          }
        });
      }
    });
  }

  void _pauseResumeTimer() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  Widget _buildProgressBar() {
    double progress = 1 - (_currentSeconds / widget.seconds);
    return LinearProgressIndicator(
      value: progress,
      color: Colors.blue,
      backgroundColor: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Flow'),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: _pauseResumeTimer,
            child: Center(
              child: Text(
                '$_currentSeconds',
                style: TextStyle(
                  fontSize: 48,
                  color: _isPaused ? Colors.red : Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildProgressBar(),
          ),
        ],
      ),
    );
  }
}