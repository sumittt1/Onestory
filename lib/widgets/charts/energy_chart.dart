import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../models/models.dart';

class EnergyChart extends StatelessWidget {
  final EnergyUsageModel energyData;
  final EnergyPeriod selectedPeriod;
  final Function(EnergyPeriod) onPeriodChanged;
  
  const EnergyChart({
    super.key,
    required this.energyData,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Energy Consumption',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SegmentedButton<EnergyPeriod>(
                  segments: const [
                    ButtonSegment(
                      value: EnergyPeriod.daily,
                      label: Text('Daily'),
                    ),
                    ButtonSegment(
                      value: EnergyPeriod.weekly,
                      label: Text('Weekly'),
                    ),
                    ButtonSegment(
                      value: EnergyPeriod.monthly,
                      label: Text('Monthly'),
                    ),
                  ],
                  selected: {selectedPeriod},
                  onSelectionChanged: (Set<EnergyPeriod> newSelection) {
                    onPeriodChanged(newSelection.first);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            const Divider(),
            const SizedBox(height: AppTheme.spacingMedium),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppTheme.dividerColor,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: _getInterval(selectedPeriod),
                        getTitlesWidget: (value, meta) {
                          return _buildBottomTitle(value, selectedPeriod);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.textSecondary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  minX: 0,
                  maxX: (energyData.dataPoints.length - 1).toDouble(),
                  minY: 0,
                  maxY: _getMaxY(energyData),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _buildSpots(energyData),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.8),
                          AppTheme.primaryLight.withOpacity(0.8),
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppTheme.primaryColor,
                            strokeWidth: 0,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor.withOpacity(0.2),
                            AppTheme.primaryColor.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  'Total Usage',
                  '${energyData.totalUsage.toStringAsFixed(1)} kWh',
                  Icons.bolt,
                  AppTheme.primaryColor,
                ),
                _buildSummaryItem(
                  'Estimated Saved',
                  '${energyData.totalEstimatedSaved.toStringAsFixed(1)} kWh',
                  Icons.savings,
                  AppTheme.successColor,
                ),
                _buildSummaryItem(
                  'Average',
                  '${energyData.averageUsage.toStringAsFixed(1)} kWh',
                  Icons.show_chart,
                  AppTheme.infoColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  double _getMaxY(EnergyUsageModel data) {
    final maxValue = data.dataPoints.map((dp) => dp.usage).reduce((a, b) => a > b ? a : b);
    return (maxValue * 1.2).ceilToDouble();
  }
  
  double _getInterval(EnergyPeriod period) {
    switch (period) {
      case EnergyPeriod.daily:
        return 5.0;
      case EnergyPeriod.weekly:
        return 1.0;
      case EnergyPeriod.monthly:
        return 1.0;
    }
  }
  
  List<FlSpot> _buildSpots(EnergyUsageModel data) {
    return data.dataPoints.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.usage,
      );
    }).toList();
  }
  
  Widget _buildBottomTitle(double value, EnergyPeriod period) {
    if (value.toInt() >= 30) return const SizedBox.shrink();
    
    String label;
    switch (period) {
      case EnergyPeriod.daily:
        label = 'D${value.toInt() + 1}';
        break;
      case EnergyPeriod.weekly:
        label = 'W${value.toInt() + 1}';
        break;
      case EnergyPeriod.monthly:
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        final monthIndex = (value.toInt() + DateTime.now().month - 1) % 12;
        label = months[monthIndex];
        break;
    }
    
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }
  
  Widget _buildSummaryItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
