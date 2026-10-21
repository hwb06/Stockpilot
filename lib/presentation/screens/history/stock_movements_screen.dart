import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/stock_movements_controller.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_values.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/stock_movement_model.dart';
import '../../widgets/app_search_field.dart';
import '../../widgets/choice_chip_row.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/movement_card.dart';
import '../../widgets/paginated_grid_view.dart';
import '../../widgets/sort_menu.dart';

class StockMovementsScreen extends GetView<StockMovementsController> {
  const StockMovementsScreen({super.key});

  Future<void> _pickRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - AppValues.historyYearsBack),
      lastDate: now,
      initialDateRange: controller.dateRange.value,
    );
    if (picked != null) controller.setDateRange(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navHistory),
        actions: [
          IconButton(
            tooltip: AppStrings.dateRangeTooltip,
            icon: const Icon(Icons.date_range),
            onPressed: () => _pickRange(context),
          ),
          SortMenu<MovementSort>(
            options: MovementSort.values,
            selected: () => controller.sort.value,
            labelOf: (s) => s.label,
            onSelected: controller.selectSort,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.openAdjust,
        icon: const Icon(Icons.tune),
        label: const Text(AppStrings.adjustStock),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.pagePadding).copyWith(
              top: AppDimensions.spaceS,
              bottom: AppDimensions.spaceS,
            ),
            child: AppSearchField(
              hint: AppStrings.searchMovementsHint,
              onChanged: controller.onSearchChanged,
            ),
          ),
          Obx(
                () => ChoiceChipRow(
              options: [
                ChipOption(
                  label: AppStrings.filterAll,
                  selected: controller.typeFilter.value == null,
                  onTap: () => controller.selectType(null),
                ),
                for (final type in StockMovementType.values)
                  ChipOption(
                    label: type.label,
                    selected: controller.typeFilter.value == type,
                    onTap: () => controller.selectType(type),
                  ),
              ],
            ),
          ),
          Obx(() {
            final range = controller.dateRange.value;
            if (range == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.pagePadding,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  avatar: const Icon(Icons.date_range, size: AppDimensions.popupIconSize),
                  label: Text(
                    AppStrings.dateRangeLabel(
                      Formatters.date(range.start),
                      Formatters.date(range.end),
                    ),
                  ),
                  onDeleted: () => controller.setDateRange(null),
                ),
              ),
            );
          }),
          const SizedBox(height: AppDimensions.spaceXS),
          Expanded(
            child: PaginatedGridView<StockMovementModel>(
              controller: controller,
              itemHeight: AppDimensions.movementCardHeight,
              itemBuilder: (movement) => MovementCard(
                key: ValueKey(movement.id),
                movement: movement,
              ),
              emptyBuilder: () {
                final filtered = controller.hasActiveFilters;
                return EmptyState(
                  icon: filtered ? Icons.search_off : Icons.history,
                  title: filtered
                      ? AppStrings.emptyFilteredTitle
                      : AppStrings.emptyHistoryTitle,
                  message: filtered
                      ? AppStrings.emptyFilteredMessage
                      : AppStrings.emptyHistoryMessage,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}