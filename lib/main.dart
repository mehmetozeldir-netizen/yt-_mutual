import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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

// 1. SPLASH EKRANI (Oturum kontrolü)
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _oturumuKontrolEt();
  }

  Future<void> _oturumuKontrolEt() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final prefs = await SharedPreferences.getInstance();
    String? kaydedilenEmail = prefs.getString('aktif_kullanici_email');

    if (!mounted) return;

    if (kaydedilenEmail != null && kaydedilenEmail.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(userEmail: kaydedilenEmail),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
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
      String email = account?.email ?? "ytmutual@user.com";

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('aktif_kullanici_email', email);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(userEmail: email),
          ),
        );
      }
    } catch (error) {
      String email = "ytmutual@user.com";
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('aktif_kullanici_email', email);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(userEmail: email),
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

// 3. ANA PANEL EKRANI
class DashboardScreen extends StatefulWidget {
  final String userEmail;
  const DashboardScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _puan = 178;
  bool _otomatikMod = false;
  int _seciliTab = 1; // Varsayılan olarak "İzle" sekmesi seçili

  final String _youtubeVideoUrl = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  Future<void> _cikisYap() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('aktif_kullanici_email');
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> _videoAc() async {
    final Uri url = Uri.parse(_youtubeVideoUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Video açılamadı: $url');
    }
  }

  void _gorevTamamla() {
    int yeniBakiye = _puan + 48;
    _puanKaydet(yeniBakiye);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tebrikler! +48 Puan eklendi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    String ilkHarf = widget.userEmail.isNotEmpty ? widget.userEmail[0].toUpperCase() : 'A';
    String kullaniciAdi = widget.userEmail.contains('@') 
        ? widget.userEmail.split('@')[0] 
        : widget.userEmail;
    if (kullaniciAdi.isNotEmpty) {
      kullaniciAdi = kullaniciAdi[0].toUpperCase() + kullaniciAdi.substring(1);
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
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
      // Sol Yan Menü (Drawer)
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.manage_accounts_outlined, color: Colors.black87, size: 22),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.nightlight_outlined, color: Colors.black87, size: 22),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.black87, size: 22),
                        onPressed: () {
                          Navigator.pop(context);
                          _cikisYap();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        ilkHarf,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    kullaniciAdi,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.userEmail,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(Icons.favorite_border, 'Puan Satın Al', () {}),
                  _buildDrawerItem(Icons.verified_outlined, 'VIP Üye Ol', () {}),
                  _buildDrawerItem(Icons.card_giftcard, 'Salla & Kazan', () {}),
                  _buildDrawerItem(Icons.help_outline, 'Sıkça Sorulan Sorular', () {}),
                  _buildDrawerItem(Icons.privacy_tip_outlined, 'Gizlilik Politikası', () {}),
                  _buildDrawerItem(Icons.share_outlined, 'Uygulamayı Paylaş', () {}),
                  _buildDrawerItem(Icons.star_border_rounded, 'Uygulamayı Değerlendir', () {}),
                  _buildDrawerItem(Icons.chat_bubble_outline, 'Bize Ulaşın', () {}),
                  _buildDrawerItem(Icons.logout, 'Çıkış yap', () {
                    Navigator.pop(context);
                    _cikisYap();
                  }, isRed: true),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sürüm: 3.4.21',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Row(
                    children: const [
                      Text(
                        'harby',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'apps',
                        style: TextStyle(
                          color: Color(0xFFDC2626),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
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
      body: SafeArea(
        bottom: false, // Alt kenarın safe area boşluğunu optimize etmek için
        child: Column(
          children: [
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _videoAc,
                      child: Stack(
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
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: const [
                                  Text('izlemek için: ', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                  Icon(Icons.play_arrow, color: Colors.red, size: 16),
                                  Text('YouTube', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
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
                    const SizedBox(height: 15), // İçeriğin alt menüyle çakışmaması için ufak bir boşluk
                  ],
                ),
              ),
            ),
            // Alt Menü Çubuğu (Yukarı taşındı ve alt boşluk dengelendi)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, {bool isRed = false}) {
    return ListTile(
      leading: Icon(icon, color: isRed ? Colors.red : Colors.black87, size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: isRed ? Colors.red : Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      dense: true,
      horizontalTitleGap: 8,
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
          Icon(icon, color: isSelected ? Colors.red : Colors.grey, size: 24),
          const SizedBox(height: 2),
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
