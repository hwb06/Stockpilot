import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_values.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/dashboard_stats_model.dart';

class PurchasesChart extends StatelessWidget {
  const PurchasesChart({super.key, required this.days});

  final List<DailyPurchaseModel> days;

  static const _axisStyle = TextStyle(
    fontSize: AppDimensions.fontCaption,
    color: AppColors.textSecondary,
  );

  @override
  Widget build(BuildContext context) {
    final highest = days.fold<double>(0, (max, d) => d.total > max ? d.total : max);
    final maxY = highest * AppValues.chartHeadroom;
    final interval = maxY / AppValues.chartGridLines;

    return SizedBox(
      height: AppDimensions.chartHeight,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: interval,
            getDrawingHorizontalLine:
                (_) => const FlLine(
                  color: AppColors.border,
                  strokeWidth: AppDimensions.chartGridStroke,
                ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: AppDimensions.chartAxisReserved,
                interval: interval,
                getTitlesWidget:
                    (value, meta) => SideTitleWidget(
                      meta: meta,
                      child: Text(Formatters.compact(value), style: _axisStyle),
                    ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= days.length) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(Formatters.weekday(days[index].day), style: _axisStyle),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              fitInsideHorizontally: true,
              getTooltipColor: (_) => AppColors.textPrimary,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${Formatters.date(days[group.x].day)}\n'
                  '${Formatters.currency(rod.toY)}',
                  const TextStyle(
                    color: AppColors.surface,
                    fontSize: AppDimensions.fontCaption,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          barGroups: [
            for (var i = 0; i < days.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: days[i].total,
                    width: AppDimensions.chartBarWidth,
                    color:
                        i == days.length - 1
                            ? AppColors.primary
                            : AppColors.primary.withValues(
                              alpha: AppValues.chartPastBarAlpha,
                            ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.chartBarRadius),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
