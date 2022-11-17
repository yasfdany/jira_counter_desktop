import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/config/themes.dart';
import 'package:widget_helper/widget_helper.dart';

import '../provider/task_provider.dart';
import 'item_task.dart';

class TaskList extends ConsumerWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredIssue = ref.watch(taskProvider).filteredIssue;

    return Row(
      children: [
        Container(
          width: 1,
          height: double.infinity,
          color: Themes.stroke,
        ),
        Container(
          color: Colors.white,
          width: 300,
          height: double.infinity,
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: filteredIssue.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> issue = filteredIssue[index];

              return ItemTask(
                issue: issue,
              ).addMarginBottom(12);
            },
          ),
        ),
      ],
    );
  }
}
