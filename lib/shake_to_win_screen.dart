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
    try {
      _sensorSubscription = accelerometerEventStream().listen(
        (AccelerometerEvent event) {
          if (_hasWon) return;

          double acceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
          if (acceleration > 15) {
            _triggerWin();
          }
        },
        onError: (error) {},
        cancelOnError: true,
      );
    } catch (e) {}
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hasWon = false;
                      });
                    },
                    child: const Text("Tekrar Dene"),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.vibration, size: 80, color: Colors.blueGrey),
                  const SizedBox(height: 20),
                  const Text(
                    "Puan Kazanmak İçin Telefonu Salla!",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: _triggerWin,
                    child: const Text(
                      "Test Et (Salla)",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
