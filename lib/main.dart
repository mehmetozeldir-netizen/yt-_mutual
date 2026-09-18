import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const YtMutualApp());
}

class YtMutualApp extends StatelessWidget {
  const YtMutualApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yt Mutual',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.red,
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 1; 
  int _userCoins = 178;
  bool _isAutoPlay = false;

  final List<Map<String, dynamic>> _campaigns = [
    {
      'title': 'Klip Tanıtım Projesi',
      'type': 'İzlenme',
      'current': 12,
      'target': 40,
      'thumbnail': 'https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
    }
  ];

  void updateCoins(int amount) {
    setState(() {
      _userCoins += amount;
    });
  }

  void addCampaign(Map<String, dynamic> newCamp) {
    setState(() {
      _campaigns.insert(0, newCamp);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      CampaignsScreen(
        campaigns: _campaigns,
        userCoins: _userCoins,
        onAddCampaign: addCampaign,
        onDeductCoins: updateCoins,
      ),
      WatchScreen(
        userCoins: _userCoins, 
        onRewardEarned: updateCoins, 
        isAutoPlay: _isAutoPlay, 
        onToggleAuto: (val) => setState(() => _isAutoPlay = val),
      ),
      const SubscribeScreen(),
      const LikesScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'yt mutual', 
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: -0.5),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text('$_userCoins', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(width: 6),
                  const Icon(Icons.favorite, color: Colors.red, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Kampanya'),
          BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: 'İzle'),
          BottomNavigationBarItem(icon: Icon(Icons.subscriptions), label: 'Abone Ol'),
          BottomNavigationBarItem(icon: Icon(Icons.thumb_up), label: 'Beğen'),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Ahmet Akın', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 4),
                    Text('akina6126@gmail.com', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          _drawerItem(Icons.favorite_border, 'Puan Satın Al'),
          _drawerItem(Icons.verified_outlined, 'VIP Üye Ol'),
          _drawerItem(Icons.card_giftcard, 'Salla & Kazan'),
          _drawerItem(Icons.help_outline, 'Sıkça Sorulan Sorular'),
          _drawerItem(Icons.privacy_tip_outlined, 'Gizlilik Politikası'),
          _drawerItem(Icons.share_outlined, 'Uygulamayı Paylaş'),
          _drawerItem(Icons.star_border, 'Uygulamayı Değerlendir'),
          _drawerItem(Icons.chat_bubble_outline, 'Bize Ulaşın'),
          _drawerItem(Icons.logout, 'Çıkış yap'),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Sürüm: 3.4.21', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      onTap: () {},
    );
  }
}

class WatchScreen extends StatefulWidget {
  final int userCoins;
  final Function(int) onRewardEarned;
  final bool isAutoPlay;
  final Function(bool) onToggleAuto;

  const WatchScreen({
    super.key, 
    required this.userCoins, 
    required this.onRewardEarned, 
    required this.isAutoPlay, 
    required this.onToggleAuto,
  });

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  int timeLeft = 61;
  Timer? _timer;
  bool isRunning = false;

  void startTimer() {
    if (isRunning) return;
    setState(() => isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 1) {
        setState(() => timeLeft--);
      } else {
        timer.cancel();
        setState(() {
          isRunning = false;
          timeLeft = 61;
        });
        widget.onRewardEarned(48);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tebrikler! +48 Puan eklendi.')));
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('Otomatik', style: TextStyle(fontSize: 15, color: Colors.black87)),
                  const SizedBox(width: 8),
                  Switch(
                    value: widget.isAutoPlay,
                    activeColor: Colors.red,
                    onChanged: widget.onToggleAuto,
                  ),
                ],
              ),
              IconButton(icon: const Icon(Icons.info_outline, color: Colors.black54), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, spreadRadius: 2)],
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Image.network('https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg', fit: BoxFit.cover),
                    ),
                    const Icon(Icons.play_circle_fill, color: Colors.red, size: 64),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.favorite, color: Colors.black87, size: 20),
                              SizedBox(width: 6),
                              Text('48', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Text('Puan', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.timer_outlined, color: Colors.black87, size: 20),
                              const SizedBox(width: 6),
                              Text('$timeLeft', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Text('Saniye', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      onPressed: isRunning ? null : startTimer,
                      child: Text(
                        isRunning ? 'Süre İşliyor ($timeLeft sn)...' : 'Değiştir', 
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubscribeScreen extends StatelessWidget {
  const SubscribeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Abone Ol Modülü', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

class LikesScreen extends StatelessWidget {
  const LikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Beğen Modülü', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

class CampaignsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> campaigns;
  final int userCoins;
  final Function(Map<String, dynamic>) onAddCampaign;
  final Function(int) onDeductCoins;

  const CampaignsScreen({
    super.key, 
    required this.campaigns, 
    required this.userCoins, 
    required this.onAddCampaign, 
    required_onDeductCoins,
  }) : onDeductCoins = _onDeductCoins;

  final Function(int) _onDeductCoins;

  void _openCreateDialog(BuildContext context) {
    final urlController = TextEditingController();
    int viewCount = 25;
    int duration = 60;
    int totalCost = 1500;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Kampanya Oluştur', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text('$userCoins', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 4),
                        const Icon(Icons.favorite, color: Colors.red, size: 18),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    '• Aynı video için çok sayıda kampanya oluşturmayın.\n• Kampanyaların YT\'a yansıması 72 saati bulabilir.\n• Politikaya aykırı kampanyalar silinir.\n• Detaylı analiz için YT Studio uygulamasını kullanın.\n• Kampanyaların tamamlanma süresi değişkenlik gösterebilir.',
                    style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.4),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    labelText: 'Video Bağlantı Adresi',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.play_arrow, color: Colors.red),
                      onPressed: () {},
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Kampanya Ayarları', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('İzlenme Sayısı'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                      child: Text('$viewCount', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gereken Süre (sn.)'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                      child: Text('$duration', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Toplam Tutar', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text('$totalCost', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 4),
                        const Icon(Icons.favorite, color: Colors.red, size: 18),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                    onPressed: () {
                      if (userCoins < totalCost) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yetersiz Puan!')));
                        return;
                      }
                      onDeductCoins(-totalCost);
                      onAddCampaign({
                        'title': 'Yeni YouTube Kampanyası',
                        'type': 'İzlenme',
                        'current': 0,
                        'target': viewCount,
                        'thumbnail': 'https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kampanya başarıyla oluşturuldu!')));
                    },
                    child: const Text('Oluştur', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Oluştur', style: TextStyle(color: Colors.white)),
                onPressed: () => _openCreateDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: campaigns.length,
              itemBuilder: (context, index) {
                final camp = campaigns[index];
                double progress = camp['target'] > 0 ? camp['current'] / camp['target'] : 0.0;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(camp['thumbnail'], width: 80, height: 50, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${camp['title']} (${camp['type']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(value: progress, color: Colors.red, backgroundColor: Colors.grey.shade200),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('İlerleme: ${camp['current']} / ${camp['target']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                const Text('Aktif', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 11)),
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
