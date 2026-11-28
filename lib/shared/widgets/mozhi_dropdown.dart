import 'package:flutter/material.dart';
import 'package:mozhivora/app/theme/tokens.dart';

/// Unified dropdown with consistent fill, border, focus, and disabled states.
class MozhiDropdown<T> extends StatelessWidget {
  const MozhiDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.hint,
    this.enabled = true,
  });

  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final Widget? hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 160, minHeight: 48),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        hint: hint,
        onChanged: enabled ? onChanged : null,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: MozhiTokens.space12,
            vertical: MozhiTokens.space12,
          ),
        ),
      ),
    );
  }
}
