import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extension.dart';
import '../dashboard/dashboard_screen.dart';
import '../history/stock_movements_screen.dart';
import '../products/products_screen.dart';
import '../suppliers/suppliers_screen.dart';
import '../orders/purchase_orders_screen.dart';
import '../../../core/constants/app_dimensions.dart';

class _TabItem {
  const _TabItem(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  static const _tabs = [
    _TabItem(
      AppStrings.navDashboard,
      Icons.dashboard_outlined,
      Icons.dashboard,
    ),
    _TabItem(
      AppStrings.navProducts,
      Icons.inventory_2_outlined,
      Icons.inventory_2,
    ),
    _TabItem(
      AppStrings.navSuppliers,
      Icons.local_shipping_outlined,
      Icons.local_shipping,
    ),
    _TabItem(
      AppStrings.navOrders,
      Icons.receipt_long_outlined,
      Icons.receipt_long,
    ),
    _TabItem(AppStrings.navHistory, Icons.history_outlined, Icons.history),
  ];

  static const _pages = <Widget>[
    DashboardScreen(),
    ProductsScreen(),
    SuppliersScreen(),
    PurchaseOrdersScreen(),
    StockMovementsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = context.isWide;

    return Obx(() {
      final index = controller.currentIndex.value;
      // IndexedStack keeps each tab's state (scroll, filters) alive.
      final body = IndexedStack(index: index, children: _pages);

      if (isWide) {
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: index,
                onDestinationSelected: controller.changeTab,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final tab in _tabs)
                    NavigationRailDestination(
                      icon: Icon(tab.icon),
                      selectedIcon: Icon(tab.selectedIcon),
                      label: Text(tab.label),
                    ),
                ],
              ),
              const VerticalDivider(width: AppDimensions.dividerThickness),
              Expanded(child: body),
            ],
          ),
        );
      }

      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: controller.changeTab,
          destinations: [
            for (final tab in _tabs)
              NavigationDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.selectedIcon),
                label: tab.label,
              ),
          ],
        ),
      );
    });
  }
}
