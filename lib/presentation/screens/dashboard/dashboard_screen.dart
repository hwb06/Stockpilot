import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/dashboard_data.dart';
import '../../widgets/dashboard_shimmer.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/inline_message.dart';
import '../../widgets/low_stock_tile.dart';
import '../../widgets/movement_card.dart';
import '../../widgets/purchases_chart.dart';
import '../../widgets/scrollable_fill.dart';
import '../../widgets/section_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_card.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: AppDimensions.dashboardToolbarHeight,
        title: Obx(() {
          final name = controller.displayName;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.greeting,
                style: const TextStyle(
                  fontSize: AppDimensions.fontCaption,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                name.isEmpty ? AppStrings.navDashboard : name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: AppDimensions.fontHeading,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }),
        actions: [
          IconButton(
            tooltip: AppStrings.logoutTooltip,
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.onPullToRefresh,
        child: Obx(() {
          switch (controller.state.value) {
            case ViewState.loading:
              return const DashboardShimmer();
            case ViewState.error:
              return ScrollableFill(
                child: ErrorState(
                  message: controller.errorMessage.value,
                  onRetry: () => controller.load(),
                ),
              );
            case ViewState.empty:
              return ScrollableFill(
                child: EmptyState(
                  icon: Icons.dashboard_outlined,
                  title: AppStrings.dashboardEmptyTitle,
                  message: AppStrings.dashboardEmptyMessage,
                  actionLabel: AppStrings.dashboardEmptyAction,
                  onAction: () => controller.openTab(HomeTab.products),
                ),
              );
            case ViewState.success:
              final data = controller.data.value;
              if (data == null) return const SizedBox.shrink();
              return _DashboardContent(data: data, controller: controller);
          }
        }),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.data, required this.controller});

  final DashboardData data;
  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppDimensions.pagePadding),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppDimensions.dashboardMaxWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStats(),
              const SizedBox(height: AppDimensions.spaceXL),
              _buildChart(),
              const SizedBox(height: AppDimensions.spaceXL),
              LayoutBuilder(
                builder: (context, constraints) {
                  final lowStock = _buildLowStock();
                  final recent = _buildRecentActivity();
                  final twoColumns =
                      constraints.maxWidth >=
                      AppDimensions.dashboardTwoColumnBreakpoint;

                  if (!twoColumns) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        lowStock,
                        const SizedBox(height: AppDimensions.spaceXL),
                        recent,
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: lowStock),
                      const SizedBox(width: AppDimensions.spaceL),
                      Expanded(child: recent),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Sections ----------

  Widget _buildStats() {
    final stats = data.stats;
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: StatCard.gridDelegate,
      children: [
        StatCard(
          icon: Icons.inventory_2_outlined,
          label: AppStrings.statTotalProducts,
          value: '${stats.totalProducts}',
          color: AppColors.primary,
          onTap: () => controller.openTab(HomeTab.products),
        ),
        StatCard(
          icon: Icons.account_balance_wallet_outlined,
          label: AppStrings.statStockValue,
          value: Formatters.currency(stats.stockValue),
          color: AppColors.success,
          onTap: () => controller.openTab(HomeTab.products),
        ),
        StatCard(
          icon: Icons.warning_amber_rounded,
          label: AppStrings.statLowStock,
          value: '${stats.lowStockCount}',
          color: stats.lowStockCount > 0 ? AppColors.danger : AppColors.success,
          onTap: controller.openLowStock,
        ),
        StatCard(
          icon: Icons.receipt_long_outlined,
          label: AppStrings.statPendingOrders,
          value: '${stats.pendingPos}',
          color: AppColors.warning,
          onTap: () => controller.openTab(HomeTab.orders),
        ),
        StatCard(
          icon: Icons.local_shipping_outlined,
          label: AppStrings.statSuppliers,
          value: '${stats.totalSuppliers}',
          color: AppColors.primary,
          onTap: () => controller.openTab(HomeTab.suppliers),
        ),
      ],
    );
  }

  Widget _buildChart() {
    final stats = data.stats;
    return SectionCard(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  AppStrings.chartPurchasesTitle,
                  style: TextStyle(
                    fontSize: AppDimensions.fontTitle,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (stats.hasPurchases)
                Text(
                  AppStrings.chartWeekTotal(Formatters.currency(stats.weekTotal)),
                  style: const TextStyle(
                    fontSize: AppDimensions.fontCaption,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceL),
          if (stats.hasPurchases)
            PurchasesChart(days: stats.purchasesLast7Days)
          else
            const InlineMessage(
              icon: Icons.bar_chart,
              message: AppStrings.chartPurchasesEmpty,
            ),
        ],
      ),
    );
  }

  Widget _buildLowStock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: AppStrings.lowStockSectionTitle,
          actionLabel: data.lowStock.isEmpty ? null : AppStrings.viewAll,
          onAction: controller.openLowStock,
        ),
        const SizedBox(height: AppDimensions.spaceS),
        if (data.lowStock.isEmpty)
          const SectionCard(
            child: InlineMessage(
              icon: Icons.check_circle_outline,
              color: AppColors.success,
              message: AppStrings.lowStockAllGood,
            ),
          )
        else
          for (final product in data.lowStock)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spaceS),
              child: LowStockTile(
                key: ValueKey(product.id),
                product: product,
                onTap: () => controller.openProduct(product),
              ),
            ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: AppStrings.recentActivityTitle,
          actionLabel: data.recentMovements.isEmpty ? null : AppStrings.viewAll,
          onAction: () => controller.openTab(HomeTab.history),
        ),
        const SizedBox(height: AppDimensions.spaceS),
        if (data.recentMovements.isEmpty)
          const SectionCard(
            child: InlineMessage(
              icon: Icons.history,
              message: AppStrings.recentActivityEmpty,
            ),
          )
        else
          for (final movement in data.recentMovements)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spaceS),
              child: MovementCard(
                key: ValueKey(movement.id),
                movement: movement,
              ),
            ),
      ],
    );
  }
}
