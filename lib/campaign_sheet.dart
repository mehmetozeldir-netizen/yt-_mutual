import 'package:flutter/material.dart';

class CampaignBottomSheet extends StatefulWidget {
  const CampaignBottomSheet({Key? key}) : super(key: key);

  @override
  State<CampaignBottomSheet> createState() => _CampaignBottomSheetState();
}

class _CampaignBottomSheetState extends State<CampaignBottomSheet> {
  final TextEditingController _urlController = TextEditingController();
  String _selectedTab = 'Abone Ol';
  int _selectedViewCount = 25;

  final List<int> viewOptions = [25, 50, 100, 150, 200, 250, 300, 400, 500, 1000];

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      hintText: "YouTube Linkini Yapıştırın",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.history, size: 30),
                  onPressed: () {},
                ),
                GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'logo.png',
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.play_arrow, size: 32, color: Colors.red),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['İzle', 'Abone Ol', 'Beğen'].map((tab) {
                return ChoiceChip(
                  label: Text(tab),
                  selected: _selectedTab == tab,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTab = tab;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (_selectedTab == 'Abone Ol')
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Kullanıcılar 60 saniye izleyip ardından abone olacak. (Maliyet: 210 Puan / Kişi)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Hedef Sayı:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                DropdownButton<int>(
                  value: _selectedViewCount,
                  items: viewOptions.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text("$value Kişi"),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedViewCount = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Kampanyayı Oluştur", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
