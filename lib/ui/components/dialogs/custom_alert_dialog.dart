import 'package:flutter/material.dart';
import 'package:jira_counter/utils/extensions.dart';

import '../../../config/themes.dart';
import '../buttons/primary_button.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key,
    this.title,
    this.message,
    this.onConfirm,
    this.buttonText = "OK",
  }) : super(key: key);

  final String? title;
  final String? message;
  final VoidCallback? onConfirm;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = context.isWideScreen;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(24),
          width: isWideScreen ? 300 : 80.wp,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title ?? "", style: Themes().blackBold16),
              Container(
                margin: const EdgeInsets.only(top: 4),
                child: Text(
                  message ?? "",
                  style: Themes(withLineHeight: true)
                      .black14
                      ?.apply(color: Themes.grey),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 24),
                child: PrimaryButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  text: buttonText,
                  buttonTextStyle: Themes().whiteBold14,
                  onTap: onConfirm ??
                      () {
                        Navigator.pop(context);
                      },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
