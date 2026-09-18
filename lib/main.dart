import 'package:flutter/material.dart';

void main() {
  runApp(const YtMutualApp());
}

class YtMutualApp extends StatefulWidget {
  const YtMutualApp({Key? key}) : super(key: key);

  @override
  State<YtMutualApp> createState() => _YtMutualAppState();
}

class _YtMutualAppState extends State<YtMutualApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yt Mutual',
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.black87),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF121212), foregroundColor: Colors.white),
        useMaterial3: true,
      ),
      home: HomeScreen(onToggleTheme: toggleTheme, isDarkMode: isDarkMode),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({Key? key, required this.onToggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int userPoints = 178;
  int _selectedIndex = 1;
  bool isAutomatic = false;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateCampaignScreen(userPoints: userPoints)),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.notes, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          "Yt Mutual",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              Text(
                "$userPoints",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.favorite, color: Colors.red, size: 22),
              const SizedBox(width: 16),
            ],
          )
        ],
      ),
      drawer: _buildCustomDrawer(context),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const SizedBox(),
          _buildWatchTab(),
          _buildSubscribeTab(),
          _buildLikeTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Kampanya"),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: "İzle"),
          BottomNavigationBarItem(icon: Icon(Icons.subscriptions), label: "Abone Ol"),
          BottomNavigationBarItem(icon: Icon(Icons.thumb_up), label: "Beğen"),
        ],
      ),
    );
  }

  // GÖRSELDEKİ BİREBİR YAN MENÜ (DRAWER)
  Widget _buildCustomDrawer(BuildContext context) {
    bool dark = widget.isDarkMode;
    Color iconColor = dark ? Colors.white70 : Colors.black87;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Üst Simgeler
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.manage_accounts_outlined, color: iconColor, size: 26),
                    onPressed: () {
                      _showSnackBar("Hesap Yönetimi");
                    },
                  ),
                  IconButton(
                    icon: Icon(dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: iconColor, size: 26),
                    onPressed: widget.onToggleTheme,
                  ),
                  IconButton(
                    icon: Icon(Icons.logout_rounded, color: iconColor, size: 26),
                    onPressed: () => _confirmLogout(context),
                  ),
                ],
              ),
            ),

            // Profil Bilgisi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        "A",
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Ahmet Akın",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "akina6126@gmail.com",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(height: 24),
            ),

            // Menü Elemanları
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerItem(
                    icon: Icons.favorite_border,
                    title: "Puan Satın Al",
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar("Puan Satın Al ekranı açılıyor");
                    },
                  ),
                  _drawerItem(
                    icon: Icons.verified_outlined,
                    title: "VIP Üye Ol",
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar("VIP Üyelik ekranı açılıyor");
                    },
                  ),
                  _drawerItem(
                    icon: Icons.sentiment_satisfied_alt_outlined,
                    title: "Salla & Kazan",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ShakeToWinScreen()),
                      );
                    },
                  ),
                  _drawerItem(
                    icon: Icons.help_outline,
                    title: "Sıkça Sorulan Sorular",
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar("SSS sayfası açılıyor");
                    },
                  ),
                  _drawerItem(
                    icon: Icons.info_outline,
                    title: "Gizlilik Politikası",
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar("Gizlilik Politikası gösteriliyor");
                    },
                  ),
                  _drawerItem(
                    icon: Icons.share_outlined,
                    title: "Uygulamayı Paylaş",
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar("Uygulama paylaşım bağlantısı oluşturuldu");
                    },
                  ),
                  _drawerItem(
                    icon: Icons.star_outline,
                    title: "Uygulamayı Değerlendir",
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar("Google Play Mağazasına yönlendiriliyor");
                    },
                  ),
                  _drawerItem(
                    icon: Icons.chat_bubble_outline,
                    title: "Bize Ulaşın",
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar("Destek hattı: destek@harbyapps.com");
                    },
                  ),
                  _drawerItem(
                    icon: Icons.logout,
                    title: "Çıkış yap",
                    onTap: () {
                      Navigator.pop(context);
                      _confirmLogout(context);
                    },
                  ),
                ],
              ),
            ),

            // Alt Bilgi / Sürüm ve Logo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sürüm: 3.4.21",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Row(
                    children: const [
                      Text(
                        "härby",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                      ),
                      Icon(Icons.favorite, color: Colors.red, size: 14),
                      Text(
                        "apps",
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: widget.isDarkMode ? Colors.white70 : Colors.black87, size: 24),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Çıkış Yap"),
        content: const Text("Hesabınızdan çıkış yapmak istediğinize emin misiniz?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar("Çıkış Yapıldı");
            },
            child: const Text("Çıkış", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 1. İZLE SEKMESİ
  Widget _buildWatchTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text("Otomatik", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(width: 8),
                    Switch(
                      value: isAutomatic,
                      activeColor: Colors.red,
                      onChanged: (val) => setState(() => isAutomatic = val),
                    ),
                  ],
                ),
                IconButton(icon: const Icon(Icons.error_outline), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Icon(Icons.play_arrow_rounded, color: Colors.red, size: 64)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statBox(Icons.favorite, "48", "Puan"),
                _statBox(Icons.timer_outlined, "61", "Saniye"),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {},
                child: const Text("Değiştir", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. ABONE OL SEKMESİ
  Widget _buildSubscribeTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(color: const Color(0xFF0F0E26), borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.sports_esports, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text("GMR Himanshu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statBox(Icons.favorite, "210", "Puan"),
                      _statBox(Icons.timer_outlined, "60", "Saniye"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4B4B)),
                          onPressed: () {},
                          child: const Text("Abone Ol", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                          onPressed: () {},
                          child: const Text("Değiştir", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. BEĞEN SEKMESİ
  Widget _buildLikeTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                children: [
                  Container(
                    height: 160,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
                    child: const Center(child: Icon(Icons.thumb_up_alt_rounded, color: Colors.red, size: 54)),
                  ),
                  const SizedBox(height: 12),
                  const Text("Harika Bir YouTube Videosu", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statBox(Icons.favorite, "150", "Puan"),
                      _statBox(Icons.timer_outlined, "45", "Saniye"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4B4B)),
                          onPressed: () {},
                          child: const Text("Beğen", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                          onPressed: () {},
                          child: const Text("Değiştir", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBox(IconData icon, String val, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
          child: Icon(icon, size: 24),
        ),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }
}

// KAMPANYA OLUŞTURMA EKRANI
class CreateCampaignScreen extends StatefulWidget {
  final int userPoints;
  const CreateCampaignScreen({Key? key, required this.userPoints}) : super(key: key);

  @override
  State<CreateCampaignScreen> createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
  int campaignType = 0;
  int selectedViews = 25;
  int selectedDuration = 60;

  @override
  Widget build(BuildContext context) {
    int totalCost = selectedViews * selectedDuration;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text("Kampanya Oluştur"),
        actions: [
          Row(
            children: [
              Text("${widget.userPoints}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(width: 4),
              const Icon(Icons.favorite, color: Colors.red, size: 22),
              const SizedBox(width: 16),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("• Aynı video için çok sayıda kampanya oluşturmayın.", style: TextStyle(color: Colors.white, fontSize: 12)),
                  Text("• Kampanyaların YT'a yansıması 72 saati bulabilir.", style: TextStyle(color: Colors.white, fontSize: 12)),
                  Text("• Politikaya aykırı kampanyalar silinir.", style: TextStyle(color: Colors.white, fontSize: 12)),
                  Text("• Detaylı analiz için YT Studio uygulamasını kullanın.", style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Toplam Tutar", style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Text("$totalCost", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Icon(Icons.favorite, color: Colors.red),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(context),
                child: const Text("Oluştur", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SALLA KAZAN EKRANI
class ShakeToWinScreen extends StatelessWidget {
  const ShakeToWinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Salla & Kazan"), backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sentiment_satisfied_alt_outlined, size: 100, color: Colors.redAccent),
            const SizedBox(height: 20),
            const Text("Hediyeni Almak İçin Telefonu Salla!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tebrikler! 50 Puan Kazandınız.")));
              },
              child: const Text("Salla & Puan Kazan", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
