import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import 'dart:async';

class ShakeToWinScreen extends StatefulWidget {
  const ShakeToWinScreen({Key? key}) : super(key: key);

  @override
  State<ShakeToWinScreen> createState() => _ShakeToWinScreenState();
}

class _ShakeToWinScreenState extends State<ShakeToWinScreen> {
  StreamSubscription<AccelerometerEvent>? _sensorSubscription;
  bool _hasWon = false;
  int _wonPoints = 0;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    // Güncel sensors_plus paketi için accelerometerEventStream kullanılmıştır.
    _sensorSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      if (_hasWon) return;

      double acceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (acceleration > 15) {
        _triggerWin();
      }
    });
  }

  void _triggerWin() {
    if (!mounted) return;
    setState(() {
      _hasWon = true;
      List<int> possiblePoints = [100, 200, 500];
      _wonPoints = possiblePoints[Random().nextInt(possiblePoints.length)];
    });
  }

  @override
  void dispose() {
    _sensorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Salla Kazan"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _hasWon
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.card_giftcard, size: 80, color: Colors.green),
                  const SizedBox(height: 20),
                  Text(
                    "Tebrikler! $_wonPoints Puan Kazandınız!",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.vibration, size: 80, color: Colors.blueGrey),
                  SizedBox(height: 20),
                  Text(
                    "Puan Kazanmak İçin Telefonu Salla!",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
      ),
    );
  }
}
