import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/themes.dart';
import '../commons/flat_card.dart';

class TextArea extends StatefulWidget {
  final String? hint;
  final Widget? icon;
  final Widget? endIcon;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatter;
  final bool secureInput;
  final int? maxLenght;
  final int maxLine;
  final Function(String value)? onKeyUp;
  final Function(String value)? onChangedText;
  final Function(String value)? onSubmitText;
  final double? width;
  final double? height;
  final TextCapitalization textCapitalization;
  final MainAxisAlignment mainAxisAlignment;
  final Color? color;
  final bool enable;
  final bool error;
  final String errorMessage;
  final bool autoFocus;
  final TextAlign textAlign;
  final double? radius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final bool isDense;
  final Border? border;
  final bool italicHint;

  const TextArea({
    Key? key,
    this.padding,
    this.radius,
    this.hint,
    this.icon,
    this.endIcon,
    this.controller,
    this.inputType,
    this.secureInput = false,
    this.inputFormatter,
    this.maxLenght,
    this.maxLine = 1,
    this.onChangedText,
    this.width,
    this.height,
    this.onKeyUp,
    this.onSubmitText,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.color,
    this.enable = true,
    this.error = false,
    this.autoFocus = false,
    this.errorMessage = "",
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.hintTextStyle,
    this.isDense = false,
    this.border,
    this.italicHint = false,
  }) : super(key: key);

  @override
  TextAreaState createState() => TextAreaState();
}

class TextAreaState extends State<TextArea> {
  final FocusNode _focus = FocusNode();
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (widget.onKeyUp != null) widget.onKeyUp!(query);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatCard(
      borderRadius: BorderRadius.circular(widget.radius ?? 8),
      border: widget.border ??
          Border.all(
            color: Themes.stroke,
            width: 1,
          ),
      color: widget.color,
      width: widget.width,
      height: widget.height,
      child: Row(
        children: <Widget>[
          widget.icon ?? Container(),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: widget.mainAxisAlignment,
              children: <Widget>[
                Theme(
                  data: ThemeData(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionColor: Themes.primary.withOpacity(0.3),
                    ),
                  ),
                  child: TextField(
                    focusNode: _focus,
                    textAlign: widget.textAlign,
                    autofocus: widget.autoFocus,
                    enabled: widget.enable,
                    minLines: 1,
                    maxLines: widget.maxLine,
                    textCapitalization: widget.textCapitalization,
                    textInputAction: widget.textInputAction,
                    onSubmitted: (value) {
                      if (widget.onSubmitText != null) {
                        widget.onSubmitText!(value);
                      }
                    },
                    onChanged: (value) {
                      if (widget.onChangedText != null) {
                        widget.onChangedText!(value);
                      }

                      if (widget.onKeyUp != null) {
                        _onSearchChanged(value);
                      }
                    },
                    obscureText: widget.secureInput,
                    controller: widget.controller,
                    keyboardType: widget.inputType,
                    style: widget.textStyle ?? Themes().black14,
                    inputFormatters: widget.inputFormatter,
                    maxLength: widget.maxLenght,
                    cursorColor: Themes.primary,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      disabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      isDense: widget.isDense,
                      contentPadding: widget.padding ??
                          const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                      hintText: widget.hint,
                      hintStyle: widget.hintTextStyle ??
                          Themes(withLineHeight: false).black14?.apply(
                                color: Themes.hint,
                                fontStyle: widget.italicHint
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          widget.endIcon ?? Container(),
        ],
      ),
    );
  }
}
