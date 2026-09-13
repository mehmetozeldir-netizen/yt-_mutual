import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const YtMutualApp());
}

class YtMutualApp extends StatelessWidget {
  const YtMutualApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YT Mutual',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFDC2626),
        scaffoldBackgroundColor: const Color(0xFFDC2626),
      ),
      home: const SplashScreen(),
    );
  }
}

// 1. SPLASH EKRANI
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Container(
                  width: 0,
                  height: 0,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 12, color: Colors.transparent),
                      bottom: BorderSide(width: 12, color: Colors.transparent),
                      left: BorderSide(width: 20, color: Color(0xFFDC2626)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Yt Mutual',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. GİRİŞ EKRANI
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(
              userEmail: account?.email ?? "ytmutual@user.com",
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(userEmail: "ytmutual@user.com"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 85,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Container(
                  width: 0,
                  height: 0,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 12, color: Colors.transparent),
                      bottom: BorderSide(width: 12, color: Colors.transparent),
                      left: BorderSide(width: 20, color: Color(0xFFDC2626)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Yt Mutual',
              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Kanalınız için daha fazla abone, beğeni ve izlenme kazanın.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.fromLTRB(25, 35, 25, 25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _handleGoogleSignIn,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('🌐', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 10),
                          Text(
                            'Google ile Giriş Yap',
                            style: TextStyle(
                              color: Color(0xFF374151),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Devam ederek Yt Mutual kullanım koşullarını kabul etmiş olursunuz.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 11, height: 1.5),
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

// 3. EKRAN GÖRÜNTÜSÜNDEKİ BİREBİR PANELLER
class DashboardScreen extends StatefulWidget {
  final String userEmail;
  const DashboardScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _puan = 178; // Ekran görüntüsündeki başlangıç puanı
  bool _otomatikMod = false;
  int _seciliTab = 1; // 0: Kampanya, 1: İzle, 2: Abone Ol, 3: Beğen

  @override
  void initState() {
    super.initState();
    _puaniYukle();
  }

  Future<void> _puaniYukle() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _puan = prefs.getInt('kullanici_puani_${widget.userEmail}') ?? 178;
    });
  }

  Future<void> _puanKaydet(int yeniPuan) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('kullanici_puani_${widget.userEmail}', yeniPuan);
    setState(() {
      _puan = yeniPuan;
    });
  }

  void _gorevTamamla() {
    int yeniBakiye = _puan + 48; // Ekran görüntüsündeki video başına ödül
    _puanKaydet(yeniBakiye);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tebrikler! +48 Puan eklendi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        title: const Text(
          'Yt Mutual',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  '$_puan',
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.favorite, color: Colors.red, size: 20),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Üst Otomatik Barı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Otomatik', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    const SizedBox(width: 8),
                    Switch(
                      value: _otomatikMod,
                      activeColor: Colors.red,
                      onChanged: (val) {
                        setState(() {
                          _otomatikMod = val;
                        });
                      },
                    ),
                  ],
                ),
                const Icon(Icons.error_outline, color: Colors.black54),
              ],
            ),
          ),
          
          // Video İzleme Kartı Alanı
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 240,
                        width: double.infinity,
                        color: Colors.black,
                        child: const Center(
                          child: Icon(Icons.play_circle_fill, color: Colors.red, size: 70),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'How to Make Money on Amazon',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                Text(
                                  'Gift makumbi biye',
                                  style: TextStyle(color: Colors.white70, fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Puan ve Süre Sayaç Kartları
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Puan Kutusu
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.favorite, color: Colors.black, size: 24),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('48', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  Text('Puan', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Süre Kutusu
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.timer_outlined, color: Colors.black, size: 24),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('61', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  Text('Saniye', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Siyah Değiştir Butonu
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: _gorevTamamla,
                        child: const Text(
                          'Değiştir',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Alt Navigasyon Çubuğu (Tab Bar)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.format_list_bulleted, 'Kampanya', 0),
                _buildNavItem(Icons.play_arrow_rounded, 'İzle', 1),
                _buildNavItem(Icons.subscriptions, 'Abone Ol', 2),
                _buildNavItem(Icons.thumb_up, 'Beğen', 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _seciliTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _seciliTab = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.red : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.grey,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
