import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/purchase_orders_controller.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/purchase_order_model.dart';
import '../../widgets/app_search_field.dart';
import '../../widgets/choice_chip_row.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/paginated_grid_view.dart';
import '../../widgets/po_card.dart';
import '../../widgets/sort_menu.dart';

class PurchaseOrdersScreen extends GetView<PurchaseOrdersController> {
  const PurchaseOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navOrders),
        actions: [
          SortMenu<PoSort>(
            options: PoSort.values,
            selected: () => controller.sort.value,
            labelOf: (s) => s.label,
            onSelected: controller.selectSort,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.openCreate,
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.newOrder),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.pagePadding).copyWith(
              top: AppDimensions.spaceS,
              bottom: AppDimensions.spaceS,
            ),
            child: AppSearchField(
              hint: AppStrings.searchOrdersHint,
              onChanged: controller.onSearchChanged,
            ),
          ),
          Obx(
                () => ChoiceChipRow(
              options: [
                ChipOption(
                  label: AppStrings.filterAll,
                  selected: controller.statusFilter.value == null,
                  onTap: () => controller.selectStatus(null),
                ),
                for (final status in PoStatus.values)
                  ChipOption(
                    label: status.label,
                    selected: controller.statusFilter.value == status,
                    onTap: () => controller.selectStatus(status),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXS),
          Expanded(
            child: PaginatedGridView<PurchaseOrderModel>(
              controller: controller,
              itemHeight: AppDimensions.poCardHeight,
              itemBuilder: (order) => PoCard(
                key: ValueKey(order.id),
                order: order,
                onTap: () => controller.openDetail(order),
              ),
              emptyBuilder: () {
                final filtered = controller.hasActiveFilters;
                return EmptyState(
                  icon: filtered ? Icons.search_off : Icons.receipt_long_outlined,
                  title: filtered
                      ? AppStrings.emptyFilteredTitle
                      : AppStrings.emptyOrdersTitle,
                  message: filtered
                      ? AppStrings.emptyFilteredMessage
                      : AppStrings.emptyOrdersMessage,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}