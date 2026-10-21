class AppDb {
  AppDb._();

  static const schema = 'public';

  // Tables
  static const products = 'products';
  static const categories = 'categories';
  static const suppliers = 'suppliers';
  static const purchaseOrders = 'purchase_orders';
  static const purchaseOrderItems = 'purchase_order_items';
  static const stockMovements = 'stock_movements';

  // Storage
  static const productImagesBucket = 'product-images';

  // Realtime channels
  static const productsChannel = 'products-changes';
  static const suppliersChannel = 'suppliers-changes';
  static const purchaseOrdersChannel = 'purchase-orders-changes';

  // RPC functions
  static const rpcCreatePo = 'create_purchase_order';
  static const rpcReceivePo = 'receive_purchase_order';

  // Dashboard (own channel names: never share a channel with a list controller)
  static const dashboardProductsChannel = 'dashboard-products-changes';
  static const dashboardSuppliersChannel = 'dashboard-suppliers-changes';
  static const dashboardPurchaseOrdersChannel = 'dashboard-purchase-orders-changes';
  static const dashboardMovementsChannel = 'dashboard-stock-movements-changes';
  static const rpcDashboardStats = 'get_dashboard_stats';

  // Postgres error codes
  static const pgUniqueViolation = '23505';
  static const pgForeignKeyViolation = '23503';
  static const pgCheckViolation = '23514';

  // Select strings (joins)
  static const productSelect = '*,${AppDb.categories}(${DbCol.name})';

  static const poListSelect =
      '*,${AppDb.suppliers}(${DbCol.name}),'
      '${DbCol.itemCountAlias}:${AppDb.purchaseOrderItems}(${DbCol.count})';

  static const poDetailSelect =
      '*,${AppDb.suppliers}(${DbCol.name},${DbCol.phone},${DbCol.email}),'
      '${AppDb.purchaseOrderItems}(*,'
      '${AppDb.products}(${DbCol.name},${DbCol.sku},${DbCol.imageUrl}))';

  // inside class AppDb
  static const stockMovementsChannel = 'stock-movements-changes';
  static const rpcAdjustStock = 'adjust_stock';
  static const movementProductName = 'products.name'; // filter on the joined table
  static const movementSelect =
      '*,${AppDb.products}!inner(${DbCol.name},${DbCol.sku},${DbCol.imageUrl})';


}

class DbCol {
  DbCol._();

  static const id = 'id';
  static const name = 'name';
  static const sku = 'sku';
  static const description = 'description';
  static const price = 'price';
  static const costPrice = 'cost_price';
  static const stockQty = 'stock_qty';
  static const minStock = 'min_stock';
  static const imageUrl = 'image_url';
  static const categoryId = 'category_id';
  static const isLowStock = 'is_low_stock';
  static const createdAt = 'created_at';

  // Suppliers
  static const email = 'email';
  static const phone = 'phone';
  static const address = 'address';

  // inside class DbCol
  static const type = 'type';
  static const quantityChange = 'quantity_change';
  static const stockAfter = 'stock_after';

  // Purchase orders
  static const supplierId = 'supplier_id';
  static const poNumber = 'po_number';
  static const status = 'status';
  static const totalAmount = 'total_amount';
  static const notes = 'notes';
  static const orderDate = 'order_date';
  static const receivedAt = 'received_at';

  static const productId = 'product_id';
  static const quantity = 'quantity';
  static const unitCost = 'unit_cost';

  // Aggregates
  static const count = 'count';
  static const itemCountAlias = 'item_count';
  static const note = 'note';

  // Auth user metadata
  static const fullName = 'full_name';
}

class DbParam {
  DbParam._();

  static const supplierId = 'p_supplier_id';
  static const items = 'p_items';
  static const notes = 'p_notes';
  static const status = 'p_status';
  static const poId = 'p_po_id';

  // inside class DbParam
  static const adjustProductId = 'p_product_id';
  static const adjustChange = 'p_change';
  static const adjustNote = 'p_note';
}

class DashboardKey {
  DashboardKey._();

  static const totalProducts = 'total_products';
  static const totalSuppliers = 'total_suppliers';
  static const stockValue = 'stock_value';
  static const lowStockCount = 'low_stock_count';
  static const pendingPos = 'pending_pos';
  static const purchasesLast7Days = 'purchases_last_7_days';
  static const day = 'day';
  static const total = 'total';
}
