import 'package:flutter/material.dart';

import '../../../config/themes.dart';

class RippleButton extends StatefulWidget {
  final String? text;
  final VoidCallback? onTap;
  final LinearGradient? gradientColor;
  final Color? rippleColor;
  final Color? color;
  final Color? disableColor;
  final Color? textColor;
  final TextStyle? buttonTextStyle;
  final Widget? child;
  final EdgeInsets? padding;
  final Border? border;
  final double radius;
  final bool enableShadow;
  final bool lightButton;
  final MainAxisAlignment axisAlignment;
  final BorderRadius? borderRadius;
  final BoxShadow? shadow;

  const RippleButton({
    Key? key,
    this.text,
    this.onTap,
    this.gradientColor,
    this.color,
    this.disableColor,
    this.rippleColor,
    this.textColor,
    this.buttonTextStyle,
    this.child,
    this.padding,
    this.border,
    this.enableShadow = false,
    this.radius = 4,
    this.lightButton = true,
    this.axisAlignment = MainAxisAlignment.center,
    this.borderRadius,
    this.shadow,
  }) : super(key: key);

  @override
  RippleButtonState createState() => RippleButtonState();
}

class RippleButtonState extends State<RippleButton> {
  late Color rippleColor;
  late Color color;
  late Color textColor;
  late EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    rippleColor = widget.rippleColor ??
        (widget.lightButton
            ? Colors.black.withOpacity(0.1)
            : Colors.white.withOpacity(0.1));

    color = widget.color ?? Themes.transparent;
    textColor = widget.textColor ?? Colors.white;
    padding = widget.padding ?? const EdgeInsets.all(12);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      decoration: BoxDecoration(
        border: widget.border,
        color: widget.gradientColor != null
            ? null
            : widget.onTap != null
                ? color
                : widget.disableColor ?? color.withOpacity(0.2),
        borderRadius:
            widget.borderRadius ?? BorderRadius.circular(widget.radius),
        boxShadow: widget.onTap != null
            ? [
                if (widget.enableShadow)
                  widget.shadow ??
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                      )
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius:
            widget.borderRadius ?? BorderRadius.circular(widget.radius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            highlightColor: rippleColor.withOpacity(0.2),
            splashColor: rippleColor,
            onTap: widget.onTap,
            child: Padding(
              padding: padding,
              child: Center(
                child: widget.child ??
                    Text(
                      widget.text ?? "",
                      style: widget.buttonTextStyle ??
                          Themes().white14?.apply(
                                color: widget.onTap != null
                                    ? textColor
                                    : textColor.withOpacity(0.4),
                              ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
