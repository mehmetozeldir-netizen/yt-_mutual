import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase başlatma alanı
  await Firebase.initializeApp();
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
      home: const AuthWrapper(),
    );
  }
}

// OTURUM KONTROLÜ VE VERİTABANI BAĞLANTISI
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        // Kullanıcı oturum açmamışsa anonim oturum başlat (Puan kaybını önler)
        if (!snapshot.hasData) {
          FirebaseAuth.instance.signInAnonymously();
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return HomeScreen(user: snapshot.data!);
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  bool isAutomatic = false;

  // VERİTABANINDAN GÜVENLİ PUAN ARTIRMA/EKSİLTME
  Future<void> updatePoints(int amount) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(widget.user.uid);
    
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);
      if (!snapshot.exists) {
        transaction.set(userRef, {
          'name': widget.user.displayName ?? 'Kullanıcı',
          'email': widget.user.email ?? 'Giriş Yapılmadı',
          'points': 100 + amount,
        });
      } else {
        int newPoints = ((snapshot.data() as Map<String, dynamic>)['points'] ?? 0) + amount;
        transaction.update(userRef, {'points': newPoints});
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateCampaignScreen(userId: widget.user.uid)),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(widget.user.uid).snapshots(),
      builder: (context, snapshot) {
        int userPoints = 0;
        if (snapshot.hasData && snapshot.data!.exists) {
          userPoints = (snapshot.data!.data() as Map<String, dynamic>)['points'] ?? 0;
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.notes, size: 28),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: const Text("Yt Mutual", style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              Row(
                children: [
                  Text("$userPoints", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  const Icon(Icons.favorite, color: Colors.red, size: 22),
                  const SizedBox(width: 16),
                ],
              )
            ],
          ),
          drawer: _buildCustomDrawer(context, userPoints),
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
      },
    );
  }

  // YAN MENÜ (DRAWER)
  Widget _buildCustomDrawer(BuildContext context, int points) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFF8B5CF6),
                    child: Text(
                      (widget.user.displayName ?? 'A')[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.user.displayName ?? 'Misafir Kullanıcı', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(widget.user.email ?? 'Hesap Bağlanmadı', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.sentiment_satisfied_alt_outlined),
                    title: const Text("Salla & Kazan"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ShakeToWinScreen(userId: widget.user.uid)));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text("Gizlilik Politikası"),
                    onTap: () async {
                      const url = 'https://harbyapps.com/privacy';
                      if (await canLaunchUrl(Uri.parse(url))) await launchUrl(Uri.parse(url));
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Sürüm: 3.4.21 - härby apps", style: TextStyle(color: Colors.grey, fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWatchTab() {
    return Center(
      child: ElevatedButton(
        onPressed: () => updatePoints(48), // Örnek puan kazanımı
        child: const Text("Video İzle (+48 Puan Kazan)"),
      ),
    );
  }

  Widget _buildSubscribeTab() {
    return Center(
      child: ElevatedButton(
        onPressed: () => updatePoints(210),
        child: const Text("Abone Ol (+210 Puan Kazan)"),
      ),
    );
  }

  Widget _buildLikeTab() {
    return Center(
      child: ElevatedButton(
        onPressed: () => updatePoints(150),
        child: const Text("Beğen (+150 Puan Kazan)"),
      ),
    );
  }
}

// SALLA KAZAN (GERÇEK SENSÖR ENTEGRASYONLU)
class ShakeToWinScreen extends StatefulWidget {
  final String userId;
  const ShakeToWinScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ShakeToWinScreen> createState() => _ShakeToWinScreenState();
}

class _ShakeToWinScreenState extends State<ShakeToWinScreen> {
  StreamSubscription? _subscription;
  bool _hasRewarded = false;

  @override
  void initState() {
    super.initState();
    // İvmeölçer dinleyicisi
    _subscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      double gX = event.x / 9.81;
      double gY = event.y / 9.81;
      double gZ = event.z / 9.81;

      double gForce = double.parse((gX * gX + gY * gY + gZ * gZ).toString());

      // Fiziksel sallama eşiği
      if (gForce > 2.5 && !_hasRewarded) {
        _hasRewarded = true;
        _grantReward();
      }
    });
  }

  Future<void> _grantReward() async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(widget.userId);
    await userRef.update({'points': FieldValue.increment(50)});

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tebrikler! Telefonu sallayarak 50 Puan Kazandınız.")),
      );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Salla & Kazan"), backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.vibration, size: 100, color: Colors.redAccent),
            SizedBox(height: 20),
            Text("Hediyeni Almak İçin Telefonu Salla!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// KAMPANYA OLUŞTURMA
class CreateCampaignScreen extends StatelessWidget {
  final String userId;
  const CreateCampaignScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kampanya Oluştur")),
      body: const Center(child: Text("Kampanya Form Alanı")),
    );
  }
}
