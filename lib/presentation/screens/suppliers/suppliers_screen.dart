import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/suppliers_controller.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/supplier_model.dart';
import '../../widgets/app_search_field.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/paginated_grid_view.dart';
import '../../widgets/sort_menu.dart';
import '../../widgets/supplier_card.dart';

class SuppliersScreen extends GetView<SuppliersController> {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navSuppliers),
        actions: [
          SortMenu<SupplierSort>(
            options: SupplierSort.values,
            selected: () => controller.sort.value,
            labelOf: (s) => s.label,
            onSelected: controller.selectSort,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.openForm(),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.addSupplier),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.pagePadding).copyWith(
              top: AppDimensions.spaceS,
              bottom: AppDimensions.spaceS,
            ),
            child: AppSearchField(
              hint: AppStrings.searchSuppliersHint,
              onChanged: controller.onSearchChanged,
            ),
          ),
          Expanded(
            child: PaginatedGridView<SupplierModel>(
              controller: controller,
              itemHeight: AppDimensions.supplierCardHeight,
              itemBuilder: (supplier) => SupplierCard(
                key: ValueKey(supplier.id),
                supplier: supplier,
                onTap: () => controller.openForm(supplier),
                onDelete: () => controller.deleteSupplier(supplier),
              ),
              emptyBuilder: () {
                final filtered = controller.hasActiveFilters;
                return EmptyState(
                  icon: filtered ? Icons.search_off : Icons.local_shipping_outlined,
                  title: filtered
                      ? AppStrings.emptyFilteredTitle
                      : AppStrings.emptySuppliersTitle,
                  message: filtered
                      ? AppStrings.emptyFilteredMessage
                      : AppStrings.emptySuppliersMessage,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}