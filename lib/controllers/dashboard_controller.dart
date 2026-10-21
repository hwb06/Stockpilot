import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_db.dart';
import '../core/constants/app_enums.dart';
import '../core/constants/app_routes.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_values.dart';
import '../core/errors/app_exception.dart';
import '../core/utils/app_snackbar.dart';
import '../core/utils/debouncer.dart';
import '../data/models/dashboard_data.dart';
import '../data/models/product_model.dart';
import '../data/repositories/dashboard_repository.dart';
import '../services/supabase_service.dart';
import 'auth_controller.dart';
import 'home_controller.dart';

class DashboardController extends GetxController {
  DashboardController(this._repo, this._supabase, this._auth, this._home);

  final DashboardRepository _repo;
  final SupabaseService _supabase;
  final AuthController _auth;
  final HomeController _home;

  // ---- State ----
  final state = ViewState.loading.obs;
  final errorMessage = ''.obs;
  final data = Rxn<DashboardData>();

  int _requestId = 0;

  final _realtimeDebouncer = Debouncer(delay: AppValues.realtimeDebounce);
  final _channels = <RealtimeChannel>[];

  // ---- Header ----
  String get displayName => _auth.user.value?.fullName ?? '';

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < AppValues.afternoonStartHour) return AppStrings.greetingMorning;
    if (hour < AppValues.eveningStartHour) return AppStrings.greetingAfternoon;
    return AppStrings.greetingEvening;
  }

  @override
  void onInit() {
    super.onInit();
    load();
    _subscribeRealtime();
  }

  // ---------- Loading ----------

  Future<void> load({bool showLoader = true}) =>
      _fetch(showLoader: showLoader, silent: false);

  Future<void> onPullToRefresh() => load(showLoader: false);

  Future<void> _syncSilently() => _fetch(showLoader: false, silent: true);

  Future<void> _fetch({required bool showLoader, required bool silent}) async {
    final id = ++_requestId;
    if (showLoader) state.value = ViewState.loading;
    try {
      final result = await _repo.fetchDashboard();
      if (id != _requestId) return;
      data.value = result;
      state.value = result.isEmpty ? ViewState.empty : ViewState.success;
    } on AppException catch (e) {
      if (id != _requestId || silent) return;
      if (showLoader || data.value == null) {
        errorMessage.value = e.message;
        state.value = ViewState.error;
      } else {
        AppSnackbar.error(e.message);
      }
    }
  }

  // ---------- Realtime ----------

  void _subscribeRealtime() {
    const tables = {
      AppDb.dashboardProductsChannel: AppDb.products,
      AppDb.dashboardSuppliersChannel: AppDb.suppliers,
      AppDb.dashboardPurchaseOrdersChannel: AppDb.purchaseOrders,
      AppDb.dashboardMovementsChannel: AppDb.stockMovements,
    };
    tables.forEach((channelName, table) {
      _channels.add(
        _supabase.subscribeToTable(
          channelName: channelName,
          table: table,
          onChange: () => _realtimeDebouncer.run(_syncSilently),
        ),
      );
    });
  }

  // ---------- Navigation / actions ----------

  void openTab(HomeTab tab) => _home.openTab(tab);

  void openLowStock() => _home.showLowStock();

  Future<void> openProduct(ProductModel product) async {
    final saved = await Get.toNamed(AppRoutes.productForm, arguments: product);
    if (saved == true) await load(showLoader: false);
  }

  Future<void> logout() => _auth.confirmSignOut();

  @override
  void onClose() {
    _realtimeDebouncer.dispose();
    for (final channel in _channels) {
      _supabase.removeChannel(channel);
    }
    _channels.clear();
    super.onClose();
  }
}
