import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/transaction_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final nameController = TextEditingController();
  String currency = "\$";

  // قائمة العملات الشاملة
  final Map<String, String> currencies = {
    "\$": "USD (US Dollar)",
    "EGP": "EGP (Egyptian Pound)",
    "SAR": "SAR (Saudi Riyal)",
    "AED": "AED (UAE Dirham)",
    "KWD": "KWD (Kuwaiti Dinar)",
    "QAR": "QAR (Qatari Riyal)",
    "BHD": "BHD (Bahraini Dinar)",
    "OMR": "OMR (Omani Rial)",
    "JOD": "JOD (Jordanian Dinar)",
    "€": "EUR (Euro)",
    "£": "GBP (British Pound)",
    "¥": "JPY (Japanese Yen)",
    "TRY": "TRY (Turkish Lira)",
    "DZ": "DZD (Algerian Dinar)",
    "MA": "MAD (Moroccan Dirham)",
    "LYD": "LYD (Libyan Dinar)",
  };

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedCurrency = prefs.getString('currency');
    
    setState(() {
      nameController.text = prefs.getString('name') ?? "";
      // التأكد أن العملة المحفوظة موجودة في القائمة، وإلا نستخدم الدولار كافتراضي
      if (savedCurrency != null && currencies.containsKey(savedCurrency)) {
        currency = savedCurrency;
      } else {
        currency = "\$";
      }
    });
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('currency', currency);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Settings saved successfully!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> clearAllData() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear All Data?"),
        content: const Text("This action will delete all your transactions. This cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              final box = Hive.box<TransactionModel>('transactions');
              await box.clear();
              if (!mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("All data cleared"), backgroundColor: Colors.red),
              );
            },
            child: const Text("Clear", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 👤 حقل الاسم
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Your Name",
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 20),

            // 💰 قائمة العملات الطويلة
            DropdownButtonFormField<String>(
              value: currency,
              decoration: InputDecoration(
                labelText: "Primary Currency",
                prefixIcon: const Icon(Icons.monetization_on),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              // هنا بنحول الـ Map لـ قائمة DropdownItems بشكل أوتوماتيكي
              items: currencies.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) => setState(() => currency = value!),
              // إضافة خاصية البحث أو القائمة الطويلة
              menuMaxHeight: 300, 
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: saveSettings,
              icon: const Icon(Icons.save),
              label: const Text("Save Settings"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 15),

            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: clearAllData,
              icon: const Icon(Icons.delete_forever),
              label: const Text("Clear All Data"),
            ),

            const SizedBox(height: 40),

            const Text(
              "Smart Wallet v1.0",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Developed by Ahmed",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}