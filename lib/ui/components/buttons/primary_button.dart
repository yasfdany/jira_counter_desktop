import 'package:flutter/material.dart';

import '../../../config/themes.dart';
import 'ripple_button.dart';

class PrimaryButton extends StatefulWidget {
  final String? text;
  final VoidCallback? onTap;
  final Color? rippleColor;
  final Color? color;
  final Color? disableColor;
  final Color? textColor;
  final Widget? child;
  final EdgeInsets? padding;
  final double radius;
  final Color? borderColor;
  final double borderWidth;
  final bool enable;
  final bool? lightButton;
  final TextStyle? buttonTextStyle;
  final bool showShadow;

  const PrimaryButton({
    Key? key,
    this.text,
    this.onTap,
    this.color,
    this.disableColor,
    this.rippleColor,
    this.textColor,
    this.child,
    this.padding,
    this.borderColor,
    this.borderWidth = 1,
    this.radius = 4,
    this.enable = true,
    this.lightButton,
    this.buttonTextStyle,
    this.showShadow = false,
  }) : super(key: key);

  @override
  PrimaryButtonState createState() => PrimaryButtonState();
}

class PrimaryButtonState extends State<PrimaryButton> {
  late Color borderColor;
  late Color rippleColor;
  late Color color;
  late Color textColor;
  late EdgeInsets padding;
  late bool lightButton;

  bool isLight() {
    return (color.red * 0.299 + color.green * 0.587 + color.blue * 0.114) > 186;
  }

  @override
  Widget build(BuildContext context) {
    color = widget.color ?? Themes.primary;
    lightButton = widget.lightButton ?? isLight();

    rippleColor = widget.rippleColor ??
        (lightButton
            ? Colors.black.withOpacity(0.3)
            : Colors.white.withOpacity(0.3));

    textColor = widget.textColor ?? Colors.white;
    borderColor = widget.borderColor ?? Colors.transparent;
    padding = widget.padding ?? const EdgeInsets.all(12);

    return RippleButton(
      enableShadow: widget.showShadow,
      shadow: BoxShadow(
        offset: const Offset(0, 4),
        blurRadius: 12,
        color: color.withOpacity(0.4),
      ),
      radius: widget.radius,
      border: widget.borderColor != null
          ? Border.all(
              color: widget.borderColor!,
              width: widget.borderWidth,
            )
          : null,
      lightButton: lightButton,
      text: widget.text,
      padding: EdgeInsets.zero,
      color: color,
      disableColor: widget.disableColor ?? Themes.black.withOpacity(0.2),
      onTap: widget.enable ? widget.onTap : null,
      child: Padding(
        padding: padding,
        child: widget.child ??
            Center(
              child: Text(
                widget.text ?? "",
                style: widget.buttonTextStyle ??
                    Themes().white14?.withColor(
                          (widget.onTap != null && widget.enable)
                              ? textColor
                              : Themes.white,
                        ),
              ),
            ),
      ),
    );
  }
}
