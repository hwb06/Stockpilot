import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../constants/app_values.dart';

class Validators {
  Validators._();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _phoneRegex = RegExp(r'^\+?[0-9\s\-]{7,15}$');

  static String? required(String? v, String field) {
    if (v == null || v.trim().isEmpty) return AppStrings.fieldRequired(field);
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return AppStrings.emailRequired;
    if (!_emailRegex.hasMatch(v.trim())) return AppStrings.emailInvalid;
    return null;
  }

  static String? optionalEmail(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return _emailRegex.hasMatch(v.trim()) ? null : AppStrings.emailInvalid;
  }

  static String? optionalPhone(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return _phoneRegex.hasMatch(v.trim()) ? null : AppStrings.invalidPhone;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return AppStrings.passwordRequired;
    if (v.length < AppValues.minPasswordLength) {
      return AppStrings.passwordTooShort(AppValues.minPasswordLength);
    }
    return null;
  }

  static String? Function(String?) confirmPassword(
    TextEditingController original,
  ) {
    return (v) {
      if (v == null || v.isEmpty) return AppStrings.confirmPasswordRequired;
      if (v != original.text) return AppStrings.passwordMismatch;
      return null;
    };
  }

  static String? nonNegativeNumber(String? v, String field) {
    if (v == null || v.trim().isEmpty) return AppStrings.fieldRequired(field);
    final number = double.tryParse(v.trim());
    if (number == null) return AppStrings.invalidNumber;
    if (number < 0) return AppStrings.negativeNotAllowed;
    return null;
  }

  static String? nonNegativeInt(String? v, String field) {
    if (v == null || v.trim().isEmpty) return AppStrings.fieldRequired(field);
    final number = int.tryParse(v.trim());
    if (number == null) return AppStrings.invalidInteger;
    if (number < 0) return AppStrings.negativeNotAllowed;
    return null;
  }

  static String? positiveInt(String? v, String field) {
    if (v == null || v.trim().isEmpty) return AppStrings.fieldRequired(field);
    final number = int.tryParse(v.trim());
    if (number == null) return AppStrings.invalidInteger;
    if (number <= 0) return AppStrings.mustBePositive;
    return null;
  }
}
