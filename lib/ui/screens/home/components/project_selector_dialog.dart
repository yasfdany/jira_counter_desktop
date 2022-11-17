import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/utils/extensions.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../../config/themes.dart';
import '../../../../data/network/entity/jira_project_response.dart';
import '../../../components/buttons/ripple_button.dart';
import '../../../components/commons/flat_card.dart';
import '../provider/project_provider.dart';
import '../provider/task_provider.dart';

class ProjectSelectorDialog extends ConsumerWidget {
  const ProjectSelectorDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectProvider).projects;
    final selectedProject = ref.watch(projectProvider).selectedProject;
    final isWideScreen = context.isWideScreen;

    return Center(
      child: FlatCard(
        border: Border.all(color: Themes.stroke),
        width: isWideScreen ? 300 : 80.wp,
        height: 70.hp,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Project",
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
              padding: const EdgeInsets.all(18),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                JiraProject? project = projects[index];

                return RippleButton(
                  border: Border.all(
                      color: selectedProject?.id == project?.id
                          ? Themes.primary
                          : Colors.transparent),
                  onTap: () async {
                    ref.read(projectProvider).selectProject(project);
                    ref.read(taskProvider).getStatuses(reset: true);
                    ref.read(taskProvider).clearSelectedTask();
                    ref.read(taskProvider).getIssues(reset: true);
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project?.name ?? "",
                          style: Themes().blackBold16,
                        ),
                        Text(
                          project?.projectTypeKey ?? "",
                          style: Themes().black14,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ).addExpanded,
          ],
        ),
      ),
    );
  }
}
