import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_enums.dart';
import '../../core/constants/app_values.dart';
import '../../core/errors/app_exception.dart';
import '../../core/utils/app_snackbar.dart';
import '../../core/utils/debouncer.dart';
import '../../services/supabase_service.dart';

abstract class PaginatedListController<T> extends GetxController {
  PaginatedListController(this._supabase);

  final SupabaseService _supabase;

  // ---- Provided by subclasses ----
  String get tableName;
  String get channelName;
  String idOf(T item);
  Future<List<T>> fetchPage({required int offset, required int limit});

  // ---- State ----
  final state = ViewState.loading.obs;
  final errorMessage = ''.obs;
  final items = <T>[].obs;
  final isLoadingMore = false.obs;
  final query = ''.obs;

  bool get hasActiveFilters => query.value.isNotEmpty;

  bool _hasMore = true;

  int _requestId = 0;

  final _searchDebouncer = Debouncer(delay: AppValues.searchDebounce);
  final _realtimeDebouncer = Debouncer(delay: AppValues.realtimeDebounce);
  RealtimeChannel? _channel;

  @override
  void onInit() {
    super.onInit();
    load();
    _channel = _supabase.subscribeToTable(
      channelName: channelName,
      table: tableName,
      onChange: () => _realtimeDebouncer.run(_syncSilently),
    );
  }

  // ---------- Loading ----------

  Future<void> load({bool showLoader = true}) async {
    final id = ++_requestId;
    if (showLoader) state.value = ViewState.loading;
    try {
      final result = await fetchPage(offset: 0, limit: AppValues.pageSize);
      if (id != _requestId) return;
      items.assignAll(result);
      _hasMore = result.length == AppValues.pageSize;
      state.value = result.isEmpty ? ViewState.empty : ViewState.success;
    } on AppException catch (e) {
      if (id != _requestId) return;
      if (showLoader || items.isEmpty) {
        errorMessage.value = e.message;
        state.value = ViewState.error;
      } else {
        AppSnackbar.error(e.message);
      }
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !_hasMore || state.value != ViewState.success) return;
    final id = _requestId;
    isLoadingMore.value = true;
    try {
      final result = await fetchPage(offset: items.length, limit: AppValues.pageSize);
      if (id != _requestId) return;
      final existing = items.map(idOf).toSet();
      items.addAll(result.where((item) => !existing.contains(idOf(item))));
      _hasMore = result.length == AppValues.pageSize;
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> onPullToRefresh() => load(showLoader: false);

  Future<void> _syncSilently() async {
    final id = ++_requestId;
    final limit = items.length < AppValues.pageSize ? AppValues.pageSize : items.length;
    try {
      final result = await fetchPage(offset: 0, limit: limit);
      if (id != _requestId) return;
      items.assignAll(result);
      _hasMore = result.length == limit;
      state.value = result.isEmpty ? ViewState.empty : ViewState.success;
    } on AppException {
    }
  }

  // ---------- Search ----------

  void onSearchChanged(String text) {
    _searchDebouncer.run(() {
      final trimmed = text.trim();
      if (trimmed == query.value) return;
      query.value = trimmed;
      load();
    });
  }

  // ---------- Helpers ----------

  void removeLocally(String id) {
    items.removeWhere((item) => idOf(item) == id);
    if (items.isEmpty) state.value = ViewState.empty;
  }

  @override
  void onClose() {
    _searchDebouncer.dispose();
    _realtimeDebouncer.dispose();
    final channel = _channel;
    if (channel != null) _supabase.removeChannel(channel);
    super.onClose();
  }
}