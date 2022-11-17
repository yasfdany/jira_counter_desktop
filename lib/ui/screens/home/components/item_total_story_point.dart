import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/utils/extensions.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../../config/themes.dart';
import '../../../../data/model/story_point_data.dart';
import '../../../components/buttons/ripple_button.dart';
import '../provider/task_provider.dart';
import 'task_list_dialog.dart';

class ItemTotalStoryPoint extends ConsumerWidget {
  const ItemTotalStoryPoint({
    Key? key,
    required this.stroyPointData,
  }) : super(key: key);

  final StroyPointData stroyPointData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccountId = ref.watch(taskProvider).selectedAccountId;
    final isWideScreen = context.isWideScreen;

    return RippleButton(
      onTap: () {
        ref
            .read(taskProvider)
            .doFilterIssueByAssignee(stroyPointData.accountId);
        if (!isWideScreen) {
          showDialog(
            context: context,
            builder: ((context) => const TaskListDialog()),
          );
        }
      },
      color: Themes.white,
      padding: const EdgeInsets.all(24),
      border: Border.all(
        color: selectedAccountId == stroyPointData.accountId && isWideScreen
            ? Themes.primary
            : Themes.stroke,
        width: 1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            stroyPointData.name,
            style: Themes().black14,
          ).addFlexible,
          Text(
            stroyPointData.point.toString(),
            style: Themes().black14,
          ),
        ],
      ),
    );
  }
}
