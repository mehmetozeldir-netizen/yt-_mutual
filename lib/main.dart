import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const YtLoveApp());
}

class YtLoveApp extends StatelessWidget {
  const YtLoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YT Mutual - YT Love',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFF0000),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF0000),
          secondary: Color(0xFFFFD700),
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// Global Uygulama Durumu (Model & Data)
class Campaign {
  final String id;
  final String videoUrl;
  final String videoId;
  final String type; // Views, Likes, Subscribers
  final int targetCount;
  int currentCount;
  final int targetDuration;

  Campaign({
    required this.id,
    required this.videoUrl,
    required this.videoId,
    required this.type,
    required this.targetCount,
    this.currentCount = 0,
    required this.targetDuration,
  });
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  int _userCoins = 600; // Başlangıç Jetonu
  
  final List<Campaign> _activeCampaigns = [];

  void _addCoins(int amount) {
    setState(() {
      _userCoins += amount;
    });
  }

  bool _deductCoins(int amount) {
    if (_userCoins >= amount) {
      setState(() {
        _userCoins -= amount;
      });
      return true;
    }
    return false;
  }

  void _addCampaign(Campaign campaign) {
    setState(() {
      _activeCampaigns.add(campaign);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      EarnCoinsScreen(onCoinsEarned: _addCoins),
      CampaignsScreen(
        campaigns: _activeCampaigns,
        userCoins: _userCoins,
        onDeductCoins: _deductCoins,
        onCampaignCreated: _addCampaign,
      ),
      StoreScreen(userCoins: _userCoins, onBuyCoins: _addCoins),
      ProfileScreen(userCoins: _userCoins),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        title: Row(
          children: [
            const Icon(Icons.play_circle_fill, color: Colors.red, size: 28),
            const SizedBox(width: 8),
            const Text(
              'YT Mutual',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                const SizedBox(width: 6),
                Text(
                  '$_userCoins',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1F1F1F),
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.ondemand_video),
            label: 'İzle & Kazan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Kampanya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Jeton Al',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 1. İZLE & KAZAN EKRANI (Video Watch Screen)
// -----------------------------------------------------------------------------
class EarnCoinsScreen extends StatefulWidget {
  final Function(int) onCoinsEarned;

  const EarnCoinsScreen({super.key, required this.onCoinsEarned});

  @override
  State<EarnCoinsScreen> createState() => _EarnCoinsScreenState();
}

class _EarnCoinsScreenState extends State<EarnCoinsScreen> {
  late YoutubePlayerController _ytController;
  
  // Havuzdaki Örnek Videolar
  final List<Map<String, dynamic>> _videoPool = [
    {'id': 'dQw4w9WgXcQ', 'duration': 60, 'reward': 60},
    {'id': '3JZ_D3ELwOQ', 'duration': 90, 'reward': 90},
    {'id': 'L_jWHffIx5E', 'duration': 45, 'reward': 50},
  ];

  int _currentVideoIndex = 0;
  int _timerSeconds = 60;
  int _rewardCoins = 60;
  Timer? _timer;
  bool _isPlaying = false;
  bool _rewardClaimed = false;

  @override
  void initState() {
    super.initState();
    _loadVideo(_currentVideoIndex);
  }

  void _loadVideo(int index) {
    _timer?.cancel();
    final video = _videoPool[index];
    _timerSeconds = video['duration'];
    _rewardCoins = video['reward'];
    _rewardClaimed = false;
    _isPlaying = false;

    _ytController = YoutubePlayerController(
      initialVideoId: video['id'],
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
      ),
    )..addListener(_ytListener);
  }

  void _ytListener() {
    if (_ytController.value.isPlaying && !_isPlaying && !_rewardClaimed) {
      setState(() {
        _isPlaying = true;
      });
      _startTimer();
    } else if (!_ytController.value.isPlaying && _isPlaying) {
      setState(() {
        _isPlaying = false;
      });
      _timer?.cancel();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        _timer?.cancel();
        if (!_rewardClaimed) {
          _rewardClaimed = true;
          widget.onCoinsEarned(_rewardCoins);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tebrikler! +$_rewardCoins Jeton Kazandınız!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    });
  }

  void _nextVideo() {
    _ytController.removeListener(_ytListener);
    _ytController.dispose();
    setState(() {
      _currentVideoIndex = (_currentVideoIndex + 1) % _videoPool.length;
    });
    _loadVideo(_currentVideoIndex);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ytController.removeListener(_ytListener);
    _ytController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: YoutubePlayer(
              controller: _ytController,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainSystems.spaceAround,
            children: [
              _infoBox(
                icon: Icons.timer,
                color: Colors.blueAccent,
                label: 'Kalan Süre',
                value: '$_timerSeconds sn',
              ),
              _infoBox(
                icon: Icons.monetization_on,
                color: Colors.amber,
                label: 'Kazanç',
                value: '+$_rewardCoins Jeton',
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _nextVideo,
              icon: const Icon(Icons.skip_next),
              label: const Text('Başka Video İzle', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox({required IconData icon, required Color color, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}

// MAINSYSTEM HELPER
class MainSystems {
  static const MainAxisAlignment spaceAround = MainAxisAlignment.spaceAround;
}

// -----------------------------------------------------------------------------
// 2. KAMPANYA LİSTESİ VE KAMPANYA OLUŞTURMA (YT LOVE CLONE)
// -----------------------------------------------------------------------------
class CampaignsScreen extends StatelessWidget {
  final List<Campaign> campaigns;
  final int userCoins;
  final bool Function(int) onDeductCoins;
  final Function(Campaign) onCampaignCreated;

  const CampaignsScreen({
    super.key,
    required this.campaigns,
    required this.userCoins,
    required this.onDeductCoins,
    required this.onCampaignCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: campaigns.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.campaign_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Henüz aktif bir kampanyanız yok.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  Text(
                    'Aşağıdaki + butonuna basarak kampanya ekleyin.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: campaigns.length,
              itemBuilder: (context, index) {
                final camp = campaigns[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: const Color(0xFF1E1E1E),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.redAccent.withOpacity(0.2),
                      child: Icon(
                        camp.type == 'Views'
                            ? Icons.remove_red_eye
                            : camp.type == 'Likes'
                                ? Icons.thumb_up
                                : Icons.person_add,
                        color: Colors.redAccent,
                      ),
                    ),
                    title: Text('${camp.type} Kampanyası', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: camp.targetCount > 0 ? camp.currentCount / camp.targetCount : 0,
                          backgroundColor: Colors.grey[800],
                          color: Colors.redAccent,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'İlerleme: ${camp.currentCount} / ${camp.targetCount} (${camp.targetDuration} sn)',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCampaignScreen(
                userCoins: userCoins,
                onDeductCoins: onDeductCoins,
                onCampaignCreated: onCampaignCreated,
              ),
            ),
          );
        },
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Kampanya Oluştur', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// KAMPANYA OLUŞTURMA DETAY SAYFASI (YT LOVE BİREBİR ARAYÜZÜ)
// -----------------------------------------------------------------------------
class CreateCampaignScreen extends StatefulWidget {
  final int userCoins;
  final bool Function(int) onDeductCoins;
  final Function(Campaign) onCampaignCreated;

  const CreateCampaignScreen({
    super.key,
    required this.userCoins,
    required this.onDeductCoins,
    required this.onCampaignCreated,
  });

  @override
  State<CreateCampaignScreen> createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
  final TextEditingController _urlController = TextEditingController();
  
  String _selectedType = 'Views'; // Views, Likes, Subscribers
  int _targetCount = 10;
  int _targetDuration = 60; // saniye
  String? _validatedVideoId;
  bool _isVideoValidated = false;

  // YT Love Maliyet Hesaplama Algoritması
  int get _totalCost {
    int baseRate = 1;
    if (_selectedType == 'Likes') baseRate = 2;
    if (_selectedType == 'Subscribers') baseRate = 3;
    
    return _targetCount * (_targetDuration ~/ 60) * 60 * baseRate;
  }

  void _validateAndLoadVideo() {
    final url = _urlController.text.trim();
    final videoId = YoutubePlayer.convertUrlToId(url);

    if (videoId != null && videoId.isNotEmpty) {
      setState(() {
        _validatedVideoId = videoId;
        _isVideoValidated = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video Başarıyla Doğrulandı!'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçersiz YouTube Video Bağlantısı!'), backgroundColor: Colors.red),
      );
    }
  }

  void _submitCampaign() {
    if (!_isVideoValidated || _validatedVideoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen önce geçerli bir video URL doğrulayın.'), backgroundColor: Colors.orange),
      );
      return;
    }

    final cost = _totalCost;
    if (widget.userCoins < cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yetersiz Bakiye! Gereken: $cost Jeton, Mevcut: ${widget.userCoins} Jeton'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Jeton Düş ve Kampanyayı Kaydet
    final success = widget.onDeductCoins(cost);
    if (success) {
      final newCampaign = Campaign(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        videoUrl: _urlController.text.trim(),
        videoId: _validatedVideoId!,
        type: _selectedType,
        targetCount: _targetCount,
        targetDuration: _targetDuration,
      );

      widget.onCampaignCreated(newCampaign);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kampanya Başarıyla Oluşturuldu ve Yayına Alındı!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kampanya Oluştur'),
        backgroundColor: const Color(0xFF1F1F1F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. URL Giriş Alanı
            const Text('YouTube Video Linki', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: 'https://www.youtube.com/watch?v=...',
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _validateAndLoadVideo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  ),
                  child: const Text('Ekle', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Video Önizleme Kartı
            if (_isVideoValidated && _validatedVideoId != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Image.network(
                      'https://img.youtube.com/vi/$_validatedVideoId/hqdefault.jpg',
                      width: 100,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Video Onaylandı. Kampanya Ayarlarını Seçin.',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

            // 2. Kampanya Tipi Seçimi
            const Text('Kampanya Tipi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                _typeChip('Views', 'İzlenme', Icons.remove_red_eye),
                const SizedBox(width: 8),
                _typeChip('Likes', 'Beğeni', Icons.thumb_up),
                const SizedBox(width: 8),
                _typeChip('Subscribers', 'Abone', Icons.person_add),
              ],
            ),
            const SizedBox(height: 20),

            // 3. Hedef Miktar Seçimi
            const Text('Hedef Sayı (Miktar)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _targetCount,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
              items: [10, 50, 100, 500, 1000].map((count) {
                return DropdownMenuItem<int>(
                  value: count,
                  child: Text('$count Hedef'),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _targetCount = val);
              },
            ),
            const SizedBox(height: 20),

            // 4. Hedef Süre Seçimi
            const Text('Gerekli İzlenme Süresi (Saniye)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _targetDuration,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
              items: [45, 60, 90, 120, 180, 300].map((sec) {
                return DropdownMenuItem<int>(
                  value: sec,
                  child: Text('$sec Saniye'),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _targetDuration = val);
              },
            ),
            const SizedBox(height: 30),

            // 5. Toplam Maliyet & Buton
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Toplam Maliyet:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text(
                        '$_totalCost Jeton',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitCampaign,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('KAMPANYAYI BAŞLAT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeChip(String type, String label, IconData icon) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.redAccent : const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? Colors.redAccent : Colors.white12),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. MAĞAZA EKRANI (Store Screen)
// -----------------------------------------------------------------------------
class StoreScreen extends StatelessWidget {
  final int userCoins;
  final Function(int) onBuyCoins;

  const StoreScreen({super.key, required this.userCoins, required this.onBuyCoins});

  @override
  Widget build(BuildContext context) {
    final packages = [
      {'coins': 1500, 'price': '19.99 TL'},
      {'coins': 5000, 'price': '49.99 TL'},
      {'coins': 12000, 'price': '99.99 TL'},
      {'coins': 30000, 'price': '229.99 TL'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final pack = packages[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: const Color(0xFF1E1E1E),
          child: ListTile(
            leading: const Icon(Icons.monetization_on, color: Colors.amber, size: 32),
            title: Text('${pack['coins']} Jeton', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            trailing: ElevatedButton(
              onPressed: () {
                onBuyCoins(pack['coins'] as int);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${pack['coins']} Jeton hesabınıza eklendi!'), backgroundColor: Colors.green),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
              child: Text(pack['price'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// 4. PROFİL EKRANI (Profile Screen)
// -----------------------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  final int userCoins;

  const ProfileScreen({super.key, required this.userCoins});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.redAccent,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text('Kullanıcı', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Card(
            color: const Color(0xFF1E1E1E),
            child: ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.amber),
              title: const Text('Mevcut Bakiye'),
              trailing: Text('$userCoins Jeton', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber)),
            ),
          ),
        ],
      ),
    );
  }
}
