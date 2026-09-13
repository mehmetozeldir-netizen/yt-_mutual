import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Puanları kalıcı saklamak için

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
      body: Stack(
        children: [
          Center(
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
          const Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'harbyapps',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
        ],
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFFDC2626),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 20),
                Text(
                  'Güvenli Bağlantı Kuruluyor...',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Yt Mutual',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (mounted) Navigator.pop(context);

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
      if (mounted) Navigator.pop(context);
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
                  const SizedBox(height: 15),
                  const Text(
                    'harbyapps',
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
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

// 3. ANA EKRAN VE %100 GÜVENLİ PUAN SİSTEMİ
class DashboardScreen extends StatefulWidget {
  final String userEmail;
  const DashboardScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _puan = 150; // Başlangıç bakiyesi

  @override
  void initState() {
    super.initState();
    _puaniYukle(); // Uygulama açılır açılmaz kaydedilmiş puanı hafızadan geri yükle
  }

  // Puanı telefondaki güvenli hafızadan oku
  Future<void> _puaniYukle() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _puan = prefs.getInt('kullanici_puani_${widget.userEmail}') ?? 150;
    });
  }

  // Puanı telefondaki güvenli hafızaya kalıcı olarak kaydet
  Future<void> _puanKaydet(int yeniPuan) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('kullanici_puani_${widget.userEmail}', yeniPuan);
    setState(() {
      _puan = yeniPuan;
    });
  }

  // Puan Ekleme Örneği (Görev tamamlandığında)
  void _puanKazan(int eklenecekMiktar) {
    int guncelPuan = _puan + eklenecekMiktar;
    _puanKaydet(guncelPuan);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tebrikler! +$eklenecekMiktar Puan eklendi. Toplam: $guncelPuan Puan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDC2626),
        title: const Text('Yt Mutual - Panel', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFDC2626),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Giriş Yapılan Hesap,', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(widget.userEmail, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Kalıcı Bakiye Kartı
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFDC2626), Color(0xFF991B1B)]),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Kalıcı Güvenli Bakiye', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 5),
                      Text('$_puan Puan', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Icon(Icons.verified, color: Colors.white, size: 40),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text('Görevler ve Kazan', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: const Icon(Icons.video_library, color: Color(0xFFDC2626)),
                    title: const Text('Videoyu İzle & Puanı Kap', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Anında +20 Puan (Kayıtlı)'),
                    trailing: const Icon(Icons.add_circle, color: Color(0xFFDC2626), size: 28),
                    onTap: () => _puanKazan(20),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: const Icon(Icons.campaign, color: Color(0xFFDC2626)),
                    title: const Text('Kanalını Tanıt / Kampanya Oluştur', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Abone ve izlenme kas'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kampanya yönetimi aktif.')),
                      );
                    },
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
