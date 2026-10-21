import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/products_controller.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/product_model.dart';
import '../../widgets/app_search_field.dart';
import '../../widgets/choice_chip_row.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/paginated_grid_view.dart';
import '../../widgets/product_card.dart';
import '../../widgets/sort_menu.dart';

class ProductsScreen extends GetView<ProductsController> {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navProducts),
        actions: [
          SortMenu<ProductSort>(
            options: ProductSort.values,
            selected: () => controller.sort.value,
            labelOf: (s) => s.label,
            onSelected: controller.selectSort,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.openForm(),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.addProduct),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.pagePadding).copyWith(
              top: AppDimensions.spaceS,
              bottom: AppDimensions.spaceS,
            ),
            child: AppSearchField(
              hint: AppStrings.searchProductsHint,
              onChanged: controller.onSearchChanged,
            ),
          ),
          _StockFilterRow(controller: controller),
          _CategoryFilterRow(controller: controller),
          const SizedBox(height: AppDimensions.spaceXS),
          Expanded(
            child: PaginatedGridView<ProductModel>(
              controller: controller,
              itemHeight: AppDimensions.productCardHeight,
              itemBuilder: (product) => ProductCard(
                key: ValueKey(product.id),
                product: product,
                onTap: () => controller.openForm(product),
                onDelete: () => controller.deleteProduct(product),
              ),
              emptyBuilder: () {
                final filtered = controller.hasActiveFilters;
                return EmptyState(
                  icon: filtered ? Icons.search_off : Icons.inventory_2_outlined,
                  title: filtered
                      ? AppStrings.emptyFilteredTitle
                      : AppStrings.emptyProductsTitle,
                  message: filtered
                      ? AppStrings.emptyFilteredMessage
                      : AppStrings.emptyProductsMessage,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StockFilterRow extends StatelessWidget {
  const _StockFilterRow({required this.controller});

  final ProductsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => ChoiceChipRow(
        options: [
          for (final filter in StockFilter.values)
            ChipOption(
              label: filter.label,
              selected: controller.stockFilter.value == filter,
              onTap: () => controller.selectStockFilter(filter),
            ),
        ],
      ),
    );
  }
}

class _CategoryFilterRow extends StatelessWidget {
  const _CategoryFilterRow({required this.controller});

  final ProductsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.categories.isEmpty) return const SizedBox.shrink();
      return ChoiceChipRow(
        options: [
          ChipOption(
            label: AppStrings.allCategories,
            selected: controller.selectedCategoryId.value == null,
            onTap: () => controller.selectCategory(null),
          ),
          for (final category in controller.categories)
            ChipOption(
              label: category.name,
              selected: controller.selectedCategoryId.value == category.id,
              onTap: () => controller.selectCategory(category.id),
            ),
        ],
      );
    });
  }
}