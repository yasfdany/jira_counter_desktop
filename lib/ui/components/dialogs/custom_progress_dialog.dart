import 'package:flutter/material.dart';
import 'package:jira_counter/utils/extensions.dart';

import '../../../config/themes.dart';

class CustomProgressDialog extends StatelessWidget {
  const CustomProgressDialog({
    Key? key,
    this.title,
    this.message,
  }) : super(key: key);

  final String? title;
  final String? message;

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
              Text(title ?? "", style: Themes().blackBold18),
              Container(
                margin: const EdgeInsets.only(top: 18),
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 18),
                        child: Text(
                          message ?? "",
                          style: Themes(withLineHeight: true).black14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
