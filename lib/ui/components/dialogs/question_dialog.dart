import 'package:flutter/material.dart';
import 'package:jira_counter/utils/extensions.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../config/themes.dart';
import '../buttons/primary_button.dart';

class QuestionDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String positiveText;
  final String negativeText;
  final bool negativeAction;

  const QuestionDialog({
    Key? key,
    this.title,
    this.message,
    this.onConfirm,
    this.onCancel,
    this.positiveText = "Ok",
    this.negativeText = "Cancel",
    this.negativeAction = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = context.isWideScreen;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(24),
          width: isWideScreen ? 300 : 80.wp,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (title != null) Text(title ?? "", style: Themes().blackBold16),
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
                margin: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PrimaryButton(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      lightButton: true,
                      onTap: onCancel,
                      color: Themes.white,
                      text: negativeText,
                      borderColor: Themes.stroke,
                      textColor: Themes.black,
                      buttonTextStyle: Themes().blackBold14,
                    ).addExpanded,
                    Container(
                      width: 16,
                    ),
                    PrimaryButton(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      onTap: onConfirm,
                      lightButton: false,
                      color: negativeAction ? Themes.red : Themes.primary,
                      text: positiveText,
                      buttonTextStyle: Themes().whiteBold14,
                    ).addExpanded,
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
