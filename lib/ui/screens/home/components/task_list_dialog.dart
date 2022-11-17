import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/config/themes.dart';
import 'package:jira_counter/utils/extensions.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../components/buttons/ripple_button.dart';
import '../../../components/commons/flat_card.dart';
import '../provider/task_provider.dart';
import 'item_task.dart';

class TaskListDialog extends ConsumerWidget {
  const TaskListDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredIssue = ref.watch(taskProvider).filteredIssue;
    final isWideScreen = context.isWideScreen;

    return Center(
      child: FlatCard(
        border: Border.all(color: Themes.stroke),
        width: isWideScreen ? 300 : 80.wp,
        height: 70.hp,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Task List",
                  style: Themes().blackBold16,
                ),
                RippleButton(
                  padding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close_rounded,
                  ),
                ),
              ],
            ).addAllMargin(18),
            Container(
              width: double.infinity,
              height: 1,
              color: Themes.stroke,
            ),
            ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: filteredIssue.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> issue = filteredIssue[index];

                return ItemTask(
                  issue: issue,
                ).addMarginBottom(12);
              },
            ).addExpanded,
          ],
        ),
      ),
    );
  }
}
