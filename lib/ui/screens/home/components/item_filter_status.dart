import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../../config/themes.dart';
import '../../../components/buttons/ripple_button.dart';
import '../provider/task_provider.dart';

class ItemFilterStatus extends ConsumerWidget {
  const ItemFilterStatus({
    Key? key,
    required this.status,
  }) : super(key: key);

  final String? status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RippleButton(
      onTap: !status.isNotNull
          ? () {
              GoRouter.of(context).push("/status-category");
            }
          : null,
      color: Themes.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      border: Border.all(
        color: Themes.stroke,
        width: 1,
      ),
      child: status.isNotNull
          ? Row(
              children: [
                Text(
                  status ?? "",
                  style: Themes().black14,
                ),
                const Icon(
                  Icons.close_rounded,
                  size: 18,
                ).onTap(() {
                  ref.read(taskProvider).removeStatusFilter(status ?? "");
                }).addMarginLeft(6),
              ],
            )
          : Row(
              children: [
                const Icon(
                  Icons.add_rounded,
                  size: 18,
                ).addMarginRight(6),
                Text(
                  "Add Status",
                  style: Themes().black14,
                )
              ],
            ),
    );
  }
}
