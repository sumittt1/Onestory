import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../widgets/common/widgets.dart';
import '../../widgets/charts/energy_chart.dart';

class EnergyScreen extends StatefulWidget {
  const EnergyScreen({super.key});

  @override
  State<EnergyScreen> createState() => _EnergyScreenState();
}

class _EnergyScreenState extends State<EnergyScreen> {
  EnergyPeriod _selectedPeriod = EnergyPeriod.daily;

  @override
  Widget build(BuildContext context) {
    final energyData = MockDataProvider.getEnergyUsage();
    final selectedData = energyData.firstWhere(
      (e) => e.period == _selectedPeriod,
      orElse: () => energyData.first,
    );

    return AppShell(
      selectedIndex: 3,
      title: 'Energy Usage',
      subtitle: 'Analyze campus energy consumption',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EnergyChart(
              energyData: selectedData,
              selectedPeriod: _selectedPeriod,
              onPeriodChanged: (period) {
                setState(() {
                  _selectedPeriod = period;
                });
              },
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            _buildingComparison(context),
            const SizedBox(height: AppTheme.spacingLarge),
            _classroomComparison(context),
          ],
        ),
      ),
    );
  }

  Widget _buildingComparison(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Building Comparison',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            _buildComparisonBar('Main Building', 125.5, AppTheme.primaryColor),
            _buildComparisonBar('Engineering Block', 156.8, AppTheme.infoColor),
            _buildComparisonBar('Administrative Block', 89.3, AppTheme.successColor),
            _buildComparisonBar('Computer Science Block', 134.2, AppTheme.warningColor),
            _buildComparisonBar('Library', 67.8, AppTheme.secondaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonBar(String label, double value, Color color) {
    final maxValue = 156.8;
    final percentage = (value / maxValue) * 100;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text('${value.toStringAsFixed(1)} kWh (Est.)'),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppTheme.dividerColor,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _classroomComparison(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Energy Consumers',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            _buildConsumerItem('Lab 1', 18.7, 1),
            _buildConsumerItem('CS101', 16.8, 2),
            _buildConsumerItem('Lab 2', 17.3, 3),
            _buildConsumerItem('C104', 15.2, 4),
            _buildConsumerItem('CS102', 15.4, 5),
          ],
        ),
      ),
    );
  }

  Widget _buildConsumerItem(String name, double value, int rank) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: rank <= 3 ? AppTheme.warningColor : AppTheme.primaryColor,
        child: Text(
          '$rank',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(name),
      trailing: Text('${value.toStringAsFixed(1)} kWh (Est.)'),
    );
  }
}
