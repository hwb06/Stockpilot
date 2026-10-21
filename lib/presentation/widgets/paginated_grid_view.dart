import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/base/paginated_list_controller.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_enums.dart';
import '../../core/constants/app_values.dart';
import 'error_state.dart';
import 'list_shimmer.dart';
import 'scrollable_fill.dart';

class PaginatedGridView<T> extends StatelessWidget {
  const PaginatedGridView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    required this.itemHeight,
    required this.emptyBuilder,
  });

  final PaginatedListController<T> controller;
  final Widget Function(T item) itemBuilder;
  final double itemHeight;
  final Widget Function() emptyBuilder;

  bool _onNotification(Notification notification) {
    ScrollMetrics? metrics;
    if (notification is ScrollNotification) {
      metrics = notification.metrics;
    } else if (notification is ScrollMetricsNotification) {
      metrics = notification.metrics;
    }
    if (metrics != null && metrics.extentAfter < AppValues.loadMoreThreshold) {
      controller.loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.onPullToRefresh,
      child: Obx(() {
        switch (controller.state.value) {
          case ViewState.loading:
            return ListShimmer(itemHeight: itemHeight);
          case ViewState.error:
            return ScrollableFill(
              child: ErrorState(
                message: controller.errorMessage.value,
                onRetry: () => controller.load(),
              ),
            );
          case ViewState.empty:
            return ScrollableFill(child: emptyBuilder());
          case ViewState.success:
            return _buildList();
        }
      }),
    );
  }

  int _columnCount(double width) {
    final count =
    (width / (AppDimensions.gridMaxExtent + AppDimensions.spaceM)).ceil();
    return count < 1 ? 1 : count;
  }

  Widget _buildRow(List<T> items, int row, int columns) {
    final children = <Widget>[];
    for (var col = 0; col < columns; col++) {
      final index = row * columns + col;
      if (col > 0) children.add(const SizedBox(width: AppDimensions.spaceM));
      children.add(
        Expanded(
          child: index < items.length
              ? itemBuilder(items[index])
              : const SizedBox.shrink(),
        ),
      );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _buildList() {
    return NotificationListener<Notification>(
      onNotification: _onNotification,
      child: Obx(() {
        // toList() reads the RxList here, inside Obx, so changes rebuild us.
        final items = controller.items.toList();
        final loadingMore = controller.isLoadingMore.value;

        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.pagePadding,
                AppDimensions.spaceS,
                AppDimensions.pagePadding,
                AppDimensions.fabClearance,
              ),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final columns = _columnCount(constraints.crossAxisExtent);
                  final rowCount = (items.length / columns).ceil();
                  return SliverList.builder(
                    itemCount: rowCount,
                    itemBuilder:
                        (_, row) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.spaceM,
                      ),
                      child: _buildRow(items, row, columns),
                    ),
                  );
                },
              ),
            ),
            if (loadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: AppDimensions.fabClearance),
                  child: Center(
                    child: SizedBox(
                      width: AppDimensions.loaderSize,
                      height: AppDimensions.loaderSize,
                      child: CircularProgressIndicator(strokeWidth: AppDimensions.loaderStroke),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}