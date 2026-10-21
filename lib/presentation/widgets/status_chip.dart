import 'package:flutter/material.dart';
import '../../core/constants/app_enums.dart';
import 'label_chip.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final PoStatus status;

  @override
  Widget build(BuildContext context) =>
      LabelChip(label: status.label, color: status.color);
}