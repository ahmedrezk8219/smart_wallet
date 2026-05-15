import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../providers/transaction_provider.dart';

class InsightsScreen extends StatelessWidget {
  InsightsScreen({super.key});

  final List<Color> colors = [
    Colors.orange,
    Colors.blue,
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.teal,
    Colors.pink,
    Colors.amber,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    Map<String, double> data = {};

    for (var t in provider.transactions) {
      data[t.category] = (data[t.category] ?? 0) + t.amount;
    }

    final categories = data.keys.toList();
    final total = data.values.fold(0.0, (a, b) => a + b);

    Color getColor(int index) {
      return colors[index % colors.length];
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Insights'), centerTitle: true),

      body: data.isEmpty
          ? const Center(
              child: Text("No data yet", style: TextStyle(fontSize: 18)),
            )
          : Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  // 📊 PIE CHART
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: List.generate(categories.length, (index) {
                          final category = categories[index];
                          final value = data[category]!;

                          final percent = (value / total) * 100;

                          return PieChartSectionData(
                            value: value,
                            title:
                                '${category}\n${percent.toStringAsFixed(1)}%',
                            color: getColor(index),
                            radius: 95,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }),

                        sectionsSpace: 2,
                        centerSpaceRadius: 45,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 📌 LEGEND (Improved)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(categories.length, (index) {
                      final category = categories[index];
                      final value = data[category]!;
                      final percent = (value / total) * 100;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: getColor(index).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: getColor(index), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: getColor(index),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$category (${percent.toStringAsFixed(1)}%)',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
    );
  }
}
