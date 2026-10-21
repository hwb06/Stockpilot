extension StringX on String {
  String? get nullIfBlank {
    final t = trim();
    return t.isEmpty ? null : t;
  }

  String get searchSafe => trim().replaceAll(RegExp(r'[,()%*]'), ' ');
}