import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const YtLoveApp());
}

class YtLoveApp extends StatelessWidget {
  const YtLoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YtLove Pro',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.red,
      ),
      home: const YtLoveHomeScreen(),
    );
  }
}

class YtLoveHomeScreen extends StatefulWidget {
  const YtLoveHomeScreen({super.key});

  @override
  State<YtLoveHomeScreen> createState() => _YtLoveHomeScreenState();
}

class _YtLoveHomeScreenState extends State<YtLoveHomeScreen> {
  int _currentIndex = 0;
  int _userCoins = 850;

  final List<CampaignItem> _userCampaigns = [
    Klip Tanıtım Projesiani(
      title: 'Klip Tanıtım Projesi',
      type: 'İzlenme',
      current: 12,
      target: 40,
      thumbnail: 'https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
    ),
  ];

  void updateCoins(int amount) {
    setState(() {
      _userCoins += amount;
    });
  }

  void addCampaign(String title, String type, int target) {
    setState(() {
      _userCampaigns.insert(
        0,
        Klip Tanıtım Projesiani(
          title: title,
          type: type,
          current: 0,
          target: target,
          thumbnail: 'https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      TaskListView(category: 'views', title: 'İzle & Kazan', reward: 60, duration: 45, onRewardEarned: updateCoins),
      TaskListView(category: 'subs', title: 'Abone Ol & Kazan', reward: 90, duration: 30, onRewardEarned: updateCoins),
      TaskListView(category: 'likes', title: 'Beğen & Kazan', reward: 40, duration: 20, onRewardEarned: updateCoins),
      CampaignsView(campaigns: _userCampaigns, userCoins: _userCoins, onAddCampaign: addCampaign, onDeductCoins: updateCoins),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 1,
        title: const Text('YtLove Pro', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                const SizedBox(width: 6),
                Text('$_userCoins', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF1A1A1A),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: 'İzle'),
          BottomNavigationBarItem(icon: Icon(Icons.subscriptions), label: 'Abone Ol'),
          BottomNavigationBarItem(icon: Icon(Icons.thumb_up), label: 'Beğen'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Kampanyalar'),
        ],
      ),
    );
  }
}

class Klip Tanıtım Projesiani {
  final String title;
  final String type;
  int current;
  final int target;
  final String thumbnail;

  Klip Tanıtım Projesiani({
    required this.title,
    required this.type,
    required this.current,
    required this.target,
    required this.thumbnail,
  });
}

class TaskItemData {
  final String title;
  final int duration;
  final int reward;
  final String videoId;

  TaskItemData({required this.title, required this.duration, required this.reward, required this.videoId});
}

class TaskListView extends StatefulWidget {
  final String category;
  final String title;
  final int reward;
  final int duration;
  final Function(int) onRewardEarned;

  const TaskListView({
    super.key,
    required this.category,
    required this.title,
    required this.reward,
    required this.duration,
    required this.onRewardEarned,
  });

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final Map<int, bool> _completedTasks = {};
  final Map<int, int> _activeTimers = {};
  final Map<int, Timer?> _timers = {};

  final List<TaskItemData> tasks = [
    TaskItemData(title: 'Özgürlük ve Müzik Klip Projesi', duration: 45, reward: 60, videoId: 'dQw4w9WgXcQ'),
    TaskItemData(title: 'Akustik Gitar Solo & Melodi', duration: 30, reward: 45, videoId: '3JZ_D3ELwOQ'),
    TaskItemData(title: 'Stüdyo Kayıt Günlükleri', duration: 40, reward: 55, videoId: 'kJQP7kiw5Fk'),
  ];

  void startTaskTimer(int index) {
    setState(() {
      _activeTimers[index] = widget.duration;
    });

    _timers[index]?.cancel();
    _timers[index] = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_activeTimers[index]! > 1) {
        setState(() {
          _activeTimers[index] = _activeTimers[index]! - 1;
        });
      } else {
        timer.cancel();
        setState(() {
          _activeTimers.remove(index);
          _completedTasks[index] = true;
        });
        widget.onRewardEarned(widget.reward);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tebrikler! +${widget.reward} Coin hesabınıza eklendi.')),
        );
      }
    });
  }

  @override
  void dispose() {
    for (var timer in _timers.values) {
      timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isCompleted = _completedTasks[index] ?? false;
        final activeTime = _activeTimers[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF333333)),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.black,
                    child: Image.network(
                      'https://img.youtube.com/vi/${task.videoId}/hqdefault.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.videocam, color: Colors.grey, size: 40)),
                    ),
                  ),
                  if (activeTime != null)
                    Container(
                      height: 180,
                      color: Colors.black87,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$activeTime',
                              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.amber),
                            ),
                            const SizedBox(height: 4),
                            const Text('Süre Bitiyor, Lütfen Bekleyin...', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Text('Ödül: ', style: TextStyle(color: Colors.grey, fontSize: 13)),
                              Text('+${widget.reward} Coin', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCompleted ? Colors.grey.shade800 : Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: (isCompleted || activeTime != null) ? null : () => startTaskTimer(index),
                      child: Text(
                        isCompleted ? 'Tamamlandı' : 'İzle & Kazan',
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CampaignsView extends StatelessWidget {
  final List<Klip Tanıtım Projesiani> campaigns;
  final int userCoins;
  final Function(String, String, int) onAddCampaign;
  final Function(int) onDeductCoins;

  const CampaignsView({
    super.key,
    required this.campaigns,
    required this.userCoins,
    required this.onAddCampaign,
    required this.onDeductCoins,
  });

  void _showCreateDialog(BuildContext context) {
    final urlController = TextEditingController();
    String selectedType = 'İzlenme';
    int targetCount = 20;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F1F1F),
          title: const Text('Yeni Kampanya Oluştur', style: TextStyle(fontSize: 16, color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: urlController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  labelText: 'YouTube Video URL',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                dropdownColor: const Color(0xFF2C2C2C),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Kampanya Türü', labelStyle: TextStyle(color: Colors.grey)),
                items: ['İzlenme', 'Abone', 'Beğeni'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList,
                onChanged: (val) => selectedType = val!,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                if (urlController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen geçerli bir URL girin.')));
                  return;
                }
                if (userCoins < 100) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yetersiz bakiye! En az 100 coin gerekiyor.')));
                  return;
                }
                onDeductCoins(-100);
                onAddCampaign('YouTube $selectedType Kampanyası', selectedType, targetCount);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kampanya başarıyla başlatıldı!')));
              },
              child: const Text('Başlat (100 Coin)', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kampanyalarım', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Oluştur'),
                onPressed: () => _showCreateDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: campaigns.length,
              itemBuilder: (context, index) {
                final camp = campaigns[index];
                double progress = camp.target > 0 ? camp.current / camp.target : 0.0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF333333)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(camp.thumbnail, width: 80, height: 50, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${camp.title} (${camp.type})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: progress,
                              color: Colors.red,
                              backgroundColor: Colors.grey.shade800,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('İlerleme: ${camp.current} / ${camp.target}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                const Text('Aktif', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
