import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_wallet/screens/onboarding/Onboarding_Screen.dart';

import 'data/models/transaction_model.dart';
import 'providers/transaction_provider.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }
  await Hive.openBox<TransactionModel>('transactions');

  runApp(const SmartWalletApp());
}

class SmartWalletApp extends StatefulWidget {
  const SmartWalletApp({super.key});

  @override
  State<SmartWalletApp> createState() => _SmartWalletAppState();
}

class _SmartWalletAppState extends State<SmartWalletApp> {
  bool isFirstTime = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  // دالة بتشوف هل دي أول مرة يفتح التطبيق؟
  _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstTime = prefs.getBool('isFirstTime') ?? true;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));

    return ChangeNotifierProvider(
      create: (_) => TransactionProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, primarySwatch: Colors.indigo),
        // هنا السر: لو أول مرة يفتح Onboarding، لو مش أول مرة يفتح MainScreen
        home: isFirstTime ? const OnboardingScreen() : const MainScreen(),
      ),
    );
  }
}