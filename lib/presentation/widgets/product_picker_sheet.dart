import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_values.dart';
import '../../core/utils/debouncer.dart';
import '../../data/models/product_model.dart';
import 'app_network_image.dart';
import 'app_search_field.dart';

class ProductPickerSheet extends StatefulWidget {
  const ProductPickerSheet({super.key, required this.search});

  final Future<List<ProductModel>> Function(String query) search;

  static Future<ProductModel?> show(
      Future<List<ProductModel>> Function(String query) search,
      ) {
    return Get.bottomSheet<ProductModel>(
      ProductPickerSheet(search: search),
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusL)),
      ),
    );
  }

  @override
  State<ProductPickerSheet> createState() => _ProductPickerSheetState();
}

class _ProductPickerSheetState extends State<ProductPickerSheet> {
  final _debouncer = Debouncer(delay: AppValues.searchDebounce);
  List<ProductModel> _products = [];
  bool _loading = true;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _run('');
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  Future<void> _run(String query) async {
    final id = ++_requestId;
    setState(() => _loading = true);
    final result = await widget.search(query);
    if (!mounted || id != _requestId) return;
    setState(() {
      _products = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * AppDimensions.pickerSheetHeightFactor;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimensions.pagePadding),
              child: Column(
                children: [
                  const Text(
                    AppStrings.selectProductTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppDimensions.fontLarge),
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  AppSearchField(
                    hint: AppStrings.searchProductsHint,
                    onChanged: (q) => _debouncer.run(() => _run(q.trim())),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _products.isEmpty
                  ? const Center(child: Text(AppStrings.noProductsFound))
                  : ListView.separated(
                itemCount: _products.length,
                separatorBuilder: (_, __) => const Divider(height: AppDimensions.dividerThickness),
                itemBuilder: (_, i) {
                  final p = _products[i];
                  return ListTile(
                    leading: AppNetworkImage(
                      url: p.imageUrl,
                      size: AppDimensions.avatarSize,
                    ),
                    title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                      '${AppStrings.skuLabel(p.sku)}${AppStrings.separator}${AppStrings.inStock(p.stockQty)}',
                    ),
                    onTap: () => Get.back(result: p),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}