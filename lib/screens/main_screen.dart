import 'package:flutter/material.dart';
import 'package:smart_wallet/screens/home/home_screen.dart';
import 'package:smart_wallet/screens/insights/insights_screen.dart';
import 'package:smart_wallet/screens/transaction/transaction_screen.dart';
import 'package:smart_wallet/screens/settings/settings_screen.dart'; // تأكد من المسار

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  // 1. أضفنا شاشة الإعدادات هنا في القائمة
  final pages = [
    const HomeScreen(),
    InsightsScreen(),
    const SettingsScreen(), // الشاشة رقم 2 (تبدأ من 0)
  ];

  void openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // ملحوظة: غالباً هنا كنت محتاج تفتح شاشة إضافة عملية AddTransactionScreen وليس الـ Onboarding
      builder: (_) => const TransactionScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      // زرار الإضافة اللي في النص
      floatingActionButton: FloatingActionButton(
        onPressed: openAddSheet,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // شريط التنقل السفلي
      bottomNavigationBar: BottomAppBar(
        shape:
            const CircularNotchedRectangle(), // عشان يعمل نص دايرة حوالين الزرار
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // أيقونة الـ Home
            IconButton(
              icon: Icon(
                Icons.home,
                color: currentIndex == 0 ? Colors.indigo : Colors.grey,
              ),
              onPressed: () => setState(() => currentIndex = 0),
            ),
            // أيقونة الـ Insights
            IconButton(
              icon: Icon(
                Icons.pie_chart,
                color: currentIndex == 1 ? Colors.indigo : Colors.grey,
              ),
              onPressed: () => setState(() => currentIndex = 1),
            ),

            const SizedBox(
              width: 40,
            ), // مساحة فاضية عشان الـ Floating Button اللي في النص
            // أيقونة الـ Settings (الجديدة)
            IconButton(
              icon: Icon(
                Icons.settings,
                color: currentIndex == 2 ? Colors.indigo : Colors.grey,
              ),
              onPressed: () => setState(() => currentIndex = 2),
            ),
            // أيقونة رابعة لو حبيت تضيف (مثلاً Profile أو Notifications)
            // IconButton(
            //   icon: const Icon(Icons.more_horiz, color: Colors.grey),
            //   onPressed: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
