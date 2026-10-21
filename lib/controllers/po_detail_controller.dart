import 'package:get/get.dart';
import '../core/constants/app_enums.dart';
import '../core/constants/app_strings.dart';
import '../core/errors/app_exception.dart';
import '../core/utils/app_snackbar.dart';
import '../data/models/purchase_order_model.dart';
import '../data/repositories/purchase_order_repository.dart';
import '../presentation/widgets/confirm_dialog.dart';

class PoDetailController extends GetxController {
  PoDetailController(this._repo);

  final PurchaseOrderRepository _repo;

  late final String poId;

  final state = ViewState.loading.obs;
  final errorMessage = ''.obs;
  final order = Rxn<PurchaseOrderModel>();
  final isActing = false.obs;

  @override
  void onInit() {
    super.onInit();
    poId = Get.arguments as String;
    load();
  }

  Future<void> load({bool showLoader = true}) async {
    if (showLoader) state.value = ViewState.loading;
    try {
      order.value = await _repo.fetchById(poId);
      state.value = ViewState.success;
    } on AppException catch (e) {
      if (showLoader || order.value == null) {
        errorMessage.value = e.message;
        state.value = ViewState.error;
      } else {
        AppSnackbar.error(e.message);
      }
    }
  }

  Future<void> markOrdered() => _run(
        () => _repo.updateStatus(poId, PoStatus.ordered),
    AppStrings.poMarkedOrdered,
  );

  Future<void> cancel() async {
    final po = order.value;
    if (po == null) return;
    final confirmed = await ConfirmDialog.show(
      title: AppStrings.cancelOrderTitle,
      message: AppStrings.cancelOrderMessage(po.poNumber),
      confirmText: AppStrings.confirm,
      cancelText: AppStrings.no,
    );
    if (!confirmed) return;
    await _run(
          () => _repo.updateStatus(poId, PoStatus.cancelled),
      AppStrings.poCancelledMessage,
    );
  }

  Future<void> receive() async {
    final po = order.value;
    if (po == null) return;
    final confirmed = await ConfirmDialog.show(
      title: AppStrings.receiveTitle,
      message: AppStrings.receiveMessage(po.poNumber),
      confirmText: AppStrings.confirm,
      cancelText: AppStrings.cancel,
      isDestructive: false,
    );
    if (!confirmed) return;
    await _run(() => _repo.receive(poId), AppStrings.poReceivedMessage);
  }

  Future<void> _run(Future<void> Function() action, String successMessage) async {
    if (isActing.value) return;
    isActing.value = true;
    try {
      await action();
      await load(showLoader: false);
      AppSnackbar.success(successMessage);
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isActing.value = false;
    }
  }
}