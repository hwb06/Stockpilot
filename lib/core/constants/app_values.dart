class AppValues {
  AppValues._();

  static const pageSize = 20;
  static const loadMoreThreshold = 240.0;
  static const searchDebounce = Duration(milliseconds: 400);
  static const realtimeDebounce = Duration(milliseconds: 500);


  static const minPasswordLength = 6;
  static const defaultMinStock = 5;
  static const currencyDecimals = 2;
  static const maxPriceDecimals = 2;

  static const imageMaxWidth = 1024.0;
  static const imageQuality = 80;
  static const defaultImageExtension = 'jpg';

  static const shimmerItemCount = 8;

  static const pickerLimit = 100;
  static const dateFormat = 'dd MMM yyyy';
  static const dateTimeFormat = 'dd MMM yyyy, hh:mm a';

  static const historyYearsBack = 5;

  // Dashboard
  static const dashboardListLimit = 5;
  static const dashboardShimmerStatCount = 4;
  static const dashboardShimmerRowCount = 3;
  static const afternoonStartHour = 12;
  static const eveningStartHour = 17;
  static const weekdayFormat = 'E';
  static const chartHeadroom = 1.2;
  static const chartGridLines = 4.0;
  static const chartPastBarAlpha = 0.55;
  static const softAlpha = 0.12;
  static const signupRedirectGuard = Duration(milliseconds: 500);
  static const snackbarDuration = Duration(seconds: 3);

}
