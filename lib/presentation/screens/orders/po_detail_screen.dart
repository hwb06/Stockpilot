import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/po_detail_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/purchase_order_model.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/error_state.dart';
import '../../widgets/list_shimmer.dart';
import '../../widgets/scrollable_fill.dart';
import '../../widgets/status_chip.dart';

class PoDetailScreen extends GetView<PoDetailController> {
  const PoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
              () => Text(controller.order.value?.poNumber ?? AppStrings.poDetailTitle),
        ),
      ),
      bottomNavigationBar: Obx(() {
        final order = controller.order.value;
        if (order == null || !order.hasActions) return const SizedBox.shrink();
        return _ActionBar(controller: controller, order: order);
      }),
      body: RefreshIndicator(
        onRefresh: () => controller.load(showLoader: false),
        child: Obx(() {
          switch (controller.state.value) {
            case ViewState.loading:
              return const ListShimmer(itemCount: 4, itemHeight: AppDimensions.poCardHeight);
            case ViewState.error:
              return ScrollableFill(
                child: ErrorState(
                  message: controller.errorMessage.value,
                  onRetry: () => controller.load(),
                ),
              );
            case ViewState.empty:
            case ViewState.success:
              final order = controller.order.value;
              if (order == null) return const SizedBox.shrink();
              return _Content(order: order);
          }
        }),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.order});

  final PurchaseOrderModel order;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppDimensions.pagePadding),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppDimensions.formMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InfoCard(order: order),
                const SizedBox(height: AppDimensions.spaceXL),
                const Text(
                  AppStrings.itemsTitle,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppDimensions.fontLarge),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                for (final item in order.items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.spaceM),
                    child: _ItemRow(item: item),
                  ),
                const SizedBox(height: AppDimensions.spaceS),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      AppStrings.totalLabel,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: AppDimensions.fontTitle),
                    ),
                    Text(
                      Formatters.currency(order.totalAmount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimensions.fontHeading,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.order});

  final PurchaseOrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.pagePadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.poNumber,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppDimensions.fontLarge),
              ),
              StatusChip(status: order.status),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceL),
          _InfoRow(label: AppStrings.supplierLabel, value: order.supplierName ?? ''),
          if (order.supplierPhone != null)
            _InfoRow(label: AppStrings.fieldPhone, value: order.supplierPhone!),
          _InfoRow(
            label: AppStrings.orderDateLabel,
            value: Formatters.dateTime(order.orderDate),
          ),
          if (order.receivedAt != null)
            _InfoRow(
              label: AppStrings.receivedDateLabel,
              value: Formatters.dateTime(order.receivedAt),
            ),
          if (order.notes != null)
            _InfoRow(label: AppStrings.notesLabel, value: order.notes!),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppDimensions.labelColumnWidth,
            child: Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final PurchaseOrderItemModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          AppNetworkImage(url: item.imageUrl, size: AppDimensions.avatarSize),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppDimensions.spaceXS),
                Text(
                  AppStrings.lineSummary(item.quantity, Formatters.currency(item.unitCost)),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: AppDimensions.fontLabel),
                ),
              ],
            ),
          ),
          Text(
            Formatters.currency(item.lineTotal),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.controller, required this.order});

  final PoDetailController controller;
  final PurchaseOrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.pagePadding),
          child: Obx(() {
            final busy = controller.isActing.value;
            return Row(
              children: [
                if (order.canCancel)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: busy ? null : controller.cancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
                      ),
                      child: const Text(AppStrings.cancelOrder),
                    ),
                  ),
                if (order.canCancel) const SizedBox(width: AppDimensions.spaceM),
                if (order.canMarkOrdered)
                  Expanded(
                    child: AppButton(
                      label: AppStrings.markAsOrdered,
                      isLoading: busy,
                      onPressed: controller.markOrdered,
                    ),
                  ),
                if (order.canReceive)
                  Expanded(
                    child: AppButton(
                      label: AppStrings.markAsReceived,
                      isLoading: busy,
                      onPressed: controller.receive,
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}