import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final Color? color;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: color != null
            ? OutlinedButton.styleFrom(
                side: BorderSide(color: color!, width: 2),
                foregroundColor: color,
              )
            : null,
        child: Text(text, style: textColor != null ? TextStyle(color: textColor) : null),
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: color != null
          ? ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: textColor ?? Colors.white)
          : null,
      child: Text(text),
    );
  }
}
