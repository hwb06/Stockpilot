import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';

class TextInputDialog extends StatefulWidget {
  const TextInputDialog({super.key, required this.title, required this.label});

  final String title;
  final String label;

  static Future<String?> show({required String title, required String label}) {
    return Get.dialog<String>(TextInputDialog(title: title, label: label));
  }

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Get.back(result: _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: widget.label),
          validator: (v) => Validators.required(v, widget.label),
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(onPressed: _submit, child: const Text(AppStrings.add)),
      ],
    );
  }
}
