import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const YtApp());
}

class YtApp extends StatelessWidget {
  const YtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YT Mutual',
      theme: ThemeData.dark(),
      home: const GirisEkrani(),
    );
  }
}

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _kanalController = TextEditingController();
  bool yukleniyor = false;

  void girisYap() {
    if (_adController.text.isEmpty || _kanalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lutfen adinizi ve YouTube kanal adinizi girin!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => yukleniyor = true);

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AnaSayfa(
              kullaniciAdi: _adController.text,
              ePosta: "${_adController.text.toLowerCase().replaceAll(' ', '')}@gmail.com",
              ytKanalAdi: _kanalController.text,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_circle_fill, size: 90, color: Colors.redAccent),
                const SizedBox(height: 15),
                const Text("YT Mutual", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 5),
                const Text("Karsilikli YouTube Etkilesim Platformu", style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 35),
                
                TextField(
                  controller: _adController,
                  decoration: const InputDecoration(
                    labelText: "Adiniz Soyadiniz",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person, color: Colors.redAccent),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _kanalController,
                  decoration: const InputDecoration(
                    labelText: "YouTube Kanal Adiniz",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.subscriptions, color: Colors.redAccent),
                  ),
                ),
                const SizedBox(height: 25),

                if (yukleniyor)
                  const Column(
                    children: [
                      CircularProgressIndicator(color: Colors.redAccent),
                      SizedBox(height: 10),
                      Text("Google/YouTube Hesabi Dogrulaniyor...", style: TextStyle(color: Colors.grey)),
                    ],
                  )
                else
                  ElevatedButton.icon(
                    onPressed: girisYap,
                    icon: const Icon(Icons.login, color: Colors.white),
                    label: const Text("Google / YouTube Hesabi ile Giris Yap", style: TextStyle(fontSize: 15, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  final String kullaniciAdi;
  final String ePosta;
  final String ytKanalAdi;

  const AnaSayfa({
    super.key,
    required this.kullaniciAdi,
    required this.ePosta,
    required this.ytKanalAdi,
  });

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int toplamPuan = 100;
  int kalanSure = 10;
  Timer? timer;
  bool izleniyor = false;
  bool reklamIzleniyor = false;
  int tamamlananGorev = 0;

  List<Map<String, String>> gorevHavuzu = [
    {"link": "https://youtube.com/watch?v=ornek1", "tur": "Izlenme"},
    {"link": "https://youtube.com/channel/ornek2", "tur": "Abone"},
  ];

  void videoyuBaslat() {
    setState(() { izleniyor = true; });
    
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (kalanSure > 0) {
        setState(() { kalanSure--; });
      } else {
        t.cancel();
        setState(() {
          toplamPuan += 10;
          tamamlananGorev++;
          izleniyor = false;
          kalanSure = 10;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gorev Tamamlandi! +10 Jeton Kazandin!'), backgroundColor: Colors.green),
        );
      }
    });
  }

  void reklamGoster() {
    setState(() { reklamIzleniyor = true; });

    Timer(const Duration(seconds: 4), () {
      setState(() {
        toplamPuan += 20;
        reklamIzleniyor = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Odullu AdMob Reklami Izlendi! +20 Jeton Kazandin!'), backgroundColor: Colors.purple),
      );
    });
  }

  void carkifelekAc() {
    int kazanilan = (Random().nextInt(10) + 1) * 10;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Gunlock Sans Carki"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars, size: 60, color: Colors.amber),
            const SizedBox(height: 15),
            Text("Carki cevirdin ve $kazanilan Jeton kazandin!", textAlign: TextAlign.center),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() { toplamPuan += kazanilan; });
              Navigator.pop(context);
            },
            child: const Text("Jetonu Al"),
          )
        ],
      ),
    );
  }

  void gorevEkleDiyalogu() {
    TextEditingController linkController = TextEditingController();
    String secilenTur = "Izlenme";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Yeni Gorev Olustur"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: secilenTur,
                isExpanded: true,
                items: <String>['Izlenme', 'Abone', 'Begeni'].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text("Gorev Turu: $value"));
                }).toList(),
                onChanged: (yeniDeger) => setDialogState(() => secilenTur = yeniDeger!),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(hintText: "YouTube Linkini Yapistir", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 5),
              const Text("Maliyet: 50 Jeton", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Iptal")),
            ElevatedButton(
              onPressed: () {
                if (toplamPuan >= 50 && linkController.text.isNotEmpty) {
                  setState(() {
                    toplamPuan -= 50;
                    gorevHavuzu.add({"link": linkController.text, "tur": secilenTur});
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$secilenTur gorevi havuza eklendi!')),
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Yetersiz Jeton veya Gecersiz Link!'), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text("Yayinla"),
            )
          ],
        ),
      ),
    );
  }

  void profilAc() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 400,
        child: Column(
          children: [
            const CircleAvatar(radius: 40, backgroundColor: Colors.redAccent, child: Icon(Icons.person, size: 50, color: Colors.white)),
            const SizedBox(height: 10),
            Text(widget.kullaniciAdi, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(widget.ePosta, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 5),
            Chip(
              avatar: const Icon(Icons.subscriptions, size: 16, color: Colors.white),
              label: Text(widget.ytKanalAdi, style: const TextStyle(fontSize: 12)),
              backgroundColor: Colors.red[900],
            ),
            const Divider(height: 25),
            ListTile(
              leading: const Icon(Icons.monetization_on, color: Colors.amber),
              title: const Text("Mevcut Jeton Bakiye"),
              trailing: Text("$toplamPuan", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text("Tamamlanan Gorevler"),
              trailing: Text("$tamamlananGorev", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GirisEkrani()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800], minimumSize: const Size(double.infinity, 40)),
              child: const Text("Cikis Yap", style: TextStyle(color: Colors.redAccent)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('YT Mutual'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(icon: const Icon(Icons.account_circle, size: 30), onPressed: profilAc),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Bakiye: $toplamPuan Jeton', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: gorevEkleDiyalogu,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      child: const Text('+ Gorev Ekle', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: reklamIzleniyor
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.purple),
                            SizedBox(height: 10),
                            Text('Odullu AdMob Reklami Oynatiliyor...', style: TextStyle(color: Colors.purpleAccent)),
                          ],
                        )
                      : izleniyor
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(color: Colors.red),
                                const SizedBox(height: 10),
                                Text('YouTube Videosu Oynatiliyor... ($kalanSure sn)', style: const TextStyle(color: Colors.white)),
                              ],
                            )
                          : const Text('Gorev Secin veya Video Izleyin', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: (izleniyor || reklamIzleniyor) ? null : videoyuBaslat,
                icon: const Icon(Icons.play_arrow),
                label: Text(izleniyor ? 'Izleniyor ($kalanSure)' : 'Gorev Videosunu Izle (+10 Jeton)'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 45)),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: (izleniyor || reklamIzleniyor) ? null : reklamGoster,
                icon: const Icon(Icons.movie_creation),
                label: const Text('Odullu Reklam Izle (+20 Jeton)'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, minimumSize: const Size(double.infinity, 45)),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: carkifelekAc,
                icon: const Icon(Icons.casino),
                label: const Text('Gunluk Sans Carkifelegi'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 45)),
              ),
              const SizedBox(height: 15),
              Text('Havuzdaki Toplam Gorev: ${gorevHavuzu.length}', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
