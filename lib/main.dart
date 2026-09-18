import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Çevrimdışı ve önbellek desteği ile puan kaybolmasını engelleme
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  
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
      home: AuthWrapper(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const AuthWrapper({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData) {
          FirebaseAuth.instance.signInAnonymously();
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return HomeScreen(user: snapshot.data!, toggleTheme: toggleTheme, isDarkMode: isDarkMode);
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  final User user;
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    Key? key,
    required this.user,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  Future<void> updatePoints(int amount) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(widget.user.uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);
      if (!snapshot.exists) {
        transaction.set(userRef, {
          'name': widget.user.displayName ?? 'Mehmet Özel',
          'email': widget.user.email ?? 'mehmet@example.com',
          'points': 100 + amount,
        });
      } else {
        int currentPoints = (snapshot.data() as Map<String, dynamic>)['points'] ?? 0;
        transaction.update(userRef, {'points': currentPoints + amount});
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
              _buildTaskCard("Video İzle", 48, Icons.play_circle_fill),
              _buildTaskCard("Abone Ol", 210, Icons.subscriptions),
              _buildTaskCard("Beğen", 150, Icons.thumb_up),
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

  Widget _buildTaskCard(String title, int reward, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.red),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: () => updatePoints(reward),
            child: Text("Görevi Tamamla (+$reward Puan)"),
          ),
        ],
      ),
    );
  }

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
                      (widget.user.displayName ?? 'M')[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.user.displayName ?? 'Mehmet Özel', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(widget.user.email ?? 'Giriş Yapıldı', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
                    onPressed: widget.toggleTheme,
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.stars, color: Colors.orange),
                    title: const Text("Puan Satın Al"),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mağaza bağlantısı hazırlanıyor.")));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.workspace_premium, color: Colors.amber),
                    title: const Text("VIP Üye Ol"),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("VIP sistemi yakında aktif.")));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.vibration, color: Colors.redAccent),
                    title: const Text("Salla & Kazan"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ShakeToWinScreen(userId: widget.user.uid)));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text("Gizlilik Politikası"),
                    onTap: () async {
                      const url = 'https://google.com';
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
}

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
    _subscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      double gX = event.x / 9.81;
      double gY = event.y / 9.81;
      double gZ = event.z / 9.81;

      double gForce = double.parse((gX * gX + gY * gY + gZ * gZ).toString());

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
        const SnackBar(content: Text("Tebrikler! Telefonu sallayarak +50 Puan Kazandınız.")),
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

class CreateCampaignScreen extends StatelessWidget {
  final String userId;
  const CreateCampaignScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kampanya Oluştur")),
      body: const Center(child: Text("Kampanya Oluşturma Ekranı")),
    );
  }
}
