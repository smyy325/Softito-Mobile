import 'package:flutter/material.dart';

/// Ortak kullanılan Material 3 uyumlu TextFormField bileşeni
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool readOnly;

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          validator: validator,
          maxLines: maxLines,
          minLines: minLines,
          focusNode: focusNode,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          readOnly: readOnly,
          cursorColor: colorScheme.primary,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: colorScheme.primary)
                : null,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
