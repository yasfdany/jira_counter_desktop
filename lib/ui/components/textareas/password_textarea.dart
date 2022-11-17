import 'package:widget_helper/widget_helper.dart';
import 'package:flutter/material.dart';

import '../../../config/themes.dart';
import '../buttons/ripple_button.dart';
import 'textarea.dart';

class PasswordTextarea extends StatefulWidget {
  final String? hint;
  final TextEditingController? controller;
  final bool visibilitButton;

  const PasswordTextarea({
    super.key,
    this.controller,
    this.hint,
    this.visibilitButton = true,
  });

  @override
  PasswordTextareaState createState() => PasswordTextareaState();
}

class PasswordTextareaState extends State<PasswordTextarea> {
  final ValueNotifier<bool> visible = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: visible,
      builder: (context, visibility, _) {
        return TextArea(
          controller: widget.controller,
          secureInput: !visibility,
          hint: widget.hint,
          endIcon: widget.visibilitButton
              ? RippleButton(
                  padding: const EdgeInsets.all(8),
                  radius: 32,
                  lightButton: true,
                  color: Colors.white,
                  onTap: () {
                    setState(() {
                      visible.value = !visibility;
                    });
                  },
                  child: Icon(
                    visibility
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    size: 20,
                    color: Themes.primary,
                  ),
                ).addMarginRight(4)
              : null,
        );
      },
    );
  }
}
