import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../constants/app_strings.dart';
import '../constants/app_values.dart';

class Formatters {
  Formatters._();

  static final _currency = NumberFormat.currency(
    symbol: AppStrings.currencySymbol,
    decimalDigits: AppValues.currencyDecimals,
  );
  static final _date = DateFormat(AppValues.dateFormat);
  static final _dateTime = DateFormat(AppValues.dateTimeFormat);
  static final _weekday = DateFormat(AppValues.weekdayFormat);
  static final _compact = NumberFormat.compact();

  static String currency(num value) => _currency.format(value);

  static String date(DateTime? value) =>
      value == null ? '' : _date.format(value.toLocal());

  static String dateTime(DateTime? value) =>
      value == null ? '' : _dateTime.format(value.toLocal());

  /// Short weekday name (Mon, Tue ...), used on chart axes.
  static String weekday(DateTime value) => _weekday.format(value);

  /// 1200 -> 1.2K, used on chart axes where space is tight.
  static String compact(num value) => _compact.format(value);

  static String plainNumber(num value) =>
      value == value.roundToDouble()
          ? value.toInt().toString()
          : value.toString();
}

class InputFormatters {
  InputFormatters._();

  static final decimal = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(
      RegExp('^\\d*\\.?\\d{0,${AppValues.maxPriceDecimals}}'),
    ),
  ];

  static final digitsOnly = <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
  ];
}
