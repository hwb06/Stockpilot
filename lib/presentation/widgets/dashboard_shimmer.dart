import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_values.dart';
import 'stat_card.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.surface,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.pagePadding),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.dashboardMaxWidth,
            ),
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: StatCard.gridDelegate,
                  itemCount: AppValues.dashboardShimmerStatCount,
                  itemBuilder: (_, __) => const _Block(),
                ),
                const SizedBox(height: AppDimensions.spaceXL),
                const _Block(height: AppDimensions.chartHeight),
                const SizedBox(height: AppDimensions.spaceXL),
                for (var i = 0; i < AppValues.dashboardShimmerRowCount; i++) ...[
                  const _Block(height: AppDimensions.movementCardHeight),
                  const SizedBox(height: AppDimensions.spaceS),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
    );
  }
}
