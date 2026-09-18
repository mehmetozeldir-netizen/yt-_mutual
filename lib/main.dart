import 'package:flutter/material.dart';
import 'campaign_sheet.dart';
import 'shake_to_win_screen.dart';

void main() {
  runApp(const YtMutualApp());
}

class YtMutualApp extends StatelessWidget {
  const YtMutualApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yt Mutual',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int userPoints = 178;
  int _selectedIndex = 1; // Varsayılan: İzle Sekmesi
  bool isAutomatic = false;

  void _onItemTapped(int index) {
    if (index == 0) {
      // Kampanya sekmesine tıklandığında alt menüyü aç
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => const CampaignBottomSheet(),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.notes, color: Colors.black87, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          "Yt Mutual",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              Text(
                "$userPoints",
                style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.favorite, color: Colors.red, size: 22),
              const SizedBox(width: 16),
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Kayıtlı YT Hesabı"),
              accountEmail: Text("Giriş Yapıldı"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.red),
              ),
              decoration: BoxDecoration(color: Colors.redAccent),
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.orange),
              title: const Text("VIP Üye Ol"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.vibration, color: Colors.blue),
              title: const Text("Salla Kazan"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShakeToWinScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const SizedBox(), // Index 0: Modal Sheet Açılır
          _buildWatchTab(), // Index 1: İzle Sekmesi
          _buildSubscribeTab(), // Index 2: Abone Ol Sekmesi
          _buildLikeTab(), // Index 3: Beğen Sekmesi
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

  // 1. İZLE SEKMESİ (Görseldeki Birebir Tasarım)
  Widget _buildWatchTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      onChanged: (val) {
                        setState(() {
                          isAutomatic = val;
                        });
                      },
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.error_outline, color: Colors.black54),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 12,
                    left: 12,
                    right: 12,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "How to Make Money on Amazon",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Gift makumbi biye",
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.play_arrow_rounded, color: Colors.red, size: 64),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Text("İzlemek için: ", style: TextStyle(color: Colors.white, fontSize: 11)),
                          Icon(Icons.play_collection_fill, color: Colors.red, size: 14),
                          SizedBox(width: 2),
                          Text("YouTube", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(Icons.favorite, color: Colors.black87, size: 28),
                    ),
                    const SizedBox(height: 6),
                    const Text("48", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const Text("Puan", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(Icons.timer_outlined, color: Colors.black87, size: 28),
                    ),
                    const SizedBox(height: 6),
                    const Text("61", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const Text("Saniye", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
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

  // 2. ABONE OL SEKMESİ (Görseldeki Birebir Tasarım)
  Widget _buildSubscribeTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black12),
              ),
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
                            onChanged: (val) {
                              setState(() {
                                isAutomatic = val;
                              });
                            },
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.error_outline, color: Colors.black54),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F0E26),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.sports_esports, size: 70, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "GMR Himanshu",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Icon(Icons.favorite, color: Colors.black87, size: 28),
                          ),
                          const SizedBox(height: 6),
                          const Text("210", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const Text("Puan", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Icon(Icons.timer_outlined, color: Colors.black87, size: 28),
                          ),
                          const SizedBox(height: 6),
                          const Text("60", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const Text("Saniye", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF4B4B),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          onPressed: () {},
                          child: const Text("Abone Ol", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          onPressed: () {},
                          child: const Text("Değiştir", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.black54, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Kullandığınız hesap, YT hesabınızla aynı olmalıdır.",
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const Center(
                child: Text("Unity Ads Reklam Alanı", style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. BEĞEN SEKMESİ
  Widget _buildLikeTab() {
    return const Center(
      child: Text("Beğen Ekranı Yakında Eklenecek", style: TextStyle(fontSize: 16, color: Colors.grey)),
    );
  }
}
