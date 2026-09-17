import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const YtLoveApp());
}

class YtLoveApp extends StatelessWidget {
  const YtLoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YT Love Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.red,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 0,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  int userCoins = 450;

  void _addCoins(int amount) {
    setState(() {
      userCoins += amount;
    });
  }

  void _deductCoins(int amount) {
    setState(() {
      userCoins -= amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      WatchScreen(onCoinEarned: _addCoins),
      CampaignScreen(userCoins: userCoins, onCoinDeduct: _deductCoins),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('YT Love', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red, size: 18),
                const SizedBox(width: 6),
                Text(
                  '$userCoins',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF1F1F1F),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_fill),
            label: 'Video İzle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Kampanyalarım',
          ),
        ],
      ),
    );
  }
}

class WatchScreen extends StatefulWidget {
  final Function(int) onCoinEarned;
  const WatchScreen({super.key, required this.onCoinEarned});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  final List<Map<String, dynamic>> _videoQueue = [
    {'id': 'dQw4w9WgXcQ', 'duration': 60, 'reward': 60},
    {'id': '3JZ_D3ELwOQ', 'duration': 45, 'reward': 45},
    {'id': 'L_jWHffIx5E', 'duration': 90, 'reward': 90},
  ];

  int _currentVideoIndex = 0;
  YoutubePlayerController? _controller;
  Timer? _timer;
  int _remainingSeconds = 60;
  bool _autoNext = true;
  bool _isVideoFinished = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() {
    var currentVideo = _videoQueue[_currentVideoIndex];
    _remainingSeconds = currentVideo['duration'];
    _isVideoFinished = false;

    _controller?.dispose();
    _controller = YoutubePlayerController(
      initialVideoId: currentVideo['id'],
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: true,
        controlsVisibleAtStart: false,
      ),
    );

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _onVideoCompleted();
      }
    });
  }

  void _onVideoCompleted() {
    if (_isVideoFinished) return;
    _isVideoFinished = true;

    int reward = _videoQueue[_currentVideoIndex]['reward'];
    widget.onCoinEarned(reward);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tebrikler! +$reward Puan Kazandınız 🎉'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    if (_autoNext) {
      _nextVideo();
    }
  }

  void _nextVideo() {
    _timer?.cancel();
    setState(() {
      _currentVideoIndex = (_currentVideoIndex + 1) % _videoQueue.length;
    });
    _loadVideo();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentVideo = _videoQueue[_currentVideoIndex];

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          if (_controller != null)
            YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.red,
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _infoCard(Icons.timer, 'Kalan Süre', '$_remainingSeconds sn'),
              _infoCard(Icons.favorite, 'Kazanılacak', '+${currentVideo['reward']} Puan'),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.autorenew, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Otomatik Oynat (Auto Play)', style: TextStyle(color: Colors.white, fontSize: 15)),
                  ],
                ),
                Switch(
                  value: _autoNext,
                  activeColor: Colors.red,
                  onChanged: (val) {
                    setState(() {
                      _autoNext = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.grey),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: _nextVideo,
            icon: const Icon(Icons.skip_next, color: Colors.white),
            label: const Text('Diğer Videoya Geç', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.red, size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class CampaignScreen extends StatefulWidget {
  final int userCoins;
  final Function(int) onCoinDeduct;

  const CampaignScreen({super.key, required this.userCoins, required this.onCoinDeduct});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  final TextEditingController _urlController = TextEditingController();
  int _targetViews = 10;
  int _targetSeconds = 60;

  int get _totalCost => _targetViews * (_targetSeconds ~/ 10) * 10;

  void _createCampaign() {
    if (_urlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen geçerli bir YouTube URL girin.')),
      );
      return;
    }

    if (widget.userCoins < _totalCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yetersiz Puan! Önce video izleyerek puan kazanın.')),
      );
      return;
    }

    widget.onCoinDeduct(_totalCost);
    _urlController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kampanya Başarıyla Eklendi! 🎉'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          const Text('Yeni Kampanya Oluştur', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          TextField(
            controller: _urlController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'YouTube Video Linkini Yapıştırın',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1F1F1F),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              prefixIcon: const Icon(Icons.link, color: Colors.red),
            ),
          ),
          const SizedBox(height: 20),
          _settingDropdown('İzlenme Sayısı Seç', [10, 50, 100, 500], _targetViews, (val) {
            setState(() => _targetViews = val!);
          }),
          const SizedBox(height: 15),
          _settingDropdown('İzlenme Süresi (Saniye)', [60, 90, 120, 180], _targetSeconds, (val) {
            setState(() => _targetSeconds = val!);
          }),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Toplam Maliyet:', style: TextStyle(color: Colors.white, fontSize: 16)),
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red, size: 20),
                    const SizedBox(width: 5),
                    Text('$_totalCost Puan', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _createCampaign,
              child: const Text('Kampanyayı Başlat', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingDropdown(String title, List<int> options, int currentValue, ValueChanged<int?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: currentValue,
              dropdownColor: const Color(0xFF1F1F1F),
              isExpanded: true,
              style: const TextStyle(color: Colors.white),
              items: options.map((int val) {
                return DropdownMenuItem<int>(
                  value: val,
                  child: Text('$val'),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
