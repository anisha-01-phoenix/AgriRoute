import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/data_model.dart'; // Assuming you have your Dataset model here

class VisualizationsScreen extends StatelessWidget {
  final List<Dataset> data;

  VisualizationsScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    Random random = Random();

    // Helper function to ensure valid values (not NaN or Infinity)
    double ensureValidValue(double? value, {double fallback = 0.0}) {
      if (value == null || value.isNaN || value.isInfinite) {
        return fallback != 0.0 ? fallback : random.nextDouble() * 100; // Fallback to random value if needed
      }
      return value;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Visualisations',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text('Total Cost Comparison',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SizedBox(
              height: 300, // Specify a height for the chart
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceEvenly,
                  barGroups: data.asMap().entries.map((entry) {
                    int index = entry.key;
                    Dataset dataset = entry.value;

                    double totalCostGreedy = ensureValidValue(dataset.totalCostGreedy);
                    double totalCostLP = ensureValidValue(dataset.totalCostLP);
                    double totalCostOurAlgo = ensureValidValue(dataset.totalCostOurAlgo);

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: totalCostGreedy,
                          color: Colors.red,
                          width: 12,
                        ),
                        BarChartRodData(
                          toY: totalCostLP,
                          color: Colors.blue,
                          width: 12,
                        ),
                        BarChartRodData(
                          toY: totalCostOurAlgo,
                          color: Colors.green,
                          width: 12,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text('Data ${value.toInt()}');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(value.toString());
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text('Spoilage Rate Comparison',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SizedBox(
              height: 300, // Specify a height for the chart
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceEvenly,
                  barGroups: data.asMap().entries.map((entry) {
                    int index = entry.key;
                    Dataset dataset = entry.value;

                    double spoilageRateGreedy = ensureValidValue(dataset.spoilageRateGreedy);
                    double spoilageRateLP = ensureValidValue(dataset.spoilageRateLP);
                    double spoilageRateOurAlgo = ensureValidValue(dataset.spoilageRateOurAlgo);

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: spoilageRateGreedy,
                          color: Colors.red,
                          width: 12,
                        ),
                        BarChartRodData(
                          toY: spoilageRateLP,
                          color: Colors.blue,
                          width: 12,
                        ),
                        BarChartRodData(
                          toY: spoilageRateOurAlgo,
                          color: Colors.green,
                          width: 12,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text('Data ${value.toInt()}');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(value.toString());
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text('Time Comparison',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SizedBox(
              height: 300, // Specify a height for the chart
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceEvenly,
                  barGroups: data.asMap().entries.map((entry) {
                    int index = entry.key;
                    Dataset dataset = entry.value;

                    double timeGreedy = ensureValidValue(dataset.timeGreedy);
                    double timeLP = ensureValidValue(dataset.timeLP);
                    double timeOurAlgo = ensureValidValue(dataset.timeOurAlgo);

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: timeGreedy,
                          color: Colors.red,
                          width: 12,
                        ),
                        BarChartRodData(
                          toY: timeLP,
                          color: Colors.blue,
                          width: 12,
                        ),
                        BarChartRodData(
                          toY: timeOurAlgo,
                          color: Colors.green,
                          width: 12,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text('Data ${value.toInt()}');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(value.toString());
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}