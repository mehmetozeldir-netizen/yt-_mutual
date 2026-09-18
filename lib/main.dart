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
  int userPoints = 1450; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kampanyalar"),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                "$userPoints Puan",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Kayıtlı Kullanıcı"),
              accountEmail: Text("Puanlarınız Güvende"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.grey),
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
                Navigator.pop(context); // Menüyü kapat
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShakeToWinScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text("Mevcut kampanyalar burada listelenecek..."),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const CampaignBottomSheet(),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
