class AppStrings {
  AppStrings._();

  // App
  static const appName = 'StockPilot';
  static const tagline = 'Inventory & Purchases, simplified';
  static const currencySymbol = 'Rs ';

  // Navigation
  static const navDashboard = 'Dashboard';
  static const navProducts = 'Products';
  static const navSuppliers = 'Suppliers';
  static const navOrders = 'Orders';
  static const navHistory = 'History';

  // Common actions
  static const retry = 'Retry';
  static const cancel = 'Cancel';
  static const save = 'Save';
  static const delete = 'Delete';
  static const edit = 'Edit';
  static const add = 'Add';
  static const yes = 'Yes';
  static const no = 'No';
  static const logoutTooltip = 'Log out';
  static const logoutTitle = 'Log out';
  static const logoutMessage = 'Are you sure you want to log out?';
  static const somethingWentWrong = 'Something went wrong';
  static const comingSoon = 'Coming Soon';
  static const snackSuccessTitle = 'Success';
  static const snackErrorTitle = 'Error';

  // Products: list
  static const searchProductsHint = 'Search by name or SKU';
  static const addProduct = 'Add Product';
  static const sortTooltip = 'Sort';
  static const filterAll = 'All';
  static const filterLowStock = 'Low stock';
  static const filterOutOfStock = 'Out of stock';
  static const allCategories = 'All categories';
  static const emptyProductsTitle = 'No products yet';
  static const emptyProductsMessage =
      'Tap "Add Product" to create your first product.';
  static const emptyFilteredTitle = 'No matching products';
  static const emptyFilteredMessage =
      'Try a different search or change the filters.';
  static const outOfStock = 'Out of stock';

  // Sorting
  static const sortNewest = 'Newest first';
  static const sortNameAsc = 'Name (A-Z)';
  static const sortNameDesc = 'Name (Z-A)';
  static const sortPriceLow = 'Price: low to high';
  static const sortPriceHigh = 'Price: high to low';
  static const sortStockLow = 'Stock: low to high';
  static const sortStockHigh = 'Stock: high to low';

  // Products: form
  static const newProduct = 'New Product';
  static const editProduct = 'Edit Product';
  static const fieldName = 'Product name';
  static const fieldSku = 'SKU';
  static const fieldCategory = 'Category';
  static const fieldPrice = 'Selling price';
  static const fieldCostPrice = 'Cost price';
  static const fieldStock = 'Opening stock';
  static const fieldCurrentStock = 'Current stock';
  static const fieldMinStock = 'Minimum stock level';
  static const fieldDescription = 'Description (optional)';
  static const noCategory = 'No category';
  static const addCategoryTooltip = 'Add category';
  static const newCategoryTitle = 'New category';
  static const fieldCategoryName = 'Category name';
  static const stockEditHint =
      'Stock changes are made through stock adjustments';
  static const addPhoto = 'Add photo';
  static const takePhoto = 'Take a photo';
  static const chooseFromGallery = 'Choose from gallery';
  static const removePhoto = 'Remove photo';

  // Products: messages
  static const productCreated = 'Product created successfully';
  static const productUpdated = 'Product updated successfully';
  static const productDeleted = 'Product deleted';
  static const deleteProductTitle = 'Delete product';

  // Errors
  static const errGeneric = 'Something went wrong. Please try again.';
  static const errNetwork =
      'No internet connection. Please check your network.';
  static const errDuplicateSku = 'A product with this SKU already exists.';
  static const errDuplicate = 'This name already exists.';
  static const errInUse =
      'This item is used in other records and cannot be deleted.';
  static const errInvalid = 'Invalid value. Please check your input.';
  static const errImagePick = 'Unable to pick the image.';
  static const errImageUpload = 'Unable to upload the image. Please try again.';

  // Validation
  static const emailRequired = 'Email is required';
  static const emailInvalid = 'Enter a valid email';
  static const passwordRequired = 'Password is required';
  static const confirmPasswordRequired = 'Please confirm your password';
  static const passwordMismatch = 'Passwords do not match';
  static const invalidNumber = 'Enter a valid number';
  static const invalidInteger = 'Enter a whole number';
  static const negativeNotAllowed = 'Value cannot be negative';

  // Suppliers
  static const searchSuppliersHint = 'Search by name, phone or email';
  static const addSupplier = 'Add Supplier';
  static const newSupplier = 'New Supplier';
  static const editSupplier = 'Edit Supplier';
  static const emptySuppliersTitle = 'No suppliers yet';
  static const emptySuppliersMessage =
      'Tap "Add Supplier" to add the people you buy from.';
  static const fieldSupplierName = 'Supplier name';
  static const fieldEmail = 'Email (optional)';
  static const fieldPhone = 'Phone (optional)';
  static const fieldAddress = 'Address (optional)';
  static const noContactDetails = 'No contact details';
  static const supplierCreated = 'Supplier created successfully';
  static const supplierUpdated = 'Supplier updated successfully';
  static const supplierDeleted = 'Supplier deleted';
  static const deleteSupplierTitle = 'Delete supplier';
  static const invalidPhone = 'Enter a valid phone number';
  static const errSupplierInUse =
      'This supplier has purchase orders and cannot be deleted.';

  // Sorting (orders)
  static const sortOldest = 'Oldest first';
  static const sortAmountHigh = 'Amount: high to low';
  static const sortAmountLow = 'Amount: low to high';

  // Purchase orders: list
  static const searchOrdersHint = 'Search by PO number';
  static const newOrder = 'New Order';
  static const newPurchaseOrder = 'New Purchase Order';
  static const poDetailTitle = 'Order details';
  static const emptyOrdersTitle = 'No purchase orders yet';
  static const emptyOrdersMessage = 'Create an order to restock your products.';
  static const poDraft = 'Draft';
  static const poOrdered = 'Ordered';
  static const poReceived = 'Received';
  static const poCancelled = 'Cancelled';

  // Purchase orders: form
  static const fieldSupplier = 'Supplier';
  static const fieldNotes = 'Notes (optional)';
  static const itemsTitle = 'Items';
  static const addItem = 'Add item';
  static const noItemsYet = 'No items added yet';
  static const selectProductTitle = 'Select a product';
  static const unitCostLabel = 'Unit cost';
  static const lineTotalLabel = 'Line total';
  static const totalLabel = 'Total';
  static const saveDraft = 'Save as draft';
  static const placeOrder = 'Place order';
  static const noSuppliersHint =
      'No suppliers found. Add a supplier first from the Suppliers tab.';
  static const noProductsFound = 'No products found';
  static const errSelectSupplier = 'Please select a supplier';
  static const errAddItems = 'Add at least one item';
  static const draftSaved = 'Draft saved';
  static const orderPlaced = 'Order placed';

  // Purchase orders: detail and actions
  static const supplierLabel = 'Supplier';
  static const orderDateLabel = 'Order date';
  static const receivedDateLabel = 'Received on';
  static const notesLabel = 'Notes';
  static const markAsOrdered = 'Mark as ordered';
  static const markAsReceived = 'Mark as received';
  static const cancelOrder = 'Cancel order';
  static const confirm = 'Confirm';
  static const poMarkedOrdered = 'Order marked as ordered';
  static const poReceivedMessage = 'Stock updated from this order';
  static const poCancelledMessage = 'Order cancelled';
  static const receiveTitle = 'Receive stock';
  static const cancelOrderTitle = 'Cancel order';

  static String itemsCount(int n) => n == 1 ? '1 item' : '$n items';

  static String lineSummary(int qty, String cost) => '$qty x $cost';

  static String receiveMessage(String po) =>
      'Receive all items of $po? Product stock will be increased automatically.';

  static String cancelOrderMessage(String po) =>
      'Cancel $po? This cannot be undone.';

  static String deleteSupplierMessage(String name) =>
      'Delete "$name"? This action cannot be undone.';

  // Parameterised strings
  static String fieldRequired(String field) => '$field is required';

  static String passwordTooShort(int min) =>
      'Password must be at least $min characters';

  static String skuLabel(String sku) => 'SKU: $sku';

  static String inStock(int qty) => '$qty in stock';

  static String lowStock(int qty) => 'Low: $qty left';

  static String deleteProductMessage(String name) =>
      'Delete "$name"? This action cannot be undone.';

  // History
  static const searchMovementsHint = 'Search by product name';
  static const adjustStock = 'Adjust stock';
  static const emptyHistoryTitle = 'No stock movements yet';
  static const emptyHistoryMessage =
      'Stock changes from purchases and adjustments will appear here.';
  static const movementInitial = 'Opening stock';
  static const movementPurchase = 'Purchase';
  static const movementAdjustment = 'Adjustment';
  static const dateRangeTooltip = 'Filter by date';

  static String stockAfterLabel(int n) => 'Stock: $n';

  static String signedQuantity(int n) => n > 0 ? '+$n' : '$n';

  static String dateRangeLabel(String from, String to) => '$from - $to';

  // Adjust stock
  static const adjustStockTitle = 'Adjust Stock';
  static const selectProduct = 'Select product';
  static const changeProduct = 'Change';
  static const addStock = 'Add stock';
  static const removeStock = 'Remove stock';
  static const fieldAdjustQty = 'Quantity';
  static const fieldReason = 'Reason (optional)';
  static const adjustSaved = 'Stock adjusted successfully';
  static const errSelectProduct = 'Please select a product';
  static const mustBePositive = 'Value must be greater than zero';

  static String currentStockLabel(int n) => 'Current stock: $n';

  static String newStockLabel(int n) => 'New stock will be $n';

  static String errRemoveTooMuch(int stock) =>
      'You can remove at most $stock units';

  // Dashboard
  static const greetingMorning = 'Good morning';
  static const greetingAfternoon = 'Good afternoon';
  static const greetingEvening = 'Good evening';
  static const statTotalProducts = 'Total products';
  static const statStockValue = 'Stock value';
  static const statLowStock = 'Low stock items';
  static const statPendingOrders = 'Pending orders';
  static const statSuppliers = 'Suppliers';
  static const chartPurchasesTitle = 'Purchases (last 7 days)';
  static const chartPurchasesEmpty = 'No purchases in the last 7 days';
  static const lowStockSectionTitle = 'Low stock alerts';
  static const lowStockAllGood = 'All products are well stocked';
  static const recentActivityTitle = 'Recent activity';
  static const recentActivityEmpty = 'No stock movements yet';
  static const viewAll = 'View all';
  static const dashboardEmptyTitle = 'Welcome to StockPilot';
  static const dashboardEmptyMessage =
      'Add your first product to start tracking your inventory.';
  static const dashboardEmptyAction = 'Add products';

  static String minStockLabel(int n) => 'Min: $n';

  static String chartWeekTotal(String amount) => 'Total: $amount';

  // Auth
  static const welcomeBack = 'Welcome back';
  static const loginSubtitle = 'Log in to manage $appName';
  static const logIn = 'Log In';
  static const register = 'Register';
  static const noAccountPrompt = "Don't have an account?";
  static const createAccountTitle = 'Create account';
  static const createAccountButton = 'Create Account';
  static const registerSubtitle = 'Start tracking your inventory in minutes';
  static const authEmail = 'Email';
  static const authPassword = 'Password';
  static const authFullName = 'Full name';
  static const authConfirmPassword = 'Confirm password';
  static const accountCreated = 'Account created successfully. Please log in.';
  static const errSignIn = 'Unable to sign in. Check your internet connection.';
  static const errRegister =
      'Unable to register. Check your internet connection.';
  static const errSignOut = 'Unable to sign out. Please try again.';

  // Shared
  static const separator = '  •  ';
}
