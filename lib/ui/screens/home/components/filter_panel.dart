import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../../config/themes.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/ripple_button.dart';
import '../../../components/commons/flat_card.dart';
import '../provider/project_provider.dart';
import '../provider/task_provider.dart';
import 'project_selector_dialog.dart';

class FilterPanel extends ConsumerWidget {
  const FilterPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(taskProvider).selectedStatus;
    final project = ref.watch(projectProvider).selectedProject;
    final statuses = ref.watch(taskProvider).statuses;
    final loading = ref.watch(taskProvider).loading;

    return SizedBox(
      width: 280,
      child: FlatCard(
        borderRadius: BorderRadius.zero,
        border: Border.all(color: Themes.stroke),
        color: Themes.white,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 80,
              child: RippleButton(
                onTap: !loading
                    ? () {
                        showDialog(
                          context: context,
                          builder: ((context) => const ProjectSelectorDialog()),
                        );
                      }
                    : null,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                borderRadius: BorderRadius.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          project?.name ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Themes().blackBold16,
                        ),
                        Text(
                          project?.projectTypeKey ?? "",
                          style: Themes().black14,
                        ),
                      ],
                    ).addExpanded,
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Themes.stroke,
            ),
            ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: statuses.length,
              itemBuilder: (context, index) {
                return RippleButton(
                  color: Themes.white,
                  border: Border.all(
                    color: selectedStatus.contains(statuses[index])
                        ? Themes.primary
                        : Themes.stroke,
                    width: 1,
                  ),
                  onTap: () {
                    ref.read(taskProvider).addStatusFilter(statuses[index]);
                  },
                  textColor: Themes.black,
                  child: Row(
                    children: [
                      Text(
                        statuses[index],
                        style: Themes().black14,
                      ).addFlexible,
                    ],
                  ),
                ).addMarginBottom(12);
              },
            ).addExpanded,
            Container(
              width: double.infinity,
              height: 1,
              color: Themes.stroke,
            ),
            PrimaryButton(
              enable: !loading,
              onTap: () {
                ref.read(taskProvider).getIssues(reset: true);
              },
              text: "Apply Filter",
            ).addAllMargin(18)
          ],
        ),
      ),
    );
  }
}
