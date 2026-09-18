import 'package:flutter/material.dart';

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
          const SizedBox(), // Index 0: Kampanya Butonu
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

  // 1. İZLE SEKMESİ
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
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.thumb_up_alt_rounded, color: Colors.red, size: 54),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Harika Bir YouTube Videosu",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
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
                          const Text("150", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                          const Text("45", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                          child: const Text("Beğen", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// KAMPANYA OLUŞTURMA EKRANI (BİREBİR ARAYÜZ TASARIMI)
// -----------------------------------------------------------------------------
class CreateCampaignScreen extends StatefulWidget {
  final int userPoints;
  const CreateCampaignScreen({Key? key, required this.userPoints}) : super(key: key);

  @override
  State<CreateCampaignScreen> createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
  int campaignType = 0; // 0: İzlenme, 1: Abone Ol, 2: Beğeni
  int selectedViews = 25;
  int selectedDuration = 60;

  final List<int> viewOptions = [10, 25, 50, 100, 500, 1000];
  final List<int> durationOptions = [45, 60, 90, 120, 180, 300];

  @override
  Widget build(BuildContext context) {
    int totalCost = selectedViews * selectedDuration;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Kampanya Oluştur",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        actions: [
          Row(
            children: [
              Text(
                "${widget.userPoints}",
                style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.favorite, color: Colors.red, size: 22),
              const SizedBox(width: 16),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Siyah Uyarı/Bilgilendirme Kutusu
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("• Aynı video için çok sayıda kampanya oluşturmayın.", style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.4)),
                  Text("• Kampanyaların YT'a yansıması 72 saati bulabilir.", style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.4)),
                  Text("• Politikaya aykırı kampanyalar silinir.", style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.4)),
                  Text("• Detaylı analiz için YT Studio uygulamasını kullanın.", style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.4)),
                  Text("• Kampanyaların tamamlanma süresi değişkenlik gösterebilir.", style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.black26),
            const SizedBox(height: 12),

            // Video Bağlantısı Alma Rehberi
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: const Icon(Icons.help_outline, size: 20, color: Colors.black54),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Video bağlantısı almak için: Videonuzu YT'da açın → Paylaş → Bağlantıyı Kopyala",
                      style: TextStyle(color: Colors.black54, fontSize: 12.5, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Video Bağlantı Adresi Input Alanı
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Video Bağlantı Adresi",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.play_circle_fill, color: Colors.red, size: 24),
                  const SizedBox(width: 8),
                  Container(
                    height: 24,
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Ekle", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // İzlenme / Abone Ol / Beğeni Sekme Seçimi
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => campaignType = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: campaignType == 0 ? Colors.red : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow, color: campaignType == 0 ? Colors.white : Colors.grey, size: 18),
                            const SizedBox(width: 4),
                            Text("İzlenme", style: TextStyle(color: campaignType == 0 ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => campaignType = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: campaignType == 1 ? Colors.red : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.subscriptions, color: campaignType == 1 ? Colors.white : Colors.grey, size: 16),
                            const SizedBox(width: 4),
                            Text("Abone Ol", style: TextStyle(color: campaignType == 1 ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => campaignType = 2),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: campaignType == 2 ? Colors.red : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.thumb_up, color: campaignType == 2 ? Colors.white : Colors.grey, size: 16),
                            const SizedBox(width: 4),
                            Text("Beğeni", style: TextStyle(color: campaignType == 2 ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Kampanya Ayarları
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("Kampanya Ayarları", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),

            // İzlenme Sayısı Seçimi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("İzlenme Sayısı", style: TextStyle(fontSize: 14, color: Colors.black87)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedViews,
                      items: viewOptions.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text("$value", style: const TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => selectedViews = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Gereken Süre Seçimi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Gereken Süre (sn.)", style: TextStyle(fontSize: 14, color: Colors.black87)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedDuration,
                      items: durationOptions.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text("$value", style: const TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => selectedDuration = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Kampanya Maliyeti
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("Kampanya Maliyeti", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Toplam Tutar", style: TextStyle(fontSize: 14, color: Colors.black87)),
                Row(
                  children: [
                    Text("$totalCost", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    const Icon(Icons.favorite, color: Colors.red, size: 20),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Oluştur Butonu
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Kampanya başarıyla oluşturuldu!")),
                  );
                  Navigator.pop(context);
                },
                child: const Text("Oluştur", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SALLA KAZAN EKRANI
// -----------------------------------------------------------------------------
class ShakeToWinScreen extends StatelessWidget {
  const ShakeToWinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Salla Kazan"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.vibration, size: 100, color: Colors.redAccent),
            const SizedBox(height: 24),
            const Text(
              "Hediyeni Almak İçin Telefonu Salla!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tebrikler! 50 Puan Kazandınız.")),
                );
              },
              child: const Text("Salla & Puan Kazan", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
