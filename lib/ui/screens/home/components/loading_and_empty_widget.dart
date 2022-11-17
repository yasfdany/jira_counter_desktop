import 'package:flutter/material.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../../config/themes.dart';

class LoadingAndEmptyWidget extends StatelessWidget {
  final bool loading;
  const LoadingAndEmptyWidget({
    Key? key,
    required this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Themes.primary),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.paste_rounded,
                color: Themes.stroke,
                size: 120,
              ),
              Text(
                "No Data Found",
                style: Themes()
                    .blackBold20
                    ?.copyWith(color: Themes.black.withOpacity(0.4)),
              ).addMarginTop(24),
              Text(
                "Try to apply some filter status",
                style: Themes()
                    .black14
                    ?.copyWith(color: Themes.black.withOpacity(0.4)),
              ).addMarginTop(2)
            ],
          );
  }
}
